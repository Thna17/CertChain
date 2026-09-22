# Database ER Model

## Relationship model

```mermaid
erDiagram
    ORGANIZATION ||--o{ APP_USER : employs
    ORGANIZATION ||--o{ CERTIFICATE : issues
    CERTIFICATE ||--o{ BLOCKCHAIN_TRANSACTION : records
    CERTIFICATE ||--o{ EMAIL_DELIVERY : notifies
    CERTIFICATE_NUMBER_SEQUENCE }o--|| ORGANIZATION : scopes

    ORGANIZATION {
        uuid id PK
        varchar name
        varchar email
        varchar wallet_address
        varchar logo_url
        timestamptz created_at
        timestamptz updated_at
    }

    APP_USER {
        uuid id PK
        uuid organization_id FK
        varchar name
        varchar email UK
        varchar password_hash
        varchar role
        boolean enabled
        timestamptz created_at
        timestamptz updated_at
    }

    CERTIFICATE {
        uuid id PK
        varchar certificate_id UK
        uuid organization_id FK
        varchar recipient_name
        varchar recipient_email
        varchar program_name
        text description
        date issue_date
        date expiry_date
        varchar lifecycle
        varchar canonicalization_version
        char certificate_hash
        varchar pdf_storage_key
        varchar issue_transaction_hash
        bigint issue_block_number
        varchar contract_address
        varchar blockchain_network
        timestamptz issued_at
        timestamptz revoked_at
        text revocation_reason
        varchar revocation_transaction_hash
        integer version
        timestamptz created_at
        timestamptz updated_at
    }

    BLOCKCHAIN_TRANSACTION {
        uuid id PK
        uuid certificate_id FK
        varchar transaction_hash UK
        varchar transaction_type
        varchar status
        varchar network
        varchar contract_address
        bigint chain_id
        bigint block_number
        timestamptz block_timestamp
        text failure_reason
        timestamptz submitted_at
        timestamptz confirmed_at
        timestamptz created_at
        timestamptz updated_at
    }

    EMAIL_DELIVERY {
        uuid id PK
        uuid certificate_id FK
        varchar delivery_type
        varchar recipient_email
        varchar status
        integer attempt_count
        text failure_reason
        timestamptz sent_at
        timestamptz created_at
        timestamptz updated_at
    }

    CERTIFICATE_NUMBER_SEQUENCE {
        uuid organization_id PK,FK
        integer sequence_year PK
        bigint next_value
        integer version
    }
```

## Backend entities

| Entity | Purpose | Key rules |
|---|---|---|
| `Organization` | Issuing tenant and public issuer profile | Name and email required; wallet address optional in the first backend-signer release. |
| `User` | Authenticated organization administrator | Globally unique normalized email, BCrypt password hash, role enum, organization required. |
| `Certificate` | Operational certificate aggregate | UUID internal ID; unique immutable public ID; immutable proof fields after issuance begins; optimistic locking. |
| `BlockchainTransaction` | Auditable transaction journal | One certificate can have issue/revoke attempts; transaction hash unique when present; status transitions are explicit. |
| `EmailDelivery` | Retry/audit record for recipient notifications | Email failure is independent from issuance success. |
| `CertificateNumberSequence` | Concurrency-safe yearly public ID allocation | Updated under a row lock; unique `(organization_id, sequence_year)`. |

## Enums and derived values

- `UserRole`: `ORG_ADMIN`.
- `CertificateLifecycle`: `DRAFT`, `ISSUING`, `ISSUED`, `ISSUE_FAILED`.
- `CertificateStatus`: `VALID`, `EXPIRED`, `REVOKED` (derived, not persisted).
- `BlockchainTransactionType`: `ISSUE`, `REVOKE`.
- `BlockchainTransactionStatus`: `CREATED`, `SUBMITTED`, `CONFIRMED`, `FAILED`.
- `EmailDeliveryStatus`: `PENDING`, `SENT`, `FAILED`.

The database stores timestamps as UTC `timestamptz`. Issue and expiry are business dates; expiration is evaluated at the end of the expiry date in the configured organization timezone, initially UTC unless the domain later adds an organization timezone.

## Important constraints and indexes

- unique index on `certificate.certificate_id`;
- index on `certificate(organization_id, created_at desc)`;
- index on `certificate(organization_id, lifecycle)`;
- unique partial/index constraint for non-null transaction hashes;
- index on `blockchain_transaction(certificate_id, transaction_type, created_at desc)`;
- check constraint: `expiry_date is null or expiry_date >= issue_date`;
- check constraints for 64-character lowercase hexadecimal hashes and Ethereum address/transaction lengths where practical;
- foreign keys use restrictive deletion for certificates and transaction history. Issued records are never cascade-deleted.

