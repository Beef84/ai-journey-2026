[Source: Mrbeefy Architecture | Section: 10.2 Dev Access Control]

## **10.2 Dev Access Control**
The dev CloudFront distribution enforces **signed cookies**:

1. Developer generates an RSA key pair locally (private key never leaves the machine)
2. Public key is uploaded to CloudFront via Terraform as a trusted key group
3. Developer generates a signed cookie offline using the private key (valid window of their choice)
4. Cookie is set in the browser once — all requests to `dev.mrbeefy.academy` are then authorized
5. Anyone without a valid signed cookie receives a 403

See the Workflow wiki for the step-by-step signed cookie setup.