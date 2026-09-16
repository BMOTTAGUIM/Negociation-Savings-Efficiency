CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
BEGIN
  CREATE TYPE savings_status AS ENUM ('DRAFT', 'SUBMITTED', 'IN_REVIEW', 'APPROVED', 'REJECTED');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS buyers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_code VARCHAR(80) NOT NULL UNIQUE,
  full_name VARCHAR(180) NOT NULL,
  email VARCHAR(254),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS suppliers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ariba_supplier_code VARCHAR(120) NOT NULL UNIQUE,
  legal_name VARCHAR(240) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS savings_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  buyer_id UUID NOT NULL REFERENCES buyers(id),
  supplier_id UUID NOT NULL REFERENCES suppliers(id),
  purchase_reference VARCHAR(120),
  sap_reference VARCHAR(120),
  product_description TEXT NOT NULL,
  service_category VARCHAR(160),
  original_amount NUMERIC(19, 4) NOT NULL CHECK (original_amount >= 0),
  negotiated_amount NUMERIC(19, 4) NOT NULL CHECK (negotiated_amount >= 0),
  currency_code CHAR(3) NOT NULL,
  savings_amount NUMERIC(19, 4) GENERATED ALWAYS AS (original_amount - negotiated_amount) STORED,
  savings_percentage NUMERIC(9, 4) GENERATED ALWAYS AS (
    CASE
      WHEN original_amount = 0 THEN 0
      ELSE ((original_amount - negotiated_amount) / original_amount) * 100
    END
  ) STORED,
  registered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  status savings_status NOT NULL DEFAULT 'DRAFT',
  submitted_at TIMESTAMPTZ,
  reviewed_at TIMESTAMPTZ,
  reviewer_name VARCHAR(180),
  review_notes TEXT,
  extraction_confidence NUMERIC(5, 4) CHECK (extraction_confidence BETWEEN 0 AND 1),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT negotiated_not_above_original CHECK (negotiated_amount <= original_amount),
  CONSTRAINT savings_currency_code_format CHECK (currency_code ~ '^[A-Z]{3}$')
);

CREATE TABLE IF NOT EXISTS evidence_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  savings_record_id UUID NOT NULL REFERENCES savings_records(id) ON DELETE CASCADE,
  original_filename VARCHAR(255) NOT NULL,
  content_type VARCHAR(120) NOT NULL,
  file_size_bytes BIGINT NOT NULL CHECK (file_size_bytes > 0),
  storage_key TEXT NOT NULL UNIQUE,
  sha256_hash CHAR(64) NOT NULL,
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  savings_record_id UUID NOT NULL REFERENCES savings_records(id) ON DELETE CASCADE,
  event_type VARCHAR(80) NOT NULL,
  actor_code VARCHAR(80),
  event_data JSONB NOT NULL DEFAULT '{}'::JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS savings_records_buyer_id_idx ON savings_records (buyer_id);
CREATE INDEX IF NOT EXISTS savings_records_supplier_id_idx ON savings_records (supplier_id);
CREATE INDEX IF NOT EXISTS savings_records_status_idx ON savings_records (status);
CREATE INDEX IF NOT EXISTS savings_records_registered_at_idx ON savings_records (registered_at);
CREATE INDEX IF NOT EXISTS audit_events_record_id_created_at_idx ON audit_events (savings_record_id, created_at);
