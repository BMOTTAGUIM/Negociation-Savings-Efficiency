# Backend

Planned TypeScript API responsible for savings records, approval workflow, audit history, and document extraction orchestration.

The backend must validate all extracted values server-side and preserve the original uploaded evidence.

## Database

The initial persistence layer targets PostgreSQL. Set `DATABASE_URL` in the environment and run:

```text
npm run db:migrate --workspace backend
```

The migration creates the buyer, supplier, savings record, evidence metadata, and audit event tables. No production database credentials are committed to the repository.
