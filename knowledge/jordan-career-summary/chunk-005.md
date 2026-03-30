[Source: Jordan Career Summary | Section: Existing system improvements]

## Existing system improvements

### Signage system modernization (Dick’s Sporting Goods)
My first assignment at Dick’s Sporting Goods was to assist the corporate signage team with developing new templates for the Field & Stream brand the company was launching. The existing signage system required a developer to write sign rules in C++, which meant business users depended on engineering time for every template change. The system also didn’t integrate cleanly with the company intranet, making sign‑data management cumbersome. I proposed building something better and was given approval to create a proof of concept.

The POC was a Windows desktop application built around an inexpensive .NET PDF‑manipulation library I found that allowed programmatic editing of PDF files. The application enabled business users to design sign templates visually by placing objects—such as item, regular price, and sale price—directly onto a PDF layout. Each object carried metadata understood by the library, allowing a WCF service to later replace placeholder text with real sign data when generating store‑ready signage.

The POC was quickly approved, and I began turning it into a production‑grade system. I developed the WCF service that became the backbone of the platform, generating tens of thousands of PDF files per day using load‑balanced servers in production. This service integrated data from a SQL Server signage database with the appropriate PDF templates stored on a shared drive, producing pricing and promotional signage across three major brands.