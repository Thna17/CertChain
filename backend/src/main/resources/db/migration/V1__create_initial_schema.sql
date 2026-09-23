CREATE TABLE organization (
    id uuid PRIMARY KEY,
    name varchar(200) NOT NULL,
    email varchar(320) NOT NULL,
    wallet_address varchar(42),
    logo_url varchar(2048),
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    CONSTRAINT organization_name_not_blank CHECK (length(trim(name)) > 0)
);

CREATE TABLE app_user (
    id uuid PRIMARY KEY,
    organization_id uuid NOT NULL REFERENCES organization(id) ON DELETE RESTRICT,
    name varchar(200) NOT NULL,
    email varchar(320) NOT NULL,
    password_hash varchar(255) NOT NULL,
    role varchar(32) NOT NULL,
    enabled boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    CONSTRAINT app_user_role_check CHECK (role IN ('ORG_ADMIN')),
    CONSTRAINT app_user_email_not_blank CHECK (length(trim(email)) > 0)
);
CREATE UNIQUE INDEX app_user_email_ci_uq ON app_user (lower(email));
CREATE INDEX app_user_organization_idx ON app_user (organization_id);

CREATE TABLE certificate (
    id uuid PRIMARY KEY,
    certificate_id varchar(16) NOT NULL UNIQUE,
    organization_id uuid NOT NULL REFERENCES organization(id) ON DELETE RESTRICT,
    recipient_name varchar(200) NOT NULL,
    recipient_email varchar(320) NOT NULL,
    program_name varchar(300) NOT NULL,
    description text,
    issue_date date NOT NULL,
    expiry_date date,
    lifecycle varchar(20) NOT NULL,
    canonicalization_version varchar(16),
    certificate_hash varchar(64),
    pdf_storage_key varchar(1024),
    issued_at timestamptz,
    revoked_at timestamptz,
    revocation_reason text,
    version bigint NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    CONSTRAINT certificate_id_format CHECK (certificate_id ~ '^CERT-[0-9]{4}-[0-9]{6}$'),
    CONSTRAINT certificate_expiry_check CHECK (expiry_date IS NULL OR expiry_date >= issue_date),
    CONSTRAINT certificate_lifecycle_check CHECK (lifecycle IN ('DRAFT','ISSUING','ISSUED','ISSUE_FAILED')),
    CONSTRAINT certificate_hash_check CHECK (certificate_hash IS NULL OR certificate_hash ~ '^[0-9a-f]{64}$')
);
CREATE INDEX certificate_tenant_created_idx ON certificate (organization_id, created_at DESC);
CREATE INDEX certificate_tenant_lifecycle_idx ON certificate (organization_id, lifecycle);
CREATE INDEX certificate_tenant_recipient_idx ON certificate (organization_id, lower(recipient_name));

CREATE TABLE blockchain_transaction (
    id uuid PRIMARY KEY,
    certificate_id uuid NOT NULL REFERENCES certificate(id) ON DELETE RESTRICT,
    transaction_hash varchar(66),
    transaction_type varchar(12) NOT NULL,
    status varchar(12) NOT NULL,
    network varchar(64) NOT NULL,
    chain_id bigint NOT NULL,
    contract_address varchar(42) NOT NULL,
    block_number bigint,
    block_timestamp timestamptz,
    failure_reason text,
    submitted_at timestamptz,
    confirmed_at timestamptz,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    CONSTRAINT blockchain_transaction_type_check CHECK (transaction_type IN ('ISSUE','REVOKE')),
    CONSTRAINT blockchain_transaction_status_check CHECK (status IN ('CREATED','SUBMITTED','CONFIRMED','FAILED')),
    CONSTRAINT blockchain_transaction_chain_check CHECK (chain_id > 0),
    CONSTRAINT blockchain_transaction_block_check CHECK (block_number IS NULL OR block_number >= 0),
    CONSTRAINT blockchain_transaction_hash_check CHECK (transaction_hash IS NULL OR transaction_hash ~ '^0x[0-9a-fA-F]{64}$'),
    CONSTRAINT blockchain_transaction_contract_check CHECK (contract_address ~ '^0x[0-9a-fA-F]{40}$')
);
CREATE UNIQUE INDEX blockchain_transaction_hash_uq ON blockchain_transaction (transaction_hash) WHERE transaction_hash IS NOT NULL;
CREATE INDEX blockchain_transaction_certificate_type_idx ON blockchain_transaction (certificate_id, transaction_type, created_at DESC);

CREATE TABLE email_delivery (
    id uuid PRIMARY KEY,
    certificate_id uuid NOT NULL REFERENCES certificate(id) ON DELETE RESTRICT,
    delivery_type varchar(32) NOT NULL,
    recipient_email varchar(320) NOT NULL,
    status varchar(12) NOT NULL,
    attempt_count integer NOT NULL DEFAULT 0,
    failure_reason text,
    sent_at timestamptz,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    CONSTRAINT email_delivery_type_check CHECK (delivery_type IN ('CERTIFICATE_ISSUED')),
    CONSTRAINT email_delivery_status_check CHECK (status IN ('PENDING','SENT','FAILED')),
    CONSTRAINT email_delivery_attempt_check CHECK (attempt_count >= 0)
);
CREATE INDEX email_delivery_retry_idx ON email_delivery (status, created_at) WHERE status = 'FAILED';
CREATE INDEX email_delivery_certificate_idx ON email_delivery (certificate_id);

CREATE TABLE certificate_number_sequence (
    sequence_year integer PRIMARY KEY,
    next_value bigint NOT NULL,
    version bigint NOT NULL DEFAULT 0,
    CONSTRAINT certificate_number_year_check CHECK (sequence_year BETWEEN 1 AND 9999),
    CONSTRAINT certificate_number_next_check CHECK (next_value BETWEEN 1 AND 1000001)
);
