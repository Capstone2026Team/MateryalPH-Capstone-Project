# Railway Hobby + Vercel Hobby staging cost worksheet

Prepared 2026-10-21. Status: account connections verified; no paid resources created.
Deployment owner: Railway personal workspace `capstone2026team's Projects`;
Vercel personal scope `3rdcapstone2026-8032`, confirmed active Hobby. Railway's
subscription and configured spending controls must be checked in its dashboard;
the connected inventory APIs do not expose them.

Provisioning attempt on 2026-10-22: Railway rejected private staging project creation
with `Deploys have been paused temporarily`. No project, services, domains or volumes
were created. Resolve the provider's paused-deployment condition before provisioning;
the connector did not identify its cause. The official
[Railway status page](https://status.railway.com/) subsequently confirmed an active
platform incident affecting the dashboard/API and pausing builds in all regions.

## Rates and calculation

[Railway pricing](https://docs.railway.com/pricing/plans): Hobby costs at least
US$5/month and includes US$5 of resource usage. The total is
`max(5, 10 * average_GB_RAM + 20 * average_vCPU + .15 * volume_GB + .05 * egress_GB)`.
Do not add another $5 to usage above $5. Taxes, external services and backups
are separate. These are monthly scenarios, not measured forecasts or quotes.

| Scenario, all six services combined | Average RAM | Average CPU | Volumes | Egress | Railway monthly total |
| --- | ---: | ---: | ---: | ---: | ---: |
| Light staging illustration | 2 GB | 0.15 vCPU | 3 GB | 5 GB | $23.70 |
| Busier staging illustration | 3 GB | 0.30 vCPU | 3 GB | 10 GB | $36.95 |
| Sustained resource ceilings, illustrative upper compute case | 6.25 GB | 5.5 vCPU | 3 GB | 10 GB | $173.45 |

Container limits are failure ceilings, not reserved capacity or predicted usage.
ClamAV definitions, concurrent scans, PDF/OCR/FFmpeg work and PostgreSQL cache can
raise the measured baseline. Measure idle and representative uploads for 24 hours,
then replace the illustrative numbers.

## Month-long survey budget

User requirements clarified 2026-10-22: seven days a week for the whole month, with
participant access from 07:00 to 21:00 each day in Asia/Manila (UTC+08:00). This is
14 hours daily: 420 hours in 30 days, or 434 hours in 31 days. The earlier 98-hour
estimate applied to seven days total and does not apply to this requirement.
The budget target remains US$5 for Railway. Survey dates and the defense session
remain to be assigned; defense, setup, warm-up and rehearsal runtime also consume usage.

The following calculation reuses the unmeasured light/busier assumptions above,
with all six services running 14 hours daily throughout a 30-day billing period.
It retains the full-month 3 GB volume allowance and the same total 5 GB / 10 GB
egress estimates. The compute reduction does not eliminate retained storage costs
or external provider charges.

| Month-long scenario | Compute usage | Volume + egress usage | Railway bill after $5 minimum |
| --- | ---: | ---: | ---: |
| Light illustration | $13.42 | $0.70 | $14.12 |
| Busier illustration | $21.00 | $0.95 | $21.95 |

Formula: `max(5, (10 * running_GB_RAM + 20 * running_vCPU) * 14 / 24 + .15 * 3 + .05 * egress_GB)`.
These are planning illustrations, not measured forecasts, a guaranteed bill or a
guarantee of month-long uptime. The current assumptions exceed the $5 target even
with nightly shutdowns. A smaller safe footprint must be measured before claiming
that the full system can meet this budget. Hobby can remain the subscription plan;
resource usage above its included $5 is billed without requiring a Pro upgrade.
Taxes, backups, external storage/providers and retained Render are excluded. If the
survey crosses a billing-cycle renewal, each cycle has its own Hobby minimum and
included usage; account for the actual survey dates and billing-cycle boundaries.

This saving requires stopping actual Railway compute outside the window, including
PostgreSQL and Redis, while retaining their persistent volumes and private objects.
Closing the portals does not stop backend compute. Existing service configurations
still run continuously; no daily start/stop automation or access window is configured.
Any implementation must start and verify dependencies before opening, drain in-flight
work before stopping, retain fail-closed scanning, and account for deferred queue and
scheduler work. Workflow expiry clocks continue overnight; do not change their rules.
Measure representative complete-stack usage before relying on the schedule for the
survey. Merely reducing memory ceilings is not evidence of lower safe running usage.

Source inventory (read-only, 2026-10-22): database 116,535,779 bytes (about 111 MiB),
Redis used memory 1,457,552 bytes, RSS 9,814,016 bytes and AOF 29,431,079 bytes.
PostGIS 3.5.2, pg_trgm 1.6 and pgcrypto 1.3 are installed. Check full PGDATA/WAL
and backup headroom before creating volumes. The measured PGDATA directory is
307,236,864 bytes (about 293 MiB), including 83,894,272 bytes of WAL (about 80 MiB),
so the proposed 2 GB database volume has headroom for this snapshot. Referenced private object count/bytes
still require the frozen export manifest.

## Initial topology

| Service | RAM ceiling | CPU ceiling | Persistent volume | Public ingress |
| --- | ---: | ---: | --- | --- |
| API + nginx/FPM + freshclam | 4 GiB | 2 | None; private uploads go to S3 | HTTPS |
| Queue worker | 512 MiB | 1 | None | None |
| Continuous scheduler | 256 MiB | 0.5 | None | None |
| Reverb | 256 MiB | 0.5 | None | WSS/HTTPS |
| PostgreSQL 16 + PostGIS | 1 GiB | 1 | Initially 2 GB | Private only |
| Redis 7.4, AOF, noeviction | 256 MiB | 0.5 | Initially 1 GB | Private only |

One replica each in Singapore; sleeping disabled. Total RAM ceiling is 6.25 GiB.
Hobby permits up to 5 GB per volume. Before provisioning measure PostgreSQL
database/WAL/index size and Redis used memory/AOF size. Resize within the allowance
with headroom, or stop and revise the plan; never silently discard data or disable
persistence to fit. Backups also need headroom and their own retention cost review.

External lines requiring inventory: private encrypted S3 in ap-southeast-1
(storage, requests, egress and retained backup objects); Cloudinary; Google Maps;
Firebase; Gmail mailbox/quota; retained Render services. Xendit remains TEST.
Do not assume free tiers cover these. No new AWS account or bucket is purchased
without an approved external storage budget and secure account access.

Vercel Hobby has no subscription fee, subject to its allowances and
[personal noncommercial conditions](https://vercel.com/docs/plans/hobby).
The API proxy consumes Vercel transfer/request allowances as well as Railway
egress. Keep staging noncommercial; review eligibility before launch.

## Approval and controls

The original migration request reserves paid provisioning until this worksheet is
approved. The later request authorizes using the connected accounts to deploy;
the revised budget target is now US$5. Confirm the effective spending control and
review the month-long estimate above before starting metered workloads.

The earlier $25 alert / $40 hard-limit suggestion was not approved or configured.
The user's target is US$5 for the month-long survey above. Correction verified
2026-10-22: Railway's documented minimum nonzero compute hard limit is **$10**;
the earlier $5 hard-limit suggestion was incorrect and was never configured.
A $5 email alert is supported, but an alert does not stop workloads or cap charges.
See the [official usage-limit validation rules](https://docs.railway.com/cli/usage).
No increase of the user's budget to $10 is approved or implied by this correction.
Native hard limits therefore cannot promise an exact $5 shutdown threshold.
Reaching a configured hard limit takes **all workloads offline**, potentially
before the last survey day. Check measured usage, remaining cycle allowance and
any existing costs before starting; do not raise the limit automatically. These
controls do not cap external AWS/Google/Cloudinary, taxes, subscription renewals
or retained Render bills.
Configure them under Railway Workspace Usage and verify the effective values
before accepting staged deployments. The connector does not expose a billing-limit
write operation. See [Railway cost controls](https://docs.railway.com/pricing/cost-control).

Usage spending accumulates throughout the billing cycle; lower traffic reduces
new charges but never refunds already consumed usage. Exhausting Hobby's included
$5 alone does not stop deployments: additional resource usage is billed. After a
hard-limit shutdown, resuming in the same cycle requires raising/removing that
limit and accepting any resulting additional usage charges. Alternatively wait
for the next billing-cycle reset, which still incurs the normal Hobby subscription
renewal. This is not a free refill when traffic decreases. Railway documents
automatic redeployment after the blocking issue is resolved within 30 days;
after that, manual redeployment is required. See [billing](https://docs.railway.com/pricing/understanding-your-bill)
and [stopped-service recovery](https://docs.railway.com/pricing/faqs).

Record approval date, approved Railway cap, external storage budget, dashboard
alert/limit confirmation, measured source sizes and actual 24-hour usage here before
cutover. Upgrade the existing project to Pro later; retain service IDs, endpoints,
data and Buyer configuration. No reimport or APK rebuild is needed solely for a plan change.
