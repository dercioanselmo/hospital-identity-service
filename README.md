# identity-service

Owns users, roles, permissions, credentials, and JWT issuance for the MVA HMS platform. See `docs/security.md` and `docs/database-architecture.md`.

## Prerequisites

Create the database manually (never done by the app):

```bash
createdb mva-identity
```

## Run locally

```bash
mvn spring-boot:run
```

Flyway applies migrations on startup, seeding roles/permissions and a bootstrap `SUPER_ADMIN`:

```text
username: admin
password: ChangeMe123!
```

This is a local-dev-only credential seeded because there is no admin UI yet (AGENTS.md §18 — users are otherwise admin-created only). Change or remove it before any non-local environment.

## Endpoints

- `POST /auth/login` — `{ "username": "...", "password": "..." }` → JWT + roles/permissions
- `GET /me` — current user (requires `Authorization: Bearer <token>`)

## Tests

```bash
mvn test
```

Includes a Testcontainers-backed integration test that spins up real PostgreSQL to verify the Flyway migrations and login flow end-to-end.
