# Free staging upload repair — 2026-10-20

The owner selected Bouncer's ongoing Free scanner and approved a 25 MiB ceiling
for new review videos. Photos, documents, private access, supported formats,
idempotency and historical media retain their existing rules. No paid resource,
scan bypass, credential rotation or destructive database change is required.

## Changes

- `FileMalwareScanner` separates the domain from local ClamAV and Bouncer
  adapters. Existing photo/file services retain their stable 422/503 errors.
- Bouncer v2 streams the entire file to a restricted HTTPS S3 upload target,
  polls the matching scan for at most 50 seconds, and requires a fresh completed
  clean verdict with matching SHA256 and byte size. Suspicious/malicious results
  are rejected. Missing, mismatched, partial, failed, pending or quota-limited
  responses cannot publish a file. Redirects are disabled and scanner API
  authentication is never forwarded to storage.
- New review-video uploads are limited to 25 MiB in domain rules, effective
  platform settings, OpenAPI and Buyer defaults. A lower saved limit for another
  purpose is preserved. Stored settings/version history and existing file rows
  are not rewritten. The original applied migration remains unchanged.
- PHP permits 25 MiB per file and 80 MiB per multipart request. Nginx uses the
  same request ceiling so a multi-file review is not rejected at the old 32 MiB
  boundary. Its response budget covers sequential validation/scanning/storage.
- Shared Buyer multipart transport gives file requests 90 seconds to send and
  90 seconds per file to receive, capped at three files. JSON and ordinary reads
  keep their budgets. The Buyer build must include this source change to receive
  the timeout fix; existing builds can read the API's new authoritative size cap.
- Both generated clients are regenerated from OpenAPI; no generated file is
  manually edited. Vendor/Admin consume existing endpoints and upload behavior.

## Configuration and limits

Only the API needs `SCANNER_DRIVER=bouncer`, `BOUNCER_API_KEY` and
`SCANNER_TIMEOUT_SECONDS=50`. No browser/mobile scanner key is permitted.
Local development defaults to ClamAV. Unknown driver names fail closed.

Bouncer Free permits 500 scans per month for the entire account. Its quota and
provider availability remain operational dependencies, and scanning errors still
prevent new uploads. No subscription or automatic quota purchase is enabled.
The [privacy policy](https://usebouncer.dev/privacy/) allows up to 24-hour temporary
file retention, keeps private scan metadata, and identifies Mumbai as its region.
Generic filenames keep original user filenames out of the scanner's metadata.

## Verification

Operator checks authenticated the Free tier and passed a harmless synthetic scan,
a complete 25 MiB clean file, and rejection of the standard EICAR antivirus test.
The large-file and EICAR checks ran in the isolated Linux test container; no real
customer file, business file record, email or notification was used.

The runtime fixture passed a real 25 MiB multipart file, a 40 MiB multi-file
request, rejection above the PHP file limit and Nginx body limit, concurrent PHP
requests and independent live FPM health checks, all with a 512 MiB limit and no
network or application data. The final health ping took 1.8 ms while workers were busy.

Unit tests cover content/scan binding, transient credentials, malicious and
suspicious content, stale/partial results, SSRF targets, auth/quota/connection
failure, polling bounds and local signature freshness. API coverage exercises the
actual Bouncer binding before private profile storage, unchanged authorization,
quota/configuration failure, review-media rejection and immutable setting history.

The focused checks passed: 10 scanner unit tests (83 assertions), 24 unique API
tests and 18 Flutter repository/transport tests. Focused Pint, PHPStan and Dart
analysis passed. OpenAPI validation and the 39-operation trust contract passed;
validation retains eight existing unused-model recommendations. Generated
clients, runtime fixture, Compose configuration, whitespace and secret scans
passed. These checks do not replace the broader regression gates recorded in
the staging audit.

## Live deployment and acceptance

Commit `6506dbad9ee83e91605d6143223cce9791f42a79` on
`fix/render-free-uploads-20261020` is live in deployment
`dep-dbbkca3bc2fs73bg3mig`, finished at `2026-10-20T10:46:24Z`.
Only the three scanner settings above were applied; read-back matched and
unrelated configuration was preserved. Render plans and Bouncer remain Free,
Xendit remains TEST, and live commerce remains disabled. No migration, imported
job replay, credential rotation or customer-file operation was performed.

Public health, portal assets, CSRF/CORS/cookie guards and protected-route denial
checks passed after activation. In the initial nine-minute observation window,
no application errors, scanner/storage error matches, failure events or restart
events were found. Observed memory usage peaked at approximately 216 MiB under
the 512 MiB limit. This short window is not a sustained load test.

The real Cloudinary adapter uploaded and delivered a harmless 1-by-1 synthetic
PNG successfully. Cleanup was rejected: the Upload API returned 403 and the
documented Admin API returned an `unauthorized` result for that exact object.
The account owner must remove that single test image from Cloudinary Media
Library under `marketplace/staging`, with public ID beginning
`deployment-checks/staging-upload-`. No customer object was matched or deleted.

The owner confirmed that the Vendor profile-picture upload now saves, but the
picture is not displayed. Upload acceptance is therefore partial: rendering is
still unresolved. Public deployed bundles contain the authenticated private-photo
loader and allow blob previews. Render's API/portal hostnames, relative API bases,
same-origin rewrite destinations, trusted-proxy setting and private S3 disk all
matched their intended configuration. A fresh synthetic PNG passed private
existence, streamed-byte checksum, dimensions, MIME and size checks, and its exact
object version was removed. These operator checks do not prove the user's signed
photo request. Its sanitized browser GET status has been requested; no account
cookie, signed URL or customer image was extracted, and no speculative code change
was applied. Integrate the release branch
into the configured staging branch before a later branch-based deployment, so
that it retains this repair. Rebuild the Buyer app to include its timeout change.

**Follow-up — 22 October 2026:** the remaining account-photo display issue was
traced to proxy parsing and missing imported local photo files. The live Render
configuration was repaired, 36 existing photos were recovered into private
storage with checksums and audit records, and the Buyer account-read budget was
extended. See [the profile repair evidence](render-profile-repair-2026-10-22.md)
for exact verification and manual acceptance remaining.
