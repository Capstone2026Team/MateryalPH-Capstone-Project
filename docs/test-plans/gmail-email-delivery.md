# Local Gmail email delivery

MateryalPH uses Laravel SMTP through `MailProvider` for verification, recovery, invitations, security, onboarding, compliance, inventory, order, finance and dispute emails. The existing outbox and notification delivery records retain retries and authorization checks. Automated tests use the array transport and never send external email.

## Prepare the sender

1. Choose a dedicated personal Gmail account for development. Enable [2-Step Verification](https://support.google.com/accounts/answer/185839?hl=en).
2. Create an [App Password](https://myaccount.google.com/apppasswords) named `MateryalPH Local`. Follow [Google's App Password requirements](https://support.google.com/accounts/answer/185833?hl=en). If the option is unavailable, resolve the account restriction before activation.
3. Store the App Password privately. Enter it only in the ignored `services/api/.env` file; never put it in chat, an example file, frontend configuration, a command argument or a log. Use the generated App Password without display spaces, not your normal Google password.
4. Choose a recipient mailbox you control for the delivery test. Real credentials must stay separate from testing, staging and production.

## Activate after automated checks pass

Run these PowerShell commands from the repository root. If `docker` is on PATH, it can replace the full executable path.

```powershell
$dockerCli = 'C:\Users\RJ\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe'
& $dockerCli compose stop horizon scheduler
```

Edit `services/api/.env` locally. The sender address and username must match. `MAIL_URL` must remain empty so a URL cannot override the approved SMTP settings.

```dotenv
MAIL_MAILER=smtp
MAIL_SCHEME=smtp
MAIL_URL=
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_REQUIRE_TLS=true
MAIL_TIMEOUT_SECONDS=10
MAIL_USERNAME=your-sender@gmail.com
MAIL_PASSWORD="APP_PASSWORD_ENTERED_LOCALLY"
MAIL_FROM_ADDRESS=your-sender@gmail.com
MAIL_FROM_NAME=MateryalPH
MAIL_DELIVERY_NOT_BEFORE=UTC_ACTIVATION_TIMESTAMP
```

Generate the activation timestamp once, then paste it into `MAIL_DELIVERY_NOT_BEFORE`:

```powershell
(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
```

Only emails whose originating outbox event or notification was created at or after this timestamp can be sent. An old notification remains old even if its delivery job is created later. Older direct email events are processed without sending; older notification email deliveries become `SKIPPED`. In-app history and push behavior remain available. Preserve the timestamp across restarts and credential changes; do not replace it each time a container starts.

Gmail configuration fails closed if the timestamp is missing or malformed, STARTTLS/certificate verification is disabled, the sender differs from the SMTP username, credentials are blank, the transport is not SMTP, or a mail URL overrides the configuration. SMTP errors remain retryable and use safe errors without provider transcripts or chained SMTP exceptions. There is no fallback to a logging transport.

Apply the configuration without rerunning migrations or seeders:

```powershell
& $dockerCli compose exec -T api php artisan config:clear
& $dockerCli compose up -d --no-deps --force-recreate api horizon scheduler
& $dockerCli compose exec -T api php artisan materyalph:mail-test --to=your-test-mailbox@example.com
```

The command is restricted to local/development/testing environments and requires an explicit valid recipient and SMTP transport. A success means the SMTP server accepted the message. Confirm receipt in the chosen mailbox, including its spam folder, before recording live delivery as passed.

## Acceptance checks

Run the focused files explicitly in the isolated stack:

```powershell
& $dockerCli compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php -d memory_limit=512M vendor/bin/phpunit tests/Feature/Api/GmailDeliveryTest.php tests/Feature/Api/OutboxDeliveryTest.php tests/Feature/Api/EmailOtpLifecycleTest.php tests/Feature/Api/PhaseFifteenNotificationsTest.php
```

For the complete suite, use the explicit file list to avoid the existing filtered test-discovery issue. The 512 MB limit also accommodates image-validation fixtures:

```powershell
$apiTestFiles = rg --files services/api/tests -g '*Test.php' | ForEach-Object { $_.Replace('\', '/').Substring('services/api/'.Length) }
& $dockerCli compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php -d memory_limit=512M vendor/bin/phpunit @apiTestFiles
```

- Run the isolated `GmailDeliveryTest`, `OutboxDeliveryTest`, `EmailOtpLifecycleTest` and `PhaseFifteenNotificationsTest`, then the full isolated API suite. Run Pint, PHPStan, OpenAPI validation, Compose validation and a filesystem secret scan.
- Confirm the installed Laravel/Symfony transport requires STARTTLS on port 587, keeps certificate verification and uses the configured 10-second timeout without contacting Google during automated tests.
- Confirm old direct events and old notifications do not reach SMTP after activation. Fresh requests send, preserve history, and do not reset the cutoff.
- Confirm expired, consumed, invalidated, replaced, exhausted, missing or recipient/purpose/code-mismatched OTP records do not send. Sending does not consume an OTP; verification remains the single-use operation.
- Confirm SMTP failure leaves the outbox retryable; successful retry completes it; processing an already completed event does not resend. Existing notification preferences, invitation expiry/revocation and current recipient authorization remain enforced.
- After a successful real mailbox test, request a fresh email verification/recovery code using an eligible account and create a fresh authorized invitation to a mailbox you control. Confirm receipt and the existing verification/acceptance behavior. Do not replay old development invitations or print codes/tokens as evidence.

## Troubleshooting and rollback

- `MAIL_CONFIGURATION_INVALID`: check the required settings locally without printing configuration or secrets. The cutoff must use the exact UTC format `YYYY-MM-DDTHH:MM:SSZ`.
- `MAIL_AUTHENTICATION_FAILED`: use the account's complete Gmail address for both the SMTP username and From address. The password must be an App Password generated by that same account, with 2-Step Verification enabled; an account display name or normal Google password is insufficient. Fix these values only in the ignored local environment file, then recreate the services.
- `MAIL_TRANSPORT_UNAVAILABLE`: check the App Password, account security restrictions and outbound access to `smtp.gmail.com:587`. Changing the Google password revokes App Passwords. Fix credentials locally, then clear configuration and recreate the API/worker/scheduler to refresh container environment variables.
- A request's success confirms durable queueing; it does not prove mailbox delivery. Check the existing operational outbox/notification delivery status and worker/scheduler health. Logs and failed jobs must contain safe failure information only.
- Gmail applies [daily sending limits](https://support.google.com/mail/answer/22839). SMTP acceptance does not guarantee inbox placement or exactly-once delivery after an ambiguous network failure.
- To return to Mailpit, stop `horizon` and `scheduler`, set `MAIL_HOST=mailpit`, `MAIL_PORT=1025`, `MAIL_SCHEME=smtp`, `MAIL_REQUIRE_TLS=false`, and clear `MAIL_USERNAME`/`MAIL_PASSWORD` in the local environment. Keep the activation cutoff. Clear configuration and recreate only `api`, `horizon` and `scheduler` with the commands above. Do not delete queue or commercial history.

No migration, public API change or generated-client update is required for this transport integration. Hosted activation is outside this local rollout.
