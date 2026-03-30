[Source: Jordan Engineering Philosophy]

# **2. Separate Declarative and Dynamic Concerns**

This is one of my core engineering beliefs.

- **Infrastructure‑as‑Code (IaC)** owns static, long‑lived infrastructure  
- **CI/CD** owns dynamic, versioned, stateful operations  
- **Runtime** owns execution, not configuration  

Mixing these responsibilities creates drift, brittleness, and unpredictable deployments.

By separating them:

- Infrastructure stays reproducible  
- Agent lifecycle stays flexible  
- Deployments stay clean  
- Debugging stays sane  

This principle shaped the entire Mr. Beefy architecture.

---