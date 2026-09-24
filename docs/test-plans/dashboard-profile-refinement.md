# Dashboard and personal profile refinement

## Scope

Admin and Vendor share DashboardHeader, MetricCard, SectionWorkspace, date-filter controls and application-shell spacing. Their content, permissions and routes remain separate. Existing preview date controls do not claim to filter live dashboard counts. Settings uses the shared account workspace. The top-bar menu displays the authenticated person's name, initials/photo and an accessible SVG chevron.

Design references: [Carbon dashboard guidance](https://carbondesignsystem.com/data-visualization/dashboards/) and [Carbon grid guidance](https://carbondesignsystem.com/elements/2x-grid/usage/). Icons are reused from the repository's System Icons collection.

## Personal photos

- Additive migration: `2026_09_17_140000_add_personal_profile_photo.php` adds nullable private storage key/disk fields to users. Existing accounts require no reset.
- `POST /api/v1/{vendors|admin}/account/photo`: multipart photo and current `lock_version`; returns AccountProfile with nullable `avatar_url`.
- JPEG, PNG and WebP only; maximum 2 MB and 4096 pixels per dimension. Scan the original with ClamAV, then strip metadata by re-encoding a centered 256px PNG. Store only clean output on the configured private disk.
- Authenticated personal account only, including Vendor staff and Admin; no Buyer upload endpoint. Existing portal authorization, CSRF, overall request budget and optimistic concurrency are retained. Photo mutations have a separate five-per-minute limit.
- Photo GET requires authentication and a five-minute signed URL bound to the person's public ID and profile version. It returns private/no-store and nosniff headers. Storage keys never appear in account JSON. Updating a profile invalidates its old photo URL.
- Audit event PROFILE_PHOTO_UPDATED records clean/sanitized status without image data. Originals are not persisted. Superseded sanitized objects currently remain private in storage; automatic garbage collection is not included.
- Missing/stale signatures, scanner timeout or unavailable processing fails closed with a recoverable error, preserving the prior profile.

## Local infrastructure

The API Docker image includes GD and ClamAV. The `avatar-signatures` service runs FreshClam against a shared signature volume; the API mounts that volume read-only. No new API keys are required. See [ClamAV signature management](https://docs.clamav.net/manual/Usage/SignatureManagement.html).

For another local checkout:

```powershell
docker compose build api avatar-signatures
docker compose up -d --no-deps api avatar-signatures
docker compose exec -T api php artisan migrate --path=database/migrations/2026_09_17_140000_add_personal_profile_photo.php
docker compose logs --tail 20 avatar-signatures
```

Wait for the signature database to download before uploading. This change does not deploy or modify existing credentials.

## Verification

Regression coverage includes Vendor-owner photo upload, Admin/staff eligibility, private/signed access, cross-account denial, version conflicts, invalid formats and scanner failure. Both portals retain their existing navigation and interaction tests. Browser visual review and end-to-end upload with a real authenticated account should accompany UAT; automated tests do not replace that review.

Verified locally on 2026-09-17: isolated Laravel 112 tests / 1341 assertions; Vendor 52 tests; Admin 15 tests; both portals lint/typecheck/build; Pint 222 files; PHPStan no errors; OpenAPI validation; account contract 57 operations; Phase 3 contract 26 operations; generated TypeScript build; Compose config; targeted source secret scans and diff whitespace check. Real ClamAV scan of a repository PNG exited 0 after signature download. Vendor build retains a bundle-size warning. Generated Dart was regenerated, but Dart analysis was not rerun in this task.
