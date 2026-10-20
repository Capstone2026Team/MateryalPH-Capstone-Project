# Free staging runtime stability — 2026-10-20

## Observed failure

The API instance stopped at 09:15:37 UTC, with HTTP 502 responses during shutdown.
Render recorded `server_failed` at 09:16:01 UTC because its HTTP health check timed
out after five seconds, followed by `server_available`. PHP-FPM also reported
reaching its single ordinary request worker. Observed memory was approximately
156–172 MB against the existing 512 MiB limit; this incident did not establish an
out-of-memory failure. Vendor inbox and disputes loaded after retry.

## Repair

- Nginx sends `/up` to a separate PHP-FPM pool serving FPM's built-in ping. It
  checks a live PHP process without waiting behind application/provider requests.
  It does not expose FPM status or return a static success response.
- The ordinary request pool has two workers. The plan remains Free; there is no
  promise of sustained concurrency within 512 MiB. Monitor actual memory after
  deployment, including the colocated queue and scheduler.
- `/api/v1/health` still executes Laravel and must be checked separately from the
  process probe. Startup continues to run the guarded application release step.
- An authorized profile-photo request for a missing imported object returns the
  already documented HTTP 404 instead of a storage metadata exception. Signature,
  ownership and version checks remain in place. No profile data is cleared.

No migration, request/response schema, credential, provider, plan or business rule
changes are required. Copying a database does not transfer historical file objects;
their private storage migration remains separate work.

## Reproduce the runtime regression

Build the production image from the repository root:

```sh
docker build -f infrastructure/docker/api.render.Dockerfile -t materyalph-api:staging-review .
python scripts/deployment/test-render-runtime.py --image materyalph-api:staging-review
```

The test runs the actual Nginx/FPM configuration in a separate container with no
network, no credentials, a 512 MiB limit and a generated PHP fixture. It starts two
six-second requests, requires a sub-second GET and successful HEAD `/up` while
both workers are busy, and then requires HTTP 502 after stopping fixture FPM.
Only its uniquely named container is removed. Ignored fixture files remain under
`.tmp/staging-deployment` for inspection.

Observed result with the cached production PHP 8.4.26 image: all checks passed;
GET `/up` took 4.4 ms while both request workers were busy. This fixture validates
process routing and failure detection, not provider performance or real workload
memory consumption.

Focused validation: 18 account security tests passed (177 assertions), including
the missing-object regression and existing signed ownership/version cases. The
messaging and disputes suites passed their other 49 tests in the initial run;
that run also exposed a database-default hydration error in the new test fixture,
which was corrected before rerunning the complete account security suite. Focused
Pint (two files), controller PHPStan, Compose validation, secret scanning and
whitespace checks passed. No client code or generated API client changed.

## Separate browser Maps issue

Both deployed portal bundles contain their configured browser map key, matching
the saved portal settings. Neither browser key equals the backend Maps key.
An unauthenticated, isolated Chromium diagnostic reproduced
`RefererNotAllowedMapError`, and the user independently confirmed the same error
for the Vendor store profile. Google rejects the Render website's HTTP referrer.
The key's website restrictions need the two exact staging portal origins with
`/*`, preserving existing restrictions. A frontend rebuild is unnecessary when
only the provider's allowed websites change.

A read-only attempt to inspect API-key restrictions was refused because the
Google API Keys management API is disabled for the available service account's
consumer project. This does not establish whether Maps JavaScript API is enabled.
An IAM permission check returned none of `serviceusage.services.enable`,
`apikeys.keys.lookup`, `apikeys.keys.get` or `apikeys.keys.update` for the saved
account. The account owner must save the website entries in Google Cloud Console.
No Google API, billing setting, credential or restriction was changed by the agent.
