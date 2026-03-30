[Source: Mrbeefy Status | Section: What Changed > PowerShell 5.1 Encoding Fix]

### **PowerShell 5.1 Encoding Fix**
PowerShell 5.1 reads `.ps1` files using the system ANSI code page (Windows-1252) rather than UTF-8. The em dash character (`—`, U+2014) encodes to bytes `E2 80 94` in UTF-8; byte `0x94` maps to `"` (right double quotation mark) in Windows-1252, which PowerShell 5.1 treats as a string terminator. This caused silent string truncation mid-line and cascading parse errors. All scripts now use only ASCII characters.

---