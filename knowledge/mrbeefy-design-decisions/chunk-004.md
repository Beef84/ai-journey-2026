| WebSocket (API Gateway) | API Gateway WebSocket adds cost per connection-minute on top of per-message fees |

SSE (Server-Sent Events) over a regular `POST` request is the right fit here:
- One-way delivery (server → browser) matches the use case exactly
- Works with standard `fetch` + `ReadableStream` — no special browser API
- No persistent connection state to manage
- CloudFront handles it natively when `compress = false` is set on the behavior

---

# **4. CloudFront Design Decisions**

## **4.1 CloudFront as the Routing Layer**
CloudFront was chosen to:

- Serve static assets globally
- Terminate TLS
- Route `/chat` to the Lambda Function URL origin
- Apply security headers
- Enforce caching policies
- Protect S3 via OAC

## **4.2 Two-Origin Architecture**
CloudFront uses:

1. **S3 Origin**
   - For static frontend assets
   - Protected by OAC
   - No public access

2. **Lambda Function URL Origin**
   - For dynamic `/chat` requests
   - HTTPS-only
   - No `origin_path` — requests go directly to the function
   - `compress = false` — required to prevent SSE stream buffering

## **4.3 Behavior Design**
- Default behavior → S3
- Ordered behavior → `/chat` → Lambda Function URL

This ensures:
