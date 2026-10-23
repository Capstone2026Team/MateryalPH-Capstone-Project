# ADR 0003: Hostinger primary staging with a manual Render recovery target

Status: accepted for implementation by the user's Hostinger KVM 2 plan; purchase and cutover remain gated.

## Decision

Use one Hostinger KVM 2 (2 vCPU, 8 GB, 100 GB) with Ubuntu 24.04 LTS in Malaysia, or Indonesia if unavailable. Buy one month only after review of the complete checkout total; the earlier USD 15 limit is not satisfied by an advertised prepaid-term price. No purchase is authorized by this ADR alone.

Caddy serves the two existing React portals and proxies their same-origin `/api/v1` paths. A separate API hostname supports Flutter. The existing Laravel/PHP image runs HTTP, Redis queue work, scheduling and Reverb in separate containers. PostgreSQL 16/PostGIS and persistent Redis stay private. This changes the hosting topology, not the monolith, provider adapters, API contracts or commerce rules. The existing controlled queue worker remains supported; this ADR does not introduce a new queue framework.

Reserve four free DuckDNS names with one numeric suffix before configuring providers or building APKs. Caddy issues and renews HTTPS certificates. Images and assets are built off-server from an exact staging commit that passed a full, manually triggered quality workflow. Deployment and promotion remain operator-controlled.

Preserve development Compose and `render.yaml`. After primary acceptance, Render is fenced standby through **17 November 2026**, with automatic deployments off. It is a manual recovery target, not an automatic failover or a second writer. The supplied database expiry is **18 November 2026, 22:52 Philippine time**. Coverage after the selected window needs a separate decision.

## Data and recovery

Copy a fresh, quiescent development snapshot and matching private objects. Development encryption keys stay local. The existing staging recovery registry receives staging-key ciphertext without rewriting immutable source values. Imported outbox delivery is quarantined by a staging-only timestamp at both dispatch and job execution. Review timers, pending operations and TEST provider associations before enabling processing.

Nightly and pre-release/demo recovery sets contain PostgreSQL, matching content-addressed private objects, checksums, encryption-key fingerprints and release metadata. Restic encrypts offsite storage with a separate scoped key. Retain seven daily and four weekly sets. Check the full restored database against Render's 1 GB cap, without deleting history to fit. Target RPO 24 hours and RTO 60 minutes; both require a timed drill.

## Consequences

One VPS is still one failure domain. Always-on compute removes Render Free sleep from the primary path but cannot guarantee zero delay. Up to 20 simultaneous users and p95 ordinary database-read latency of at most two seconds are acceptance targets, not verified capacity. External providers, uploads, cold recovery and mobile networks are measured separately. OS security, backups, capacity and recovery become operator responsibilities.

The build/runtime and recovery procedures are in [the Hostinger runbook](../deployment/hostinger-vps.md). Provider costs, load acceptance, native APK behavior, reboot recovery and the Render drill must be recorded before release.
