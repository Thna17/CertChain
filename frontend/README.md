# CertChain Frontend

Next.js App Router frontend for the public verification experience and authenticated organization portal.

```bash
cp .env.example .env.local
npm install
npm run dev
```

Validation commands:

```bash
npm run lint
npm run build
```

Only `NEXT_PUBLIC_` values may be read by browser code, and those values must never contain secrets.

