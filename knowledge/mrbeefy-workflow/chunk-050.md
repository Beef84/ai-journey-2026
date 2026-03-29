[Source: Mrbeefy Workflow | Section: 9.8 Generate a Signed Cookie for Browser Access (Dev only)]

## **9.8 Generate a Signed Cookie for Browser Access** *(Dev only)*

> **What this does:** Produces three cookie values that grant your browser access to `dev.mrbeefy.academy`. Without them, CloudFront returns 403. The cookies expire after the window you set — regenerate them when they do.

Install the signing tool (one time):
```bash
npm install -g aws-cloudfront-sign
```

Generate the cookies. Replace `YOUR_KEY_PAIR_ID` with the value from step 9.7:
```bash
CF_KEY_PAIR_ID="YOUR_KEY_PAIR_ID"

node -e "
const cf = require('aws-cloudfront-sign');
const cookies = cf.getSignedCookies('https://dev.mrbeefy.academy/*', {
  keypairId: '$CF_KEY_PAIR_ID',
  privateKeyPath: './cf-dev-private.pem',
  expireTime: Math.floor(Date.now() / 1000) + 86400  // 24 hours
});
console.log(JSON.stringify(cookies, null, 2));
"
```

The output will look like:
```json
{
  "CloudFront-Policy": "eyJTdGF0ZW...",
  "CloudFront-Signature": "nqX3Td...",
  "CloudFront-Key-Pair-Id": "APKA..."
}
```

Copy all three values for the next step.

---