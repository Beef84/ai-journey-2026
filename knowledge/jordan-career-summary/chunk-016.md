[Source: Jordan Career Summary | Section: Dick's Sporting Goods — Production incident: signage system > Fix and follow-up]

### Fix and follow-up
Once the vendor provided a patched version of the library, we ran our penetration tests again in lower environments to validate the fix under load. After confirming the issue was resolved, we deployed the update to production and monitored the servers closely. The failures stopped, and we were able to remove the extra servers we had added. We kept the automated reboots in place as a precaution, but the system remained stable going forward.

The permanent fix was ultimately a combination of updating the third‑party library, improving our load‑testing practices, and tightening our monitoring around temp‑file usage and resource exhaustion. It was a classic example of a distributed system failure where the symptoms pointed everywhere except the true root cause.

---