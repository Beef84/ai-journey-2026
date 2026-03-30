[Source: Mrbeefy Design Decisions]

## **5.3 Environment Variables**
Lambda receives:

- `AGENT_ID`
- `AGENT_ALIAS_ID`
- `KB_ID`

`AGENT_ALIAS_ID` and `KB_ID` are placeholders in Terraform; CI/CD overwrites them with real values after alias creation and KB setup.

---

# **6. Bedrock Agent Design Decisions**