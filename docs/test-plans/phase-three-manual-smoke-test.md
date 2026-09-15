# Phase 3 manual smoke test

Run this checklist in the isolated capstone/TEST environment. Use fictional records and test provider credentials only. Record `PASS` or `FAIL` and enough notes to reproduce any failure.

## Vendor Web

| Test / feature | Manual action | Expected result | PASS / FAIL | Notes |
|---|---|---|---|---|
| Authentication and entry | Sign in as an active Vendor Owner. | Sign-in lands on the Vendor Dashboard, the correct organization opens, and another organization's URL is unavailable. |  |  |
| CSRF request lifecycle | Sign in, open Dashboard, move between onboarding steps, save several drafts, and refresh without waiting between ordinary actions. | Normal navigation and GET loads do not request a new CSRF token; mutations reuse a valid token, no request loop occurs, and ordinary use does not produce HTTP 429. |  |  |
| Session refresh | Let the access session expire while the refresh session remains valid, then load two protected panels at nearly the same time. Repeat with an invalid refresh session and with a deliberately rate-limited refresh response. | One shared refresh request restores the valid session and each original request retries once. Invalid refresh returns to sign-in. Refresh HTTP 429 remains distinguishable from authentication expiry and never causes a refresh loop. |  |  |
| Limited Dashboard | Select **Finish Later** before activation. | Progress is saved and the limited Dashboard shows separate Store Verification, Store Setup, Store Activation, and Marketplace Discoverability states; activation-only management destinations remain unavailable. |  |  |
| Readiness | Review the onboarding checklist before completing setup. | Every item shows Requirement Level separately from Status; `NOT_APPLICABLE` appears only for a non-applicable conditionally required item, and Team Accounts is optional. |  |  |
| Business draft | Save partial business information, leave, and return. | The draft persists without being submitted. |  |  |
| Business validation | Submit incomplete and then complete business information, legal identity, Store Email/Phone, contacts, classification, address and map pin. | Inline validation identifies missing/invalid fields; a valid submission enters `PENDING_VERIFICATION`, shows confirmation and offers **Proceed to Store Setup**. |  |  |
| Business Type applicability | Exercise Sole Proprietorship, Partnership, Corporation, One Person Corporation (OPC), and Cooperative. | Legal-name fields, registration authority, required DTI/SEC/CDA evidence, Government ID applicability, and tax/verification requirements recalculate without changing the selected legal Business Type. |  |  |
| Business review transition | Open a returned or rejected business submission. | The status and reason are visible and an authorized correction creates the next review cycle. |  |  |
| Private documents | Upload the required DTI/SEC/CDA, LGU, BIR, and conditional regulatory evidence using fictional files for the selected Business Type. | Each file shows a private, versioned scan/review state; no permanent public URL appears. |  |  |
| Document replacement | Replace a returned or expiring document. | The new version becomes the review candidate and prior evidence/history remains visible where authorized. |  |  |
| Private download | Request and use an authorized download link, then retry it after expiry or loss of access. | Current authorization permits a short-lived download; expiry or revoked access is denied. |  |  |
| Tax draft | Save a TEST/demo tax-profile draft as an authorized Manager where applicable. | The draft is labeled TEST/demo and does not claim regulatory approval. |  |  |
| Owner tax attestation | Submit the current tax version as the Vendor Owner. | Owner attestation, version, evidence links, and pending-review state are recorded. |  |  |
| Tax history | Inspect prior tax versions and decisions after a correction. | Historical evidence and decisions remain immutable and visibly versioned. |  |  |
| Vendor Terms | Open Account and security → Agreements and review the current Terms. | The CAPSTONE/TEST label, title, version, full text, and required state are visible. |  |  |
| Privacy Notice | Review and acknowledge the current Privacy Notice. | The configured privacy contact and separate acknowledgment state are visible and persist after reload. |  |  |
| Commission Terms | Open the 2% commission step and accept it as Owner. | The exclusive-materials base, monthly Vendor-paid policy, version, TEST label, and acceptance are visible. |  |  |
| Agreement authority | Attempt commission acceptance as Store Manager. | The action is denied; Manager permissions remain unchanged. |  |  |
| Store profile | Save store name, public description, selected public contact, address, and seven-day hours. | Draft/profile values persist and readiness identifies any missing public field. |  |  |
| Public logo/banner | Upload logo and banner replacements. | Cloudinary handles public media; pending media does not replace the active approved asset. |  |  |
| Promotional media | Upload permitted Phase 3 promotional store media. | Only supported public Store Profile media is accepted; no Phase 4 product-media flow appears. |  |  |
| Store media controls | Preview one scan-cleared private candidate, then remove a fictional pending/rejected replacement. | Preview uses the authorized backend response; removal updates readiness and never exposes or deletes immutable review/audit history. |  |  |
| Media approval delivery | After Admin approval, open the public media route. | Only the current approved active asset is public; rejected, removed, or replaced assets are unavailable. |  |  |
| Fulfillment: pickup | Select Self-Pickup and save. | Pickup readiness completes when its Phase 3 fields are valid. |  |  |
| Fulfillment: delivery | Select Vendor Delivery and save vehicle type/subtype, count, capacity, cargo dimensions, heavy-vehicle classification, base fee, per-kilometer rate, and maximum distance. | Delivery Configuration becomes conditionally required and completes only when at least one valid vehicle/rate configuration is saved. |  |  |
| Fulfillment: both | Select Both and complete the delivery fields. | Self-Pickup and Vendor Delivery persist; the conditional delivery requirement cannot be bypassed. |  |  |
| Xendit TEST | Start the Xendit TEST connection as a recently authenticated Owner using Vendor fixtures for Sole Proprietorship, Partnership, Corporation, One Person Corporation (OPC), and Cooperative. | Each activation-seeking Vendor has mandatory xenPlatform onboarding; the UI says `Xendit TEST Connected` and keeps environment and provider status distinct. |  |  |
| Xendit recovery | Exercise the mocked/manual test reconciliation state offered by the environment. | The UI explains reconcile/retry; no blind duplicate create occurs and no API key is displayed. |  |  |
| Team invitation | Invite fictional staff into each fixed Phase 3 role. | Invitation status and fixed role are visible; no custom grant bypass appears. |  |  |
| Team invitation revocation | Revoke a pending ordinary-staff invitation as Owner and as a delegated Store Manager; also attempt a Store Manager invitation as the delegated Manager. | Permitted invitations are revoked and the Owner is notified; a delegated Manager cannot create, manage, or revoke a Store Manager invitation. |  |  |
| Manager delegation | Inspect a Store Manager and enable Manage Staff Accounts deliberately. | The toggle defaults off; delegated Manager actions remain within the approved limits. |  |  |
| Team suspension | Suspend or deactivate a fictional staff member and try the old session. | Access is revoked according to the workflow and the action is recorded. |  |  |
| Activation blocked | Attempt activation with at least one mandatory item incomplete or a stale agreement unaccepted. | The backend rejects activation and identifies blockers; client input cannot force `ACTIVE`. |  |  |
| Activation eligible | Complete all applicable mandatory Store Verification and Store Setup requirements with no product listing or inventory prerequisite. | Readiness reports eligible and Owner Store Activation succeeds; product publication and Marketplace Discoverability remain separate follow-up states. |  |  |
| Loading and empty states | Open each onboarding section with throttled responses and an empty applicable list. | Loading and empty states are understandable and controls do not jump or duplicate. |  |  |
| Errors and retry | Trigger validation and recoverable server/provider failures. | Safe error text, retry action, and preserved user input appear without secrets or stack traces. |  |  |
| Responsive and keyboard use | Check narrow and desktop widths; complete forms using the keyboard. | No obvious overflow occurs; labels, focus order, focus indicators, and actions remain usable. |  |  |

