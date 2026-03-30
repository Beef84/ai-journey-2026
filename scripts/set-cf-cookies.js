#!/usr/bin/env node
/**
 * set-cf-cookies.js
 * Sets CloudFront signed cookies in a running Edge/Chrome instance via CDP,
 * then navigates to the site. Called by open-dev.sh — not meant to be run directly.
 *
 * Uses only built-in Node.js modules (http, net, crypto) — no npm install needed.
 * Requires Edge running with: --remote-debugging-port=9222
 *
 * Usage: node set-cf-cookies.js <domain> <keyPairId> <policy> <sig> <expiry>
 */
'use strict';

const [, , domain, keyPairId, policy, sig, expiryStr] = process.argv;
if (!domain || !keyPairId || !policy || !sig || !expiryStr) {
  console.error('Usage: node set-cf-cookies.js <domain> <keyPairId> <policy> <sig> <expiry>');
  process.exit(1);
}

const expiry   = parseInt(expiryStr, 10);
const http     = require('http');
const net      = require('net');
const crypto   = require('crypto');
const CDP_PORT = 9222;
// Timeouts (ms)
const HTTP_TIMEOUT = 8000; // timeout when fetching /json
const WS_UPGRADE_TIMEOUT = 8000; // timeout waiting for websocket upgrade/connect

// Build a masked WebSocket text frame (RFC 6455 §5.3 — client→server frames must be masked).
function makeFrame(text) {
  const data = Buffer.from(text, 'utf8');
  const len  = data.length;
  const mask = crypto.randomBytes(4);
  let header;

  if (len <= 125) {
    header = Buffer.alloc(6);
    header[0] = 0x81;          // FIN + text opcode
    header[1] = 0x80 | len;    // MASK bit + 1-byte length
    mask.copy(header, 2);
  } else {
    // 2-byte extended length — handles up to 65535 bytes (plenty for CDP payloads)
    header = Buffer.alloc(8);
    header[0] = 0x81;
    header[1] = 0xFE;          // MASK bit + extended-length marker
    header.writeUInt16BE(len, 2);
    mask.copy(header, 4);
  }

  const masked = Buffer.allocUnsafe(len);
  for (let i = 0; i < len; i++) masked[i] = data[i] ^ mask[i % 4];
  return Buffer.concat([header, masked]);
}

