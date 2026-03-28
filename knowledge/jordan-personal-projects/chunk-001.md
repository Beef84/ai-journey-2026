# Jordan — Personal Projects

This document showcases Jordan's personal projects.

## Mr. Beefy — AI Infrastructure & Interactive Resume Platform

- Fully serverless AI agent hosted at https://mrbeefy.academy
- Built on AWS using Bedrock Agents, Lambda, API Gateway (HTTP), S3 with CloudFront (OAC), SNS for event notifications, and Terraform for all infrastructure
- React frontend with dynamic agent interaction and knowledge‑driven routing
- Custom ingestion pipeline using S3 events, vector embeddings, and retrieval‑augmented generation
- Codebase hosted in GitHub with GitHub Actions for CI/CD, automated deployments, and environment promotion

## Your Life — Multi‑Tenant AI SaaS Platform (In Development)

- Architected around three independently scalable planes:
  - Control Plane: identity, tenant provisioning, metadata, configuration, and global orchestration
  - Tenant Plane: user‑facing APIs, private agents, ingestion endpoints, and tenant‑isolated data stores
  - AI Plane: ingestion, embeddings, analytics, and generative AI workflows