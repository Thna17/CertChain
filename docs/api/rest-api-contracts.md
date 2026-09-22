# REST API Contracts

Base path: `/api`. JSON uses camelCase. Dates use `YYYY-MM-DD`; timestamps use ISO-8601 UTC. Internal resources use UUIDs while public verification uses the human-readable certificate ID.

## Authentication

### `POST /api/auth/login`

Request:

```json
{
  "email": "admin@kit.edu.kh",
  "password": "user-entered-password"
}
```

Response `200`:

```json
{
  "accessToken": "...",
  "tokenType": "Bearer",
  "expiresIn": 900,
  "user": {
    "id": "uuid",
    "name": "Organization Admin",
    "email": "admin@kit.edu.kh",
    "role": "ORG_ADMIN",
    "organization": { "id": "uuid", "name": "KIT Training Center" }
  }
}
```

The initial version uses a short-lived bearer access token. If refresh tokens are later added, they should use rotating, secure, HTTP-only cookies rather than browser storage.

## Organization portal

All routes below require `Authorization: Bearer <token>` and organization ownership.

| Method | Route | Purpose |
|---|---|---|
| `GET` | `/api/organization` | Current organization profile. |
| `PATCH` | `/api/organization` | Update allowed profile fields. |
| `GET` | `/api/dashboard` | Counts and recent certificates from real data. |
| `POST` | `/api/certificates` | Create a draft. Server allocates the certificate ID. |
| `GET` | `/api/certificates?page=0&size=20&query=&lifecycle=&status=` | Paginated tenant-scoped list/search. |
| `GET` | `/api/certificates/{id}` | Full authorized details by internal UUID. |
| `PATCH` | `/api/certificates/{id}` | Update mutable draft fields only. |
| `POST` | `/api/certificates/{id}/issue` | Start synchronous issuance for v1; idempotent against duplicate proof. |
| `POST` | `/api/certificates/{id}/revoke` | Revoke an issued certificate with confirmation. |
| `GET` | `/api/certificates/{id}/pdf` | Download the generated PDF after issuance. |

Create request:

```json
{
  "recipientName": "Hong Thanbrathna",
  "recipientEmail": "recipient@example.com",
  "programName": "Blockchain Fundamentals",
  "description": "Successfully completed the training program.",
  "issueDate": "2026-09-20",
  "expiryDate": "2029-09-20"
}
```

Issue response `200`:

```json
{
  "id": "uuid",
  "certificateId": "CERT-2026-000001",
  "lifecycle": "ISSUED",
  "status": "VALID",
  "certificateHash": "64-lowercase-hex-characters",
  "verificationUrl": "https://certchain.example.com/verify/CERT-2026-000001",
  "blockchain": {
    "network": "sepolia",
    "chainId": 11155111,
    "contractAddress": "0x...",
    "transactionHash": "0x...",
    "blockNumber": 123,
    "confirmedAt": "2026-09-20T08:00:00Z"
  },
  "emailDeliveryStatus": "SENT"
}
```

Revoke request:

```json
{ "reason": "Issued to the wrong recipient" }
```

## Public verification

| Method | Route | Purpose |
|---|---|---|
| `GET` | `/api/public/certificates/{certificateId}` | One verification response; performs hash and chain checks. |

Response `200`:

```json
{
  "certificateId": "CERT-2026-000001",
  "recipientName": "Hong Thanbrathna",
  "programName": "Blockchain Fundamentals",
  "organization": { "name": "KIT Training Center", "logoUrl": null },
  "issueDate": "2026-09-20",
  "expiryDate": "2029-09-20",
  "status": "VALID",
  "blockchainVerified": true,
  "blockchain": {
    "network": "sepolia",
    "chainId": 11155111,
    "transactionHash": "0x...",
    "contractAddress": "0x...",
    "blockNumber": 123,
    "transactionTimestamp": "2026-09-20T08:00:00Z",
    "explorerUrl": "https://sepolia.etherscan.io/tx/0x..."
  }
}
```

Unknown IDs return `404`; malformed IDs return `400`. Public responses never include email, internal UUIDs, password-related data, failure internals, or private revocation notes.

## Error envelope

```json
{
  "timestamp": "2026-09-20T08:00:00Z",
  "status": 400,
  "error": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "path": "/api/certificates",
  "details": [
    { "field": "recipientEmail", "message": "must be a valid email address" }
  ],
  "traceId": "server-generated-correlation-id"
}
```

Expected stable error codes include `VALIDATION_ERROR`, `INVALID_CREDENTIALS`, `ACCESS_DENIED`, `CERTIFICATE_NOT_FOUND`, `CERTIFICATE_ALREADY_ISSUED`, `CERTIFICATE_ALREADY_REVOKED`, `BLOCKCHAIN_TRANSACTION_FAILED`, `BLOCKCHAIN_VERIFICATION_FAILED`, `PDF_GENERATION_FAILED`, and `INTERNAL_ERROR`.

