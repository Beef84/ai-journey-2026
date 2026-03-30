# 🐄 **Mr. Beefy — Repository Overview (Directory by Directory)**  
*A technical walkthrough of the system architecture, engineering practices, and operational design behind this project.*

This repository contains **Mr. Beefy**, a fully deployed, production‑style serverless AI agent that functions as an **interactive resume**, a **personal knowledge engine**, and a **demonstration of my engineering approach**.  

It is designed to show senior engineers and hiring committees how I structure systems, automate infrastructure, manage knowledge, and build reliable AI‑driven applications on AWS.

The repo is intentionally organized to reflect **real production patterns**: clear separation of concerns, Infrastructure‑as‑Code, automated documentation pipelines, and environment‑aware CI/CD.

---

# 🚀 **High‑Level Architecture (Concise + Engineering‑Focused)**

Mr. Beefy is built using a modern, cloud‑native architecture aligned with current AI platform best practices:

- **Frontend** — React + Vite SPA hosted on S3 and delivered via CloudFront with OAC.  
- **Backend** — Serverless Lambda runtime providing a streaming API/Function URL for low‑latency responses.  
- **AI Layer** — AWS Bedrock Agents orchestrating reasoning and retrieval from a vectorized knowledge base stored in S3.  
- **IaC** — Terraform modules provisioning CDN, certificates, storage, Bedrock agent, knowledge bucket, Lambda/API, and IAM.  
- **CI/CD** — GitHub Actions automating builds, deploys, and wiki→knowledge synchronization.

The system is designed for **reproducibility, maintainability, and operational clarity**.

---

# 📁 **Directory Breakdown (Tailored for Engineers)**

## **/frontend**
Implements the public interface and delivery pipeline.

- **UI/** — React + Vite SPA (HTML, JSX, CSS, client logic).  
  Key files: `index.html`, `vite.config.js`, `package.json`, `src/`.

- **IaC/** — Terraform modules for frontend infrastructure:  
  - `cdn/` — CloudFront distribution with OAC  
  - `certificate/` — TLS certificates  
  - `storage/` — S3 hosting bucket  

This layer demonstrates secure static hosting, CDN configuration, and frontend deployment automation.

---

## **/backend**
Implements the runtime that connects the UI to AWS Bedrock.

- **lambda/** — TypeScript Lambda implementing the Bedrock Agent runtime and SSE streaming.  
  Key files: `handler.ts`, `package.json`, `tsconfig.json`.

- **IaC/** — Terraform modules defining the AI system:  
  - `bedrock_agent/` — Agent configuration and orchestration  
  - `knowledge_bucket/` — S3 bucket for vectorized knowledge  
  - `lambda_api/` — Lambda + API Gateway or Function URL  
  - IAM policies for least‑privilege access  

- **cli/** — Local + CI helper scripts for knowledge ingestion and Bedrock configuration.  
  Includes PowerShell tools like `ingest.ps1`, `create_kb.ps1`, `associate_kb.ps1`.

This layer demonstrates serverless backend design, AI runtime integration, and operational tooling.

---

## **/knowledge**
The structured knowledge base powering retrieval.

- Contains **generated Markdown chunks** used as source documents for the vector KB.  
- Covers two domains:  
  - **Human (Jordan)** — career summary, skills, goals, projects, engineering philosophy, work style  
  - **System (Mr. Beefy)** — architecture, workflows, design decisions, governance, cost analysis, system status  

### **Important for reviewers**
This directory is **machine‑generated** by the workflow:

```
.github/workflows/wiki-sync.yml
```

The workflow:

1. Pulls the GitHub wiki  
2. Splits pages into context‑aware chunks  
3. Generates Markdown  
4. Opens an automated PR to update `/knowledge`  

This demonstrates:

- automated documentation pipelines  
- RAG‑ready content generation  
- clean separation of human‑authored vs. machine‑generated artifacts  
- reproducible knowledge ingestion  

---

## **/scripts**
Developer tools supporting local testing and secure dev flows.

Notable scripts:

- `gen-dev-cookies.ps1` — Generate signed CloudFront cookies  
- `open-dev.ps1` — Launch Edge and inject cookies via CDP  
- `set-cf-cookies.js` — Node tool for CDP WebSocket cookie injection  

Requirements:

- PowerShell 7+  
- Node.js ≥ 22.12  
- Microsoft Edge (for CDP flows)

This directory demonstrates developer experience design and secure local testing workflows.

---

## **/.github/workflows**
CI/CD automation for the entire system.

Key workflows:

- **deploy-frontend.yml** — Builds and deploys the SPA + frontend IaC  
- **deploy-backend.yml** — Builds and deploys the Lambda runtime + backend IaC  
- **wiki-sync.yml** — Syncs the GitHub wiki into `/knowledge` via automated PR  
- **deploy-knowledge.yml** — Uploads `/knowledge` to S3 and triggers Bedrock ingestion  

This demonstrates multi‑pipeline orchestration, environment‑aware deploys, and automated knowledge ingestion.

---

# 🏡 **Repository Root Files**
- **README.md** — High‑level summary and navigation  
- **LICENSE** and other metadata files  

---

# ⚡ **Developer Quick Notes**
- **Node.js** — Use Node ≥ 22.12 for Vite compatibility  
- **PowerShell** — Use PowerShell 7+ (`pwsh`)  
- **Edge/CDP** — Launch Edge with `--remote-debugging-port=9222` for cookie helpers  

---

# 📘 **Documentation**
All canonical documentation — architecture, runbooks, workflows, governance — lives in the wiki:

**https://github.com/BeefAISoftware/Mr.Beefy/wiki**

The wiki is the source of truth.  
Automation transforms it into `/knowledge`.  
Mr. Beefy learns from the result.

---