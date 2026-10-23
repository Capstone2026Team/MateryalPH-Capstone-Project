# Private image display investigation — 2026-10-20

The owner confirmed that the Vendor profile-picture upload saves after the
Bouncer repair, but the picture is blank. Personal pictures stay in private
Backblaze storage behind an owner-bound five-minute API URL; Cloudinary serves
public Store/product media. No storage visibility or authorization change is
justified by the blank display.

## Current evidence

- The staging bucket contains one profile-photo object, created after the scanner
  release. It is nonempty. A bounded in-memory validation confirmed a valid
  256-by-256 PNG and a byte count matching object metadata. No image content,
  object name, hash, customer identifier or credential was printed or saved.
- Independent synthetic PNG checks passed private existence, streamed bytes,
  size, MIME and exact-version cleanup. Public portal bundles include the private
  authenticated Blob loader, permit Blob images, and use the expected same-origin
  `/api/v1` rewrite. Render API/portal hostnames and private-disk settings match.
- The connected Chrome Vendor session was expired. A fresh existing-account
  Google sign-in successfully reached `/auth/mfa`. The browser tab remains open
  at **Verify it is you** for the owner to enter the authenticator code directly.
  No code was extracted, generated, printed or bypassed. Authenticated image
  request inspection is pending this step.
- A read-only database aggregate was unavailable through Render MCP because the
  database's external IP allowlist is empty. The allowlist was not changed and no
  database mutation was performed.

## Access-log correction

Nginx logged `$uri`, which becomes `/index.php` during its front-controller
rewrite. That concealed the photo route and made prior route-filtered queries
inconclusive. `render-nginx.conf` now derives only the original path from
`$request_uri`, omitting its query. Signed URLs, OAuth codes and other query
credentials remain absent from access logs.

Commit `14d5c98a339a333d18309cbb60f794f26312300d` on
`fix/private-image-display-20261020` is live in deployment
`dep-dbblm2lg1s2s739d48ng`, finished at `2026-10-20T12:15:21Z`.
It adds only the Nginx logging correction and its runtime fixture assertions on
top of the live upload repair. It is **not** recorded as a fix for image display.
Render plans, credentials, scanner configuration and business behavior were
preserved. No migration or API contract change was made.

The network-isolated 512 MiB runtime fixture passed original-route logging,
query redaction, ordinary requests, 25 MiB and multi-file uploads, limits,
concurrent workers and independent live FPM health checks. Its busy-worker
health latency was 1.8 ms. Public health, portal assets and transport guards
passed after deployment. Staged secret scanning and whitespace checks passed.

An automatic approval-review usage limit initially prevented Git staging. No
rejected action was executed. After its stated reset time passed, the same narrow
action was approved; commit, push and deployment then completed normally.

## Pending acceptance

Complete the existing authenticator challenge in the open Chrome Vendor tab.
Inspect only sanitized status/error/correlation information from its photo
request, reproduce the actual failure, apply the minimal repair and verify the
picture in the authenticated browser. Do not publish a private photo to
Cloudinary, remove signing, expose a storage URL or bypass MFA as a workaround.