// Minimal CDP-over-WebSocket client using only built-in Node.js modules.
function wsConnect(wsUrl) {
  return new Promise((resolve, reject) => {
    const url     = new URL(wsUrl);
    const key     = crypto.randomBytes(16).toString('base64');
    const socket  = net.createConnection(parseInt(url.port) || CDP_PORT, url.hostname);
    const waiters = new Map(); // cdp command id → resolve
    let   buf     = Buffer.alloc(0);
    let   upgraded = false;

    function parseFrames() {
      while (buf.length >= 2) {
        const opcode     = buf[0] & 0x0f;
        const isMasked   = (buf[1] & 0x80) !== 0;
        let   payloadLen = buf[1] & 0x7f;
        let   offset     = 2;

        if (payloadLen === 126) {
          if (buf.length < 4) break;
          payloadLen = buf.readUInt16BE(2);
          offset = 4;
        } else if (payloadLen === 127) {
          if (buf.length < 10) break;
          // Use lower 32 bits (CDP responses are never that large)
          payloadLen = buf.readUInt32BE(6);
          offset = 10;
        }

        if (isMasked) offset += 4;
        if (buf.length < offset + payloadLen) break;

        const payload = buf.slice(offset, offset + payloadLen).toString('utf8');
        buf = buf.slice(offset + payloadLen);

        if (opcode === 1 || opcode === 0) { // text frame or continuation
          try {
            const msg = JSON.parse(payload);
            if (msg.id != null && waiters.has(msg.id)) {
              waiters.get(msg.id)(msg);
              waiters.delete(msg.id);
            }
          } catch (_) {}
        }
      }
    }

    // Drain all pending waiters when the socket closes/errors — prevents infinite hangs.
    function drainWaiters(reason) {
      for (const [, cb] of waiters) cb({ error: { message: reason } });
      waiters.clear();
    }

    const api = {
      send(id, method, params = {}) {
        return new Promise((res, rej) => {
          // 8-second timeout per command so a dead socket never hangs forever.
          const timer = setTimeout(() => {
            waiters.delete(id);
            rej(new Error(`CDP timeout waiting for response to ${method}`));
          }, 8000);
          waiters.set(id, (msg) => { clearTimeout(timer); res(msg); });
          socket.write(makeFrame(JSON.stringify({ id, method, params })));
        });
      },
      close() { socket.end(); },
    };

    // Fail fast if the socket doesn't connect/upgrade in time
    const upgradeTimer = setTimeout(() => {
      socket.destroy();
      reject(new Error('WebSocket upgrade/connect timeout'));
    }, WS_UPGRADE_TIMEOUT);

    socket.on('connect', () => {
      // connected at TCP level; proceed with upgrade request
      socket.write([
        `GET ${url.pathname} HTTP/1.1`,
        `Host: ${url.host}`,
        `Upgrade: websocket`,
        `Connection: Upgrade`,
        `Sec-WebSocket-Key: ${key}`,
        `Sec-WebSocket-Version: 13`,
        '', '',
      ].join('\r\n'));
    });

    socket.on('data', (chunk) => {
      if (!upgraded) {
        if (!chunk.toString('binary').includes('101 ')) return;
        upgraded = true;
        // Capture any WebSocket data that arrived after the HTTP headers
        const headerEnd = chunk.indexOf('\r\n\r\n');
        const rest = headerEnd >= 0 ? chunk.slice(headerEnd + 4) : Buffer.alloc(0);
        if (rest.length) { buf = rest; parseFrames(); }
        resolve(api);
        return;
      }
      buf = Buffer.concat([buf, chunk]);
      parseFrames();
    });

    socket.on('close', () => drainWaiters('socket closed by Edge'));
    socket.on('error', (err) => { drainWaiters(err.message); reject(err); });
  });
}

async function main() {
  // Get the list of open tabs via CDP's HTTP endpoint
  const tabs = await new Promise((resolve, reject) => {
    http.get(`http://127.0.0.1:${CDP_PORT}/json`, res => {
      let raw = '';
      res.on('data', d => raw += d);
      res.on('end', () => resolve(JSON.parse(raw)));
    }).on('error', reject);
  });

  // Prefer a tab already on the target domain; fall back to any page tab
  const tab = tabs.find(t => t.type === 'page' && t.url.includes(domain))
           || tabs.find(t => t.type === 'page')
           || tabs[0];

  if (!tab?.webSocketDebuggerUrl) {
    console.error(`No browser tab found at localhost:${CDP_PORT}. ` +
      `Make sure Edge is running with --remote-debugging-port=${CDP_PORT}`);
    process.exit(1);
  }

  const ws = await wsConnect(tab.webSocketDebuggerUrl);
  let id = 1;

  await ws.send(id++, 'Network.enable');

  for (const [name, value] of [
    ['CloudFront-Policy',      policy   ],
    ['CloudFront-Signature',   sig      ],
    ['CloudFront-Key-Pair-Id', keyPairId],
  ]) {
    const r = await ws.send(id++, 'Network.setCookie', {
      name,
      value,
      url:     `https://${domain}/`,
      domain,
      path:    '/',
      secure:  true,
      expires: expiry,
    });
    console.log(`  ${r.result?.success !== false ? '✓' : '✗'} ${name}`);
  }

  await ws.send(id++, 'Page.navigate', { url: `https://${domain}/` });
  console.log(`Navigating to https://${domain}/`);

  // Give Edge a moment to start the navigation before closing the socket
  await new Promise(r => setTimeout(r, 500));
  ws.close();
}

main().catch(err => {
  console.error('Error:', err.message || err);
  process.exit(1);
});
