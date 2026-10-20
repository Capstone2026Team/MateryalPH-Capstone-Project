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
network or application data. The health ping took 2.3 ms while workers were busy.

Unit tests cover content/scan binding, transient credentials, malicious and
suspicious content, stale/partial results, SSRF targets, auth/quota/connection
failure, polling bounds and local signature freshness. API coverage exercises the
actual Bouncer binding before private profile storage, unchanged authorization,
quota/configuration failure, review-media rejection and immutable setting history.

Live deployment and authenticated user acceptance remain separate from these
operator and isolated-container checks until recorded below.