## Admin Web

| Test / feature | Manual action | Expected result | PASS / FAIL | Notes |
|---|---|---|---|---|
| Controlled Admin access | Create or renew a fictional Admin invitation with `php artisan materyalph:bootstrap-admin admin@example.test` in the isolated environment, accept it, then sign in as Vendor Verification Staff and as an unauthorized Admin role. | The command emits only a one-time invitation workflow and never seeds a hard-coded password. Authorized staff reach the queue; unauthorized roles cannot access verification evidence. |  |  |
| Admin session lifecycle | Navigate repeatedly among queue, Store Verification, Store Setup, Activation, and Account panels. | Protected GETs do not fetch CSRF tokens, valid expiry uses one refresh, and HTTP 429 is shown as rate limiting rather than forced sign-out. |  |  |
| Verification queue | Open the Vendor verification queue in populated and empty states. | Vendor, status, and next-review information are clear; empty/loading/error states are usable. |  |  |
| Vendor record | Open a Vendor record from the queue. | Business, documents, tax, media, Xendit TEST, and activation readiness are scoped to that Vendor. |  |  |
| Private evidence authorization | View a fictional business document, then try a copied link without authorization. | Authorized short-lived access succeeds; copied/expired/unauthorized access fails. |  |  |
| Document approval | Approve clean current evidence with verified dates/reference. | The approved decision, reviewer, dates, source, and current version are recorded. |  |  |
| Return for correction | Return current evidence with a reason. | The Vendor sees the actionable reason and can upload a new version. |  |  |
| Document rejection | Reject current evidence with a reason. | The immutable rejection remains in history and activation stays blocked as applicable. |  |  |
| Decision immutability | Try to change a prior review by revisiting the old version. | No edit/delete control alters the old decision; a correction requires a new version/review. |  |  |
| Tax review | Review a fictional Owner-attested tax version and its linked evidence. | TEST/sample and legal-effect labels are prominent; decision and history are versioned. |  |  |
| Public media review | Approve one logo/banner replacement and reject another. | The approved replacement becomes current safely; rejected media never becomes public. |  |  |
| Xendit status | Inspect payment-connection information. | `TEST`, local connection state, and provider status are distinct; no secret credential appears. |  |  |
| Readiness | Inspect the activation-readiness checklist before and after reviews. | Results match backend evidence: delivery configuration blocks activation only when Vendor Delivery or Both is selected; product listing/publication is not an activation blocker, while product compliance remains a listing/discoverability condition. |  |  |
| Restriction/restoration | Use only the Phase 3 restriction/approval controls exposed for the test scenario. | The documented reason/history appears and restoration occurs only after mandatory readiness returns. |  |  |
| Audit/history | Review Vendor status, evidence, tax, agreement, and activation history. | Actors, times, versions, sources, and prior immutable decisions are traceable. |  |  |
| Privacy boundary | Check public Store Profile and private verification screens side by side. | DTI/SEC/LGU/BIR/TIN, private contacts, payout data, and auth data never cross into public output. |  |  |

