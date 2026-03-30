[Source: Mrbeefy Design Decisions | Section: 3.2 Single Endpoint: `POST /chat`]

## **3.2 Single Endpoint: `POST /chat`**
The system exposes only one route. This keeps the attack surface minimal, the contract simple, and the frontend integration straightforward. The Function URL receives all requests; Lambda routes internally by HTTP method if needed.