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
