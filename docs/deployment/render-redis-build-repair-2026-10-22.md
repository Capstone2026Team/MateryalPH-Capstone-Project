# Render Redis extension build repair - 22 October 2026

## Confirmed cause

Both `Improvement_v8` builds of commit
`29a4b491b448ec3aaf618df6dc77b5e99e54c0dc` failed before application startup:

| Service | Failed deployment | Build error |
| --- | --- | --- |
| API | `dep-dbcfdm59fdbs73e9g18g` | PECL Redis 6.3.0 download returned HTTP 504 |
| Reverb | `dep-dbcfev6i0phs73a77pd0` | PECL Redis 6.3.0 download returned HTTP 504 |

The live Render inspection still identified the previous API release
`14d5c98a339a333d18309cbb60f794f26312300d` and Reverb release
`04c9c28a49cdda4f94b22a975c7967f5cbccf05e` as `live`. This is deployment-state
evidence, not authenticated feature acceptance.

## Source repair

`infrastructure/docker/install-phpredis.sh` downloads the official
[phpredis 6.3.0 source](https://github.com/phpredis/phpredis/releases/tag/6.3.0)
over HTTPS, with four retries and bounded connection/request/retry times. It
verifies the pinned SHA256 before extracting or compiling, installs through the
official PHP image's extension helper, and requires the loaded extension version
to equal 6.3.0. No PECL download or channel lookup is needed.

The shared installer is used by `api.render.Dockerfile`, `api.staging.Dockerfile`
and `api.Dockerfile`, which all had the same unpinned PECL download step. Redis
installation is a separate layer after the built-in PHP extensions, preserving
that expensive build cache across installer changes or download failures.

The infrastructure job in `.github/workflows/ci.yml` runs
`scripts/deployment/test-phpredis-installer.sh` with two isolated failure cases:
a corrupt downloaded archive and a failed downloader after retries. Both must
stop before compilation.
The tests replace only the downloader/compiler commands with synthetic fixtures;
the successful install must also be verified by building the actual image.

No migration, API contract, generated client, authorization, application rule,
provider configuration, secret, hosting plan or staging data changes are required.

## Validation and release

Completed checks:

- Render, Railway staging and development image builds: all three passed.
- Render image: PHP 8.4.27, loaded Redis 6.3.0, runtime user `app`, PHP-FPM
  configuration and Nginx configuration: passed.
- Network-isolated Render runtime regression at 512 MiB and 0.5 CPU: passed.
  Both ordinary workers served requests concurrently; GET `/up` took 2.1 ms
  while they were busy, HEAD `/up` passed, and stopped FPM produced HTTP 502.
  The 25 MiB file, multipart request above 32 MiB, file/request limit enforcement,
  original-route logging and query-string redaction checks also passed.
- Deployment-script tests: 8 passed, 0 failed.
- Installer failure checks: both cases passed in a network-isolated container.
- Installer/test shell syntax, Compose configuration and CI YAML parsing: passed.
- Source secret scan and changed-file whitespace: passed.

Reproduce the production build and runtime regression from the repository root:

```sh
docker build --pull -f infrastructure/docker/api.render.Dockerfile -t materyalph-api:redis-build-fix .
python scripts/deployment/test-render-runtime.py --image materyalph-api:redis-build-fix
sh scripts/deployment/test-phpredis-installer.sh
node --test scripts/deployment/staging-deployment.test.mjs
```

The full application suites and authenticated browser/device/provider acceptance
were not run for this container-only repair.

No commit, push, remote configuration change or deployment was performed. Render
builds the Git repository, so the repair takes effect after these source changes
are published to `staging` and that new commit is deployed to the API and Reverb
services. Use a normal build with caching; clearing the cache is unnecessary.
Verify each resulting deployment reaches `live`, then check `/up`,
`/api/v1/health` and the authenticated realtime workflow separately. Existing
Render environment values can be retained; no new key is needed.

Suggested commit: `fix(build): install pinned Redis extension without PECL`
