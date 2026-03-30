[Source: Mrbeefy Cost Analysis]

# **7. Summary**

Mr. Beefy costs almost nothing at personal/portfolio scale:

- **Idle:** ~$0.50/month (Route53 only)
- **Light personal use:** ~$0.75–$1.00/month
- **Active demo traffic:** ~$2–$5/month
- **Dev environment:** <$0.01/month when idle

Bedrock Claude 3.5 Haiku token costs dominate everything else. All other services (Lambda, CloudFront, S3) are effectively rounding errors at this usage level. API Gateway has been removed from the architecture — its cost was $0.001/month at light use and it is no longer needed.

Streaming is implemented at zero additional cost. The architectural decisions documented in section 5 reflect cost awareness as a first-class engineering concern throughout the build.

---