# ADR 0002: Railway Hobby and Vercel Hobby for staging

Date: 2026-10-21. Decision accepted by the user's explicit migration instruction.
Paid provisioning remains subject to the separate cost worksheet approval.

Replace the hosted staging target with Railway Hobby for the existing Laravel
modular monolith, PostgreSQL 16/PostGIS and Redis. Use separate API, worker,
continuous scheduler and Reverb process roles from the same source commit.
Migrations run only in the API pre-deploy release step. Retain Render during
acceptance. Local Docker remains the development and isolated-test environment.

Vendor/Admin static builds deploy to Vercel Hobby through the private personal
artifact repository `materyalph-staging-portals`. The organization monorepo remains
authoritative. Publish only after all required CI gates pass, with source SHA
metadata and an eligible personal deployment owner. Web `/api/v1` requests proxy
to Railway; native Buyer requests and all realtime connections go directly there.
The existing Vendor-origin shared Google callback and native one-time exchange stay intact.

Railway Hobby's blocked SMTP egress requires a Gmail HTTPS send-only transport.
Keep current Mailables, notification outbox, expiry, suppression and activation
cutoff policies. Use separate mailbox OAuth credentials with only `gmail.send`;
keep development SMTP security validation. Acceptance by Gmail means provider
acceptance, not confirmed inbox receipt. Public API contracts and business schema
do not change.

Costs are usage-based and may substantially exceed $5. Persistent volumes and
private encrypted object storage, fail-closed scanning, source-key-free import
recovery and isolated backup restoration remain required. Vercel Hobby eligibility
is restricted to personal noncommercial staging. Upgrade Railway in place when
requested. Production launch, app stores and Render deletion require separate work.

Implementation and acceptance: [runbook](../deployment/railway-vercel-staging.md),
[cost worksheet](../deployment/railway-cost-worksheet.md).
