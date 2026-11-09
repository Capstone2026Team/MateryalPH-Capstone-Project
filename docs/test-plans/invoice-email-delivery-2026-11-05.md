# Sent invoice email and purpose-specific email presentation

## Behavior

- Vendor **Send** creates an immutable sent invoice and one `INVOICES` notification bound to that `INVOICE_RECORD`. The normal sealed outbox queues delivery after commit. A draft save never emails the Buyer; a Buyer copy request is not required.
- The Buyer email contains the original uploaded PDF/JPG/PNG as a MIME attachment (`Content-Disposition: attachment`), with a safe invoice-based filename. The Buyer uses the mail app's **Download** or **Save attachment** control. The HTML and plain-text bodies include download instructions and sent invoice details.
- Invoice details include type, registered issuer, number, date, supplied billing name, total, VAT when supplied, issued-through source, invoicing method and sent time in Philippine time. TEST/DEMO and correction labels are preserved. Accepted order amounts are not changed.
- Queued delivery checks current Buyer ownership/access, private file ownership, CLEAN scan state, content type, byte length and both stored SHA-256 hashes. It attaches bytes rather than a public or expiring storage URL. Storage/integrity/provider failures use the existing bounded retry and sanitized delivery history. A revoked account cannot receive a queued attachment.
- Each correction's email resolves that exact immutable version, never whichever invoice was uploaded most recently. Email delivery does not count as the Buyer downloading the file in the app.
- Shared email cards use purpose-specific headings and actions. Portal actions resolve to the actual authorized resource page. Support email shows ticket reference/status and **View support request**, keeping private messages and support attachments inside the ticket.

## Files and contracts

- Domain: `InvoiceService`, `InvoiceCopyMailFactory`, `NotificationDelivery`, `NotificationPolicy`, `NotificationMailAction`.
- Mail: `InvoiceCopyMail`, invoice HTML/text views, shared base/action partial and support/order/finance/onboarding/inventory/compliance views.
- Tests: `PhaseThirteenDisputesTest`, `SupportRequestsTest`, `MailPresentationTest`.
- Workflow updates: System, Buyer and Vendor; Send's OpenAPI description documents attachment delivery and reauthorization. TypeScript and Dart clients were regenerated; no API request/response schema or migration changed.
- Existing providers, activation cutoffs, secrets, mandatory preferences, role permissions and financial calculations remain unchanged. No new configuration keys are required.

## Local verification on 2026-11-05

All API tests ran against the isolated `materyalph_invoice_workspace_test` Compose project, with fake/array mail and synthetic data. No external messages were sent.

| Check | Result |
| --- | --- |
| Final invoice acceptance tests: `php artisan test tests/Feature/Api/PhaseThirteenDisputesTest.php --filter=invoice --compact` | 5 passed, 341 assertions |
| Full dispute/invoice file plus notification inbox, realtime, message and OTP lifecycle tests | 44 passed, 1,155 assertions; final invoice checks rerun after download-copy additions |
| Mail presentation, support requests, Phase 15 notifications, outbox delivery, Gmail SMTP/API delivery and Gmail API transport tests | 98 passed, 441 assertions |
| Pint on 9 affected PHP files | Passed |
| PHPStan on 6 affected production PHP files, 512M | Passed, no errors |
| OpenAPI validation and disputes/notifications contract scripts | Passed; validator retains 8 unused-schema recommendations |
| Generated TypeScript build and Dart serializer build | Passed |
| Chromium render checks: invoice, support, long invoice at 700/375/320px | 9 passed; desktop/mobile screenshots visually inspected |
| Targeted Gitleaks scan and repository whitespace diff check | Passed, no leaks found |

The invoice tests exercise PDF, JPG and PNG MIME contents/filename/disposition, exact attachment bytes, totals/details, plain-text literal business names, duplicate Send/outbox processing, no-request sends, ownership, revocation, scan state, integrity failures/retries and immutable correction versions.

Synthetic review previews are in `.tmp/email-invoice-700.png`, `.tmp/email-invoice-320.png`, `.tmp/email-support-700.png` and `.tmp/email-support-375.png`. The repeatable local render scripts are `.tmp/render-invoice-emails.php` and `.tmp/check-invoice-emails.mjs`; these are ignored development artifacts.

## Manual acceptance still required

Use an explicitly controlled Buyer mailbox to send a new invoice, open the received email and download its attachment in the intended desktop/mobile mail apps. Confirm the filename, original file contents, invoice facts and formatting in Gmail/Outlook. Return the invoice and send a correction; confirm each email retains its own file/version. Native mailbox delivery and client-specific rendering have not been tested here. The full repository-wide API, portal and Flutter suites were not run for this server/email change.

Suggested commit: `feat(invoices): email downloadable sent invoice copies`
