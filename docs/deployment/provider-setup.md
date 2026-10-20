# Staging provider setup

## Free-only setup: storage, mail and scanning configured

The owner confirmed that only Render Free compute is available. The Backblaze account, private staging bucket and scoped application key have since been created and validated. Keep the current Render plans. Account setup and remaining steps are:

1. **Backblaze B2 account and bucket: completed.** Keep billing disabled and stay within the [first 10 GB free storage allowance and download limits](https://www.backblaze.com/cloud-storage/pricing). Review [data caps and alerts](https://www.backblaze.com/docs/en/cloud-storage-data-caps-and-alerts); the free allowance is not unlimited storage or traffic. Existing imported objects still require a separate checked copy.
2. **Brevo SMTP configuration: completed; delivery acceptance pending.** The owner confirmed sender readiness. The [Free plan includes transactional email and 300 sends per day](https://help.brevo.com/hc/en-us/articles/208589409-About-Brevo-s-pricing-plans). The SMTP relay uses port 2525 with mandatory TLS; no paid plan or add-on was selected.
3. **Bouncer Free scanning: configured and deployed.** Real clean-file, full 25 MiB and antivirus-rejection checks passed. The owner confirmed that a Vendor profile-picture upload saves; display remains unresolved. See [the upload repair evidence](render-free-uploads-2026-10-20.md).
4. Save provider credentials only in the ignored `services/api/.env.staging.providers` file. Leave the browser-push VAPID setting blank until it is obtained from the matching Firebase project. Do not paste keys or email verification codes into chat.

The owner created Brevo credentials and confirmed sender readiness. SMTP authentication passed, and the staging mail configuration is saved in Render. Render account access does not include other providers' sender-verification sessions, so sender verification is owner-confirmed rather than independently checked in Brevo's dashboard. The later Bouncer deployment below resolves scanner configuration separately from storage and mail.

### Brevo validation on 2026-10-20

The owner saved an SMTP login and key in the ignored local API `.env`. A probe using the production-locked Symfony mailer authenticated successfully to `smtp-relay.brevo.com:2525` with mandatory STARTTLS and certificate/hostname verification. The negotiated connection was encrypted. The probe issued no `MAIL FROM`, `RCPT TO` or `DATA` command and sent no email. The valid login/key and safe transport settings were copied directly into the ignored staging provider input, without printing their values.

An earlier input mixed Gmail's host/port with Brevo credentials and used the SMTP login as the sender. After the owner confirmed sender readiness, the corrected real sender was found in the local `.env` and copied into the staging provider input while preserving the previously authenticated Brevo login/key. A fresh probe passed SMTP authentication, negotiated TLS and sender-format checks against the completed staging input. It sent no message.

The following configuration was saved directly into the staging API's Render environment fields and read back successfully: Brevo host, SMTP port 2525, `MAIL_SCHEME=smtp`, mandatory TLS with certificate verification, a 10-second timeout, the authenticated login/key, owner-confirmed sender and MateryalPH sender name. `MAIL_URL` remains unset so it cannot override the transport. Unrelated direct variables and the shared environment group were preserved. The fresh `MAIL_DELIVERY_NOT_BEFORE=2026-10-20T09:11:01Z` boundary was applied before the new credential fields; no older requests or failed jobs were replayed. The local development `.env` was not rewritten.

Deployment `dep-dbbj0ec9v7es73fdepk0` is live on the existing application commit `04c9c28a49cdda4f94b22a975c7967f5cbccf05e`, finished at `2026-10-20T09:12:35Z`. Post-deploy public health, portal assets, CSRF, CORS, cookie guards and expected cold-start bundle checks passed. The initial short post-deploy log query found no application `ERROR` entries. All Render plans remain Free. SMTP authentication was tested from the operator's machine. Sender authorization, SMTP access from Render and actual mailbox delivery remain separate acceptance checks. No verification, invitation or test email was sent by this setup operation.

The previously blocked public smoke command was rerun successfully during this follow-up: API health, transport guards, portal routing/assets, CSRF, CORS and the expected cold-start bundle settings passed for the current deployment. This closes that earlier shell-check gap; it does not prove SMTP connectivity from Render or actual message delivery.

### Backblaze progress on 2026-10-20

The owner-created bucket `materyalph-staging-private-2026` is private with encryption enabled and Object Lock disabled. Its region is `us-west-004`, with S3 endpoint `https://s3.us-west-004.backblazeb2.com`. These public connection settings have been saved in the ignored staging provider input.

An earlier credential check found that `services/api/.env` contained the bucket ID in `AWS_ACCESS_KEY_ID`. An S3 request returned `InvalidAccessKeyId`, and direct Backblaze authorization returned HTTP 401. Those invalid settings were not applied. The owner then corrected the credentials. The successful checks below supersede that rejected attempt.

- Backblaze authorization returned HTTP 200, confirmed access was restricted to the expected bucket, confirmed required file capabilities and confirmed the regional S3 endpoint.
- An independent signed S3 probe uploaded a small synthetic object, downloaded matching bytes/SHA-256 and confirmed an unsigned download was denied with HTTP 401. Its exact test-object version was removed.
- A separate Laravel Filesystem/S3 adapter probe passed private upload, download/checksum, unsigned-access denial and cleanup using an isolated installation of the same production dependency lock as application commit `04c9c28a49cdda4f94b22a975c7967f5cbccf05e`. It used the SDK's normal checksum behavior. Development dependency folders were not changed.
- The valid key pair and public connection settings were transferred directly into the staging API's Render environment fields. `FILESYSTEM_DISK=s3`, `VENDOR_PRIVATE_DISK=s3` and path-style addressing remain enabled. The optional `AWS_URL` remains unset. Read-back matched the intended settings and preserved unrelated direct service variables. The complete configuration was also saved into the ignored staging provider input; no secret values were printed or committed.
- Deployment `dep-dbbd47brjlhs73dr20q0` is live on the existing application commit, finished at `2026-10-20T02:30:51Z`. The connected Render tool confirmed the deployment status. No paid resource or plan change was made.

These storage checks ran from the operator's machine, not an authenticated application journey on Render. Only synthetic connectivity objects were written; no customer files were read, migrated or published, no file records were created, and scanning was not bypassed. Historical file objects still need a checked source-to-staging copy before existing attachment access can be accepted. Scanning was unavailable at storage activation; the later Bouncer deployment below supersedes that configuration blocker.

The initial post-deploy application-log query found no `ERROR` entries after activation in its short observation window. The first shell-based health/CSRF/CORS/portal-asset rerun was blocked because automatic approval review hit a usage limit; a web-fetch attempt also could not access the URLs. These failed attempts were not counted as health passes. The later command `node .tmp/staging-deployment/probe-live-portals.mjs` passed during the Brevo follow-up above, closing that smoke-check gap. Live deployment status was independently verified through the Render connector and recorded in the ignored operator deployment file.

## Applied on 2026-10-20

The owner explicitly requested use of the existing local API credentials in the Free Render preview. Nine settings were transferred directly from ignored configuration into the verified staging API's environment fields. No secret values were printed, committed or put in a frontend bundle. The existing nonproduction provider accounts are shared with local development for this requested demo setup; they are not independent staging credentials and must not be promoted to production.

| Integration | Configuration and evidence |
| --- | --- |
| Backend Google Maps | `GOOGLE_MAPS_SERVER_API_KEY` saved. Geocoding, Places and Routes checks returned HTTP 200. |
| Cloudinary public media | `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET` saved. Authenticated ping passed. New public uploads use `CLOUDINARY_ASSET_FOLDER=marketplace/staging`. This does not replace private storage or scanning. |
| Xendit TEST | `XENDIT_SECRET_KEY`, `XENDIT_WEBHOOK_VERIFICATION_TOKEN` saved. Money-in read passed; a nonexistent account returned the expected not-found response. A separate balance read was forbidden; balance access is not used by these checks. Creation, refunds and actual callbacks remain acceptance checks. |
| Firebase native push | `FIREBASE_PROJECT_ID`, `FIREBASE_SERVICE_ACCOUNT_JSON_BASE64` saved. OAuth and FCM `validate_only` returned HTTP 200. No notification was delivered. Browser push remains off because its public VAPID configuration is incomplete. |

The API was redeployed on the previously tested application commit `04c9c28a49cdda4f94b22a975c7967f5cbccf05e`: deployment `dep-dbbc84vf3r2c738bu850` is live. `XENDIT_MODE=TEST` and `LIVE_COMMERCE_ENABLED=false` remain in effect. All existing Render plans remain Free. A read-back confirmed no differences from the intended nine settings. Live public health, routing, CSRF, CORS and portal-asset checks passed. An unsigned payment webhook returned HTTP 401 with `WEBHOOK_INVALID`, confirming that the configured endpoint still fails closed.

These provider checks were made from the operator's machine. They do not prove every authenticated workflow or provider permission from Render's outbound addresses. No email, payment, refund, provider-account creation, application file upload or push delivery was triggered. The later storage probes above used synthetic connectivity objects only. No failed jobs or historical provider events were replayed. No production code, migration or API payload changed in this follow-up; the broader regression failures recorded in the [audit](render-audit-2026-10-20.md) remain open.

The provider dashboard/browser helper could not start (`failed to write kernel assets`). No provider accounts, VAPID keys or dashboard webhook subscriptions were created through UI automation.

### Connected Render plugin verification

The subsequently connected Render plugin successfully listed the confirmed capstone workspace and all four staging services. API and Reverb remain Free, both portals remain static sites, and neither compute service has a persistent disk. Live metrics confirm the API's approximately 512 MiB memory limit. Public health, routing, CSRF, CORS and portal-asset checks passed. Private storage and mail were configured in the later provider follow-ups above.

Render access does not grant access to Backblaze/Brevo, Firebase Console or Xendit Dashboard. The Render connection can apply credentials and deploy the application once the external resources exist; it does not provision a transactional mail account or an external S3 bucket. [Persistent disks require paid Render compute](https://render.com/docs/disks), and [Free compute blocks the local Gmail SMTP ports](https://render.com/docs/free). No paid resource, extra service, scan bypass, database access-rule change or placeholder success was introduced during this check. An optional read-only database sizing query through the plugin was unavailable; no database connectivity change was made for it.

Plugin discovery found an official Firebase integration that may provide the remaining project access. Installation/connection has been offered but is not yet confirmed. No suitable storage or transactional-relay integration was confirmed from the directory results. Mailbox delivery acceptance and relevant provider-side access remain separate from Render permissions. The subsequently configured scanner is recorded below.

## Private storage: create a reachable private bucket

The local `AWS_ENDPOINT` points to Docker MinIO. Its credentials cannot make that private local hostname reachable from Render. Uploaded objects also were not made available merely by copying the SQL database.

One option compatible with the existing S3 driver is [Backblaze B2](https://www.backblaze.com/sign-up/s3). Account creation does not require a credit card; review its current free allowance and limits before using it. No account or billable resource has been created for you.

1. Create a dedicated staging bucket with **Private** visibility. Retain the provider's default encryption. Do not make documents or profile photos public.
2. Create a standard application key limited to this bucket and the file operations required by the API. Do not use the master key. Follow the provider's [S3 application-key instructions](https://www.backblaze.com/docs/cloud-storage-s3-compatible-app-keys).
3. Fill the ignored `services/api/.env.staging.providers` input: `AWS_ACCESS_KEY_ID` is the key ID; `AWS_SECRET_ACCESS_KEY` is the application key; `AWS_BUCKET` is the bucket name; `AWS_DEFAULT_REGION` is that bucket's region; `AWS_ENDPOINT` is the provider's HTTPS S3 endpoint. Leave `AWS_URL` blank and retain private access. Keep these credentials separate from development and production.
4. Validate authenticated write/read access and denial of unsigned public reads before applying the settings. Existing source objects must then be copied into staging without deleting originals, preserving object keys and checking byte size/checksum against database metadata.
5. After an API redeploy, accept authorized reads, denied cross-account reads and expired-link handling. Scan-dependent uploads still require the scanner below.

## Mail: use a supported transactional transport

The saved local Gmail app password is for SMTP on port 587. [Render Free blocks ports 25, 465 and 587](https://render.com/docs/free); copying that password does not provide mail delivery.

[Brevo Free](https://help.brevo.com/hc/en-us/articles/208580669-FAQs-What-are-the-limits-of-the-Free-plan) is one compatible option, currently with 300 sends per day. Its [SMTP relay supports port 2525](https://help.brevo.com/hc/en-us/articles/10905415650322-Which-SMTP-port-should-I-use-Port-587-465-or-2525), so the existing Laravel SMTP transport can be used without an application change.

1. Create or sign in to the provider account, verify the intended sender, and complete any required sender/domain checks.
2. Obtain its **SMTP login and SMTP key**, not a general REST API key. Fill the ignored input's `MAIL_HOST`, `MAIL_USERNAME`, `MAIL_PASSWORD` and verified `MAIL_FROM_ADDRESS`. Use `MAIL_PORT=2525`, `MAIL_SCHEME=smtp` and `MAIL_REQUIRE_TLS=true`; for Brevo the host is `smtp-relay.brevo.com`.
3. Before enabling delivery, set `MAIL_DELIVERY_NOT_BEFORE` to the activation time in exact UTC `YYYY-MM-DDTHH:MM:SSZ` format. Preserve old records; do not replay imported mail or old security codes.
4. Verify TLS/authentication without sending first, apply the settings to the API and redeploy. Actual delivery needs an explicitly requested test or a new user-initiated verification/invitation flow. SMTP authentication alone does not prove mailbox delivery.

## Upload scanning: Bouncer Free selected on 2026-10-20

The owner selected an ongoing free scanner and explicitly approved lowering new review-video uploads to **25 MiB (26,214,400 bytes)**. This supersedes the former 100 MB ceiling; the [Buyer](../workflows/MateryalPH_Final_Buyer_Workflow.md) and [System](../workflows/MateryalPH_Final_System_Workflow.md) workflows record the decision. Existing photos/documents keep their lower purpose-specific limits, and historical media remains available under existing permissions.

[Bouncer Free](https://usebouncer.dev/docs/) provides 500 scans per account per month and 25 MiB files. Its v1 upload path stops around 4.5 MB, so the backend adapter uses v2's authenticated upload-target request, server-only HTTPS multipart upload and bounded result polling for every file. No client receives scanner credentials or signed upload fields. A result must be completed, clean, fresh, and match the complete file's SHA256 and size before existing storage/audit actions proceed. Provider errors, pending/failed scans, inconsistent results, quota exhaustion and unknown driver names fail closed.

Set only on the staging API: `SCANNER_DRIVER=bouncer`, `BOUNCER_API_KEY` and `SCANNER_TIMEOUT_SECONDS=50`. The key belongs in the ignored `services/api/.env.staging.providers` and Render's secret environment field. Local development defaults to the existing `clamscan` adapter with its seven-day signature freshness check. `RUN_FRESHCLAM=false` remains correct for the Free staging API; the external provider operates the scanner.

The owner created the Free account/key. Operator-side validation authenticated the Free tier and passed real scans of a harmless file, a full 25 MiB synthetic file, and rejection of the harmless EICAR antivirus test. No customer content was used. Deployment and authenticated upload acceptance are recorded in [the upload repair evidence](render-free-uploads-2026-10-20.md).

The monthly allowance resets on the first of the month UTC; requesting a scan consumes quota even if its direct upload subsequently fails. No automatic POST retries or paid upgrades are enabled. [Bouncer's privacy policy](https://usebouncer.dev/privacy/) permits temporary file retention for up to 24 hours and retains private scan metadata; its infrastructure is in Mumbai. The adapter sends generic filenames rather than original user filenames. Files are never submitted to a public malware corpus. Scanner quota/outages can still prevent new uploads.

## Complete provider-side acceptance

- **Xendit callbacks:** in TEST Dashboard webhook settings, point `payment_session.completed`, `payment_session.expired`, `refund.succeeded` and `refund.failed` at `https://materyalph-staging-api.onrender.com/api/v1/webhooks/xendit`. The separate Vendor account-status verification endpoint is `https://materyalph-staging-api.onrender.com/api/v1/webhooks/xendit/account-verification`. Verify the relevant account's callback token matches the saved secret. The [legacy webhook-settings API](https://docs.xendit.co/apidocs/set-webhook-url) does not configure every current Payment Sessions subscription. Do not redirect production events or blindly replay historical TEST events. A TEST checkout/refund and verified callback are still required to accept the flow.
- **Native Firebase:** use the staging API URL in the Buyer build and register the device again. Imported device tokens were deliberately excluded from encryption recovery. Real-device delivery, notification permission and iOS APNs configuration are separate acceptance checks.
- **Browser Firebase:** in Firebase Console → Project settings → Cloud Messaging → Web configuration, generate or obtain the Web Push certificate's **public VAPID key**. Complete both portals' `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_APP_ID`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_MESSAGING_SENDER_ID` and `VITE_FIREBASE_VAPID_KEY`, matching the backend project. Then enable `WEB_PUSH_APPROVED=true` on the API and `VITE_FIREBASE_PUSH_ENABLED=true` on the portals, redeploy the API and rebuild both portals. The service-account JSON remains backend-only; browser permission must be granted by the user. Until this is complete, browser push stays off.

Secret values belong only in the ignored input or cloud secret fields, never in chat. The ignored input now contains validated staging storage and Brevo mail configuration, including the owner-confirmed sender. Browser-push VAPID configuration remains incomplete and browser push stays off.