## Buyer Mobile regression

| Test / feature | Manual action | Expected result | PASS / FAIL | Notes |
|---|---|---|---|---|
| Launch | Launch the current development build on the intended test device. | The app starts without a crash or generated-client initialization error. |  |  |
| Buyer authentication | Sign in with a fictional Buyer and restore the session after relaunch. | Authentication and session behavior remain unchanged by Phase 3. |  |  |
| Main navigation | Visit each existing primary destination. | Navigation works without crashes, dead routes, or Phase 4 features being introduced. |  |  |
| Public Vendor information | Open any currently exposed public Vendor/store view. | Only approved public name, description, logo/banner, contacts, fulfillment indicators, ratings/badges, and applicable public data appear. |  |  |
| Private-data boundary | Inspect Vendor-facing data available in Buyer responses/screens. | No DTI/SEC/LGU/BIR/TIN evidence, private contacts, staff-private data, payout details, or authentication data appears. |  |  |
| Generated contracts | Exercise screens that deserialize account or Vendor Store data. | Nullable Phase 3 fields do not cause runtime or parsing errors. |  |  |
| Mobile presentation | Check normal and narrow layouts with text scaling. | Core Buyer content remains readable and usable without obvious overflow. |  |  |

## Provider, storage, and agreement setup

| Test / feature | Manual action | Expected result | PASS / FAIL | Notes |
|---|---|---|---|---|
| Agreement seed | Seed an isolated database and inspect current agreement metadata. | Terms v2, Privacy v2, Vendor Code v2, and Commission v1 are active CAPSTONE/TEST records with matching content hashes. |  |  |
| Privacy contact | Set `PRIVACY_CONTACT_EMAIL` to an approved test address and reload Privacy Notice. | The configured address replaces the placeholder without changing the stored version hash. |  |  |
| Private storage | Upload and download fictional evidence using configured S3/MinIO. | Private storage, scan state, checksum, authorization, expiry, and audit behavior work; no Cloudinary transfer occurs. |  |  |
| Public media provider | Upload fictional public Store Profile media with Cloudinary test configuration. | Backend credentials stay server-side and only approved active public media is delivered. |  |  |
| Provider failure recovery | Exercise supported test doubles or controlled provider-failure cases. | Xendit uncertainty requires reconciliation; Cloudinary uncertainty remains retryable until cleanup is confirmed. |  |  |
| Secret review | Inspect browser/mobile logs, network responses, and visible error text. | No API secret, Passport key, token, private provider payload, or private evidence URL is exposed. |  |  |
