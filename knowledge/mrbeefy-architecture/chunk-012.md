[Source: Mrbeefy Architecture | Section: 3.2 Gateway Secret]

## **3.2 Gateway Secret**
CloudFront injects `x-cloudfront-secret` as a custom header on every request forwarded to the Function URL origin. Lambda checks this header before doing anything else and returns 403 if it is absent or wrong.

The raw Function URL (`https://<id>.lambda-url.us-east-1.on.aws`) is publicly reachable by anyone who discovers it, but without the secret header every request is rejected immediately.