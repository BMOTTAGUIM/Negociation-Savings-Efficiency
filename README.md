# Negotiation Savings Efficiency

Internal support platform for recording negotiation evidence and approved savings. The official SAP process remains unchanged.

## Project structure

- `frontend/`: user interface for submission, review, and dashboards.
- `backend/`: API, validation, workflow, audit trail, and document processing.
- `docs/`: requirements, architecture, security, and decision records.
- `infra/`: deployment and infrastructure definitions, kept separate from application code.

## Principles

1. SAP remains the official source for the purchasing process.
2. This platform stores supporting evidence and an auditable savings record.
3. Extracted values require human confirmation and reviewer approval.
4. No corporate integration or secret is committed to this repository.

## Planned local setup

Prerequisites: Node.js 20 or later and npm 10 or later.

```text
npm install
npm run dev
```

The application code will be added in small, validated slices. Before any corporate rollout, the solution needs review by IT, Information Security, Data Protection, and the process owner.

## Current status

Initial project structure created. SAP integration, corporate authentication, document OCR, and the destination application are intentionally not configured until their approved interfaces are known.
