[Source: Mrbeefy Architecture]

# **2. Frontend Architecture**

## **2.1 Static Hosting**
- React SPA built and uploaded to an S3 bucket:
  - Bucket name pattern: `mrbeefy-frontend-<random>`  
  - Public access fully blocked  
  - Access controlled exclusively through CloudFront OAC