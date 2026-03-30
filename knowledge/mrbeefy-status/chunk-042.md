[Source: Mrbeefy Status | Section: What Changed]

### **KB_ID in Lambda Environment**
`KB_ID` is now a first-class Lambda environment variable — placeholder in Terraform, injected by CI/CD after KB setup alongside `AGENT_ALIAS_ID`.

### **wiki-sync.yml Simplified**
The `Rebuild knowledge directory` step is now three lines:
```yaml
rm -rf knowledge
mkdir knowledge
python3 scripts/chunker.py --wiki-dir wiki --out-dir knowledge
```