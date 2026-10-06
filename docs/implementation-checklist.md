# Implementation Checklist

## Phase 1 - Foundation

- [x] Read and reconcile the assignment brief with the product specification.
- [x] Define architecture, ER model, API contracts, smart contract interface, and workflows.
- [x] Initialize Git repository and root ignore rules.
- [x] Scaffold Next.js/TypeScript/Tailwind frontend.
- [x] Scaffold Spring Boot/Maven backend with health check and test profile.
- [x] Scaffold Hardhat/TypeScript blockchain project.
- [x] Configure local PostgreSQL with Docker Compose.
- [x] Add environment templates and setup documentation.
- [x] Run baseline frontend, backend, and blockchain checks.

## Phase 2 - Database and domain

- [x] Add Flyway migrations, constraints, and indexes.
- [x] Implement entities, enums, repositories, DTOs, and mappers.
- [x] Implement concurrency-safe certificate ID allocation.
- [x] Add repository and container-backed integration test code.
- [x] Execute the complete PostgreSQL Testcontainers suite without skips. On 6 October, two full backend runs each passed 73 tests with zero failures, errors, or skips against fresh PostgreSQL 17.11 containers.

## Phase 3 - Authentication and tenancy

- [x] Add organization/user bootstrap flow for development.
- [x] Implement BCrypt authentication and short-lived JWT access tokens.
- [x] Configure stateless Spring Security and strict CORS.
- [x] Enforce organization ownership in implemented protected operations.
- [x] Build login and protected portal layout.
- [x] Test invalid credentials, disabled users, token validation, and cross-tenant denial.

## Phase 4 - Draft certificate management

- [x] Create/list/view/search/update draft APIs.
- [x] Freeze proof-relevant fields once issuance begins.
- [x] Build create, list, details, loading, empty, and error states.
- [x] Test validation, pagination, filtering, and authorization.

## Phase 5 - Smart contract

- [x] Implement `CertificateRegistry.sol` with role-based access control.
- [x] Implement custom errors, events, issue/read/verify/revoke functions.
- [x] Complete contract unit tests.
- [x] Add and smoke-test a local Ignition deployment module.
- [x] Generate the Java wrapper for backend blockchain integration.
- [x] Document the Sepolia deployment procedure without committing secrets.
- [x] Test deployment on Sepolia. The verified contract was deployed with separate Admin and Issuer addresses; synthetic issue and revoke receipts and one hosted certificate issue were checked on Sepolia.

## Phase 6 - Issuance and blockchain integration

- [x] Implement versioned canonicalization and SHA-256 service.
- [x] Test deterministic hashing, changed fields, normalization, escaping, and ordering.
- [x] Implement web3j client behind a blockchain gateway interface.
- [x] Implement issuance lifecycle, transaction journal, receipt/event validation, and reconciliation.
- [x] Test failed, timed-out, duplicated, and recovered submissions with PostgreSQL and a local Hardhat chain.

## Phase 7 - Public verification

- [x] Implement the public verification DTO and API.
- [x] Recompute local hash and compare database/on-chain proof.
- [x] Implement dynamic `REVOKED > EXPIRED > VALID` status.
- [x] Build `/verify` and `/verify/[certificateId]` with accessible states.
- [x] Add authoritative explorer links and unavailable/mismatch handling.

## Phase 8 - PDF and QR

- [x] Implement storage abstraction.
- [x] Generate verification QR using ZXing.
- [x] Generate professional PDF using PDFBox and embed QR.
- [x] Implement authorized PDF download and artifact retry.
- [x] Add PDF content/render checks.

## Phase 9 - Revocation and expiration

- [x] Implement confirmed on-chain revocation workflow and journal.
- [x] Persist private reason, confirmed time, and transaction metadata.
- [x] Add admin confirmation UI and public revoked state.
- [x] Test expired, revoked-and-expired, unauthorized, duplicate, and failed revocations.

## Phase 10 - Email

- [x] Implement templated issuance email with the generated PDF attachment.
- [x] Record delivery attempts without rolling back issuance.
- [x] Add bounded retry, authorized resend, and development SMTP configuration.
- [x] Complete successful and failed delivery testing against Mailpit and PostgreSQL. The 6 October full backend runs executed the PostgreSQL delivery tests without skips; a separate Mailpit smoke test delivered multipart email with a PDF attachment. Live Brevo delivery remains a deployment gate.

## Phase 11 - Dashboard and UI polish

- [x] Add tenant-scoped database counts and bounded recent activity.
- [x] Complete responsive navigation and validated organization profile.
- [x] Audit keyboard focus, status text, loading, empty, error, and confirmation states at mobile, tablet, and desktop widths.

## Phase 12 - Verification and security review

- [x] Run the full backend suite with PostgreSQL Testcontainers. Two 6 October runs passed 73 tests each with zero skipped; this does not replace the still-pending hosted browser and email checks.
- [x] Run contract tests and coverage.
- [x] Run frontend component and main-flow tests.
- [x] Execute the unknown, issue/valid, expired, revoke/reverify, and tamper demo scenarios with synthetic data.
- [x] Review secret handling, logging, CORS, authorization, validation, and dependency risks; record the remaining limitations in the Phase 12 evidence.

## Phase 13 - Deployment

- [x] Provision Neon PostgreSQL and private object storage; Flyway and a generated PDF object were observed in production.
- [x] Deploy and verify the contract on Sepolia, including roles, source, and issue/revoke events.
- [ ] Configure backend secrets and HTTPS deployment.
- [x] Deploy the Vercel frontend on Hobby and configure its production API origin.
- [ ] Run production smoke tests and backup/recovery checks.

## Phase 14 - Assignment documentation

- [ ] Capture architecture, flow, ER, blockchain, contract, and UI evidence.
- [x] Write implementation summary and contribution report from Git evidence (draft; update after publication).
- [ ] Add public GitHub and demo URLs.
- [ ] Record focused demo flow.
- [ ] Render and inspect the final submission PDF.
- [x] Prepare a clearly labeled draft package with source, dated test evidence, Git contribution record, dashboard/PDF captures, and recording instructions (3 October 2026). This does not complete the public deployment/video/final-report gates.
