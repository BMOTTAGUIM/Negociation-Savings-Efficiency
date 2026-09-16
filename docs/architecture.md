# Architecture Notes

## Initial boundary

The platform is an auxiliary system. SAP remains the official purchasing system and is not modified by this project.

## Proposed flow

1. A buyer uploads the negotiation report.
2. The backend preserves the original file and extracts candidate fields.
3. The buyer confirms the extracted fields and submits the record.
4. A designated reviewer checks the evidence and approves or rejects it.
5. Approved records become available for reporting and export.

## Candidate record fields

- SAP or purchase reference
- Buyer
- Supplier
- Service category
- Original value and currency
- Negotiated value and currency
- Calculated savings and savings percentage
- Evidence file and extraction confidence
- Status, reviewer, timestamps, and audit events

No field or integration contract is final until representative reports and the official destination application are identified.

## Initial PostgreSQL model

The first schema is in `backend/src/db/schema.sql` and contains:

- `buyers`: buyer employee code and identity data.
- `suppliers`: SAP Ariba supplier code and legal name.
- `savings_records`: purchase references, product/service, original and negotiated amounts, currency, status, review data, and timestamps.
- `evidence_documents`: immutable file metadata, storage key, content type, size, and SHA-256 hash.
- `audit_events`: append-only workflow events in JSONB.

`original_amount`, `negotiated_amount`, `savings_amount`, and `savings_percentage` are kept in PostgreSQL with constraints. The savings values are generated from the two source amounts, so clients cannot submit an inconsistent saving amount.

The database stores document metadata and integrity information. The original file should be stored in an approved document/object-storage service, not directly in the relational table, unless Information Security approves that design.

Run the initial schema with `npm run db:migrate --workspace backend` after setting `DATABASE_URL`.
