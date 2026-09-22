# CertChain Blockchain

Hardhat 3 workspace for the minimal on-chain certificate proof registry. Phase 1 defines the ABI contract in `contracts/ICertificateRegistry.sol`; the access-controlled implementation and its tests are intentionally scheduled for Phase 5.

```bash
cp .env.example .env
npm install
npm run typecheck
npm test
```

The contract must never store recipient email, full certificate data, PDF content, or private revocation reasons. Sepolia deployment keys remain outside source control.

