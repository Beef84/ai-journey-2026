import {
    BedrockAgentRuntimeClient,
    InvokeAgentCommand
} from "@aws-sdk/client-bedrock-agent-runtime";

// awslambda is a global provided by the Node.js 20 Lambda runtime.
// It is not an npm package — declare it here for TypeScript.
declare const awslambda: {
    streamifyResponse: (
        handler: (event: any, responseStream: any, context: any) => Promise<void>
    ) => any;
    HttpResponseStream: {
        from: (
            responseStream: any,
            metadata: { statusCode: number; headers: Record<string, string> }
        ) => any;
    };
};

// Explicit region is REQUIRED for Bedrock Agent Runtime.
// Never rely on implicit region resolution inside Lambda.
const client = new BedrockAgentRuntimeClient({
    region: process.env.AWS_REGION || "us-east-1"
});

export const handler = awslambda.streamifyResponse(async (event: any, responseStream: any) => {
    console.log("=== Incoming Event ===");
    console.log(JSON.stringify(event, null, 2));

    // Reject any request that did not come through CloudFront.
    // CloudFront injects x-cloudfront-secret on every forwarded request;
    // direct calls to the Function URL will be missing it.
    const expectedSecret = process.env.GATEWAY_SECRET;
    const incomingSecret = event.headers?.["x-cloudfront-secret"];
    if (!expectedSecret || incomingSecret !== expectedSecret) {
        const errStream = awslambda.HttpResponseStream.from(responseStream, {
            statusCode: 403,
            headers: { "Content-Type": "application/json" }
        });
        errStream.write(JSON.stringify({ error: "Forbidden" }));
        errStream.end();
        return;
    }

    const body =
        typeof event.body === "string"
            ? JSON.parse(event.body)
            : event.body || {};

    const inputText = body.input ?? "Hello, Mr. Beefy";
    const agentId = process.env.AGENT_ID;
    const aliasId = process.env.AGENT_ALIAS_ID;

    console.log("Agent ID:", agentId);
    console.log("Alias ID:", aliasId);
    console.log("Input text:", inputText);

    const httpStream = awslambda.HttpResponseStream.from(responseStream, {
        statusCode: 200,
        headers: {
            "Content-Type": "text/event-stream",
            "Cache-Control": "no-cache",
            // Tells nginx-style proxies not to buffer — CloudFront respects this.
            "X-Accel-Buffering": "no",
        }
    });

    try {
        const command = new InvokeAgentCommand({
            agentId,
            agentAliasId: aliasId,
            sessionId: "web-" + Date.now().toString(),
            inputText
        });

        console.log("Sending InvokeAgentCommand:", { agentId, aliasId, inputText });

        const response = await client.send(command);

        if (response.completion) {
            for await (const chunk of response.completion) {
                if (chunk.chunk?.bytes) {
                    const decoded = new TextDecoder().decode(chunk.chunk.bytes);
                    console.log("Chunk:", decoded);
                    httpStream.write(`data: ${JSON.stringify({ token: decoded })}\n\n`);
                }
            }
        }

        httpStream.write("data: [DONE]\n\n");

    } catch (err: any) {
        console.error("=== ERROR invoking Bedrock Agent ===");
        console.error(err);
        httpStream.write(`data: ${JSON.stringify({ error: err.message || String(err) })}\n\n`);
    } finally {
        httpStream.end();
    }
});
