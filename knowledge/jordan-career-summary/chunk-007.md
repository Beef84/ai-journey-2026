[Source: Jordan Career Summary | Section: Dick's Sporting Goods — Production incident: signage system]

## Dick's Sporting Goods — Production incident: signage system

### Incident summary
When we rolled out the new signage system at Dick’s Sporting Goods, everything ran smoothly for the first couple of weeks. The platform was a complete overhaul of the legacy system, and all three brands had already created their new templates using the new tooling, so there was no fallback path. The first real test came during a major sales period, when stores began generating a much higher volume of signs. Under that load, the WCF service I had built began failing in a strange way: the service itself stayed online and continued accepting requests, but it stopped producing PDF files. Each server in the load‑balanced group would eventually hit this state independently, and the only way to recover was a full reboot.