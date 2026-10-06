# CertChain submission preparation

Updated 6 October 2026. **Status: prepared evidence package; final submission blocked.**

Free-tier frontend, API, database, storage, and a Sepolia contract now exist. One hosted issue transaction and valid public proof are independently verified. The student will record the video; no public video link exists. Deployment must remain on free plans without a payment card or automatic paid upgrade. The assignment's original brief is not in this repository; this package follows the 11 report sections and release requirements supplied in this project conversation.

## What to open first

1. `output/pdf/CertChain-assignment-report-DRAFT.pdf`: the report, with exactly 11 required sections and honest pending items.
2. `docs/report/demo-recording-script.md`: the ordered demonstration and recording checklist.
3. `docs/report/submission-validation-2026-10-06.md`: fresh zero-skip test totals, hosted proof, and remaining boundaries.
4. `docs/report/contributions-from-git.md`: authored commits grouped by the two actual identities.
5. `README.md`: setup, environment variable guidance, architecture links, and commands.

The generated ZIP places the report at its root and includes the source snapshot, documentation, safe screenshots, contribution record, and SHA-256 manifest. It excludes real environment files, credentials, local databases, private storage, logs, dependency folders, build outputs, and Git's internal directory. The report and safe sample PDFs are intentional submission artifacts. The ZIP is a working-tree snapshot based on the current Git HEAD; its manifest lists uncommitted changes.

## Current verification

- PASS: `seypa/main` at `f196d2a` before this documentation update. The working tree contains preparation work; it is not a clean release. The original `origin` remote belongs to the teammate and may differ.
- PASS: frontend lint, production build, and 31 tests.
- PASS: contract compilation/typecheck and 8 tests; coverage reports 100% of lines and statements in `CertificateRegistry.sol`.
- PASS: two full backend Maven wrapper runs each reported 73 tests, zero failures/errors/skips, including PostgreSQL Testcontainers and Hibernate validation. An additional Mailpit smoke test passed.
- PASS: the public [user repository](https://github.com/Seypa-47/CertChain), [Vercel frontend](https://cert-chain-gold.vercel.app), [Render API](https://certchain-api-06gv.onrender.com/actuator/health), [verified Sepolia contract](https://sepolia.etherscan.io/address/0x293597447c1e39825Df82fc3791BA7AB3Eb9719f#code), and [hosted issuance transaction](https://sepolia.etherscan.io/tx/0x3e690ae42fda4f90066c922bc3310e4b2384160cd47c98645fdb1f15819c6690) exist. The original issued certificate remains valid. A separate [hosted revocation transaction](https://sepolia.etherscan.io/tx/0x180f2dadcb0e2ba8a1644b34036a805faebfce4d9dd89b33f5978f69f856e028) succeeded, and [public verification](https://cert-chain-gold.vercel.app/verify/CERT-2026-000002) now reports revoked with a verified proof.
- PENDING: Brevo phone verification and real mailbox delivery, the natural UTC rollover of the issued [expiry fixture](https://cert-chain-gold.vercel.app/verify/CERT-2026-000003), backup/recovery check, complete browser end-to-end coverage, and public demo video.

Existing dependency installations were used on 3 October. The earlier locked rebuild is documented in the 29 September audit. Do not present the October checks as a new `npm ci` rebuild or a full release audit.

## Report coverage

1. System Overview: prepared.
2. System Architecture: prepared, including architecture diagram.
3. User Flow / System Flow: prepared, with issuance, verification, and revocation diagrams.
4. Database Design / ER Diagram: prepared, including global yearly ID allocation.
5. Blockchain Architecture: prepared with verified Sepolia deployment metadata.
6. Smart Contract Design: prepared with source-verified contract and hosted issue receipt.
7. User Interface Design / Screenshots: local login, dashboard, valid, expired, revoked, not-found, proof mismatch, and downloaded PDF/QR; hosted dashboard, draft details, issued details, valid proof, explorer issue event, and downloaded PDF/QR are included. Hosted revoke/proof and explorer links are verified; a saved hosted revoked screenshot, actual expired-state capture, and real email capture remain pending.
8. Implementation Summary: prepared with dated test results and limitations.
9. Public GitHub Repository Link: present and checked.
10. Individual Contribution Report: derived only from Git history; uneven evidence explicitly stated.
11. Public Demo Video Link: pending the student's recording and public URL.

## Finish before submitting

1. Complete Brevo's required phone verification in its UI, create the SMTP key, store it only in Render's secret settings, and verify a synthetic email in a real mailbox. The Gmail sender and Render Free outbound CIDR allowlist are already configured; no card was added.
2. Preserve `CERT-2026-000001` as the valid hosted demo and `CERT-2026-000002` as the verified revoked example. Recheck `CERT-2026-000003` after 7 October 2026 07:00 Bangkok time for its natural UTC expiry, then capture evidence. Label any local-only evidence clearly.
3. Complete the automated browser end-to-end flows, public response privacy check, and database/object backup-recovery procedure.
4. Capture the remaining safe screenshots. Record the demo in the supplied order; upload it and verify the link while signed out.
5. Insert the real video URL; check every report link. Regenerate the PDF, render every page, and inspect it again. Remove draft labels only when complete.
6. Re-run the final submission gate. Commit/push final fixes only under the previously requested all-gates-pass condition. No `v1.0.0` tag is authorized or created by this preparation.

## Regenerate the package

From the repository root, using Python with ReportLab, Pillow, and pypdf installed:

```text
python docs/report/build_report.py
python docs/report/build_submission.py
```

Render and visually inspect the generated PDF before delivering the archive. `build_submission.py` uses Git-tracked files plus an explicit list of reviewed additions; it never recursively copies the working directory. The output is `output/submission/CertChain-submission-PREPARED.zip` with a separate SHA-256 checksum. Rebuilding overwrites that generated archive only.

Local PostgreSQL and Mailpit were running for the 6 October tests. A restarted in-memory Hardhat node creates a new chain; do not assume previously issued local database records still have matching proofs after a restart. Use a fresh isolated demo database/contract pair for local recording unless the prior chain state was explicitly preserved.
