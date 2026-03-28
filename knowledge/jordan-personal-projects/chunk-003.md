- Modular NuGet‑based architecture (DbContext, Models, Business Logic, API Client SDK) enabling clean separation of concerns and long‑term maintainability
- Built with EF Core, SQL Server, and a Razor‑based UI, with custom forecasting and budgeting logic
- Repo hosted in Azure DevOps; application self‑hosted at home using Windows/IIS
- Used daily for budgeting, forecasting, and financial planning

## Deep Dive Into the Multi-tenant architecture of Your Life

### Overview
I’m currently designing the multi‑tenant architecture for Your Life, a SaaS platform built around the idea that every user should have their own private digital universe supported by persistent AI agents that carry context forward. Because the platform spans private, collaborative, community, and public layers, multi‑tenancy and distributed system design are central to every decision I make. The system is evolving with privacy, isolation, and predictable scaling as first‑class architectural principles.

### Isolation and data boundaries