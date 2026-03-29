[Source: Mrbeefy Status]

# **🌐 Day 5: The Frontend Gauntlet**

This was the final boss fight.

CloudFront.  
API Gateway.  
HTTP API stages.  
Origin paths.  
Behaviors.  
Allowed methods.  
OAC.  
S3.  
CORS.  
React.  
Routing.  
404s.  
403s.  
Terraform state.  
Cache invalidation.  
Path patterns.  

It was like AWS threw the entire alphabet soup at me.

But I kept peeling back layers until the truth finally revealed itself:

- HTTP APIs don’t use stage names in the URL  
- CloudFront was forwarding `/chat` to `/chat`  
- API Gateway expected `/prod/chat`  
- CloudFront needed `origin_path = "/prod"`  
- `/prod/chat` was falling back to S3 and 403ing  
- `/chat` was hitting API Gateway and 404ing  
- The fix was a single line that required **deep** understanding to even see  

And when it clicked, the whole system snapped into place.

The UI worked.  
The backend worked.  
The agent worked.  
The domain worked.  
The architecture worked.  

That was the moment I knew:  
**I had actually done it.**

---