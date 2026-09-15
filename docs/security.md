# Security and Compliance Checklist

Before internal deployment, confirm with the responsible corporate teams:

- Identity provider and role model for buyers and reviewers.
- Data classification of purchase reports and supplier information.
- Retention, deletion, and audit requirements.
- Approved storage location and encryption requirements.
- Whether an approved document extraction service may be used.
- Network, secret-management, logging, and vulnerability-scanning requirements.
- Whether SAP or the destination application exposes an approved API.

Secrets must be supplied through approved environment or secret-management mechanisms. They must not be stored in source code, uploaded documents, README files, or browser code.
