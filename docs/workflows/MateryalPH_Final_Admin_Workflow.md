**Admin Flow**

---

### Admin Portal (Web Application using React.js)

MateryalPH provides a dedicated **web-based Admin Portal** developed using React.js. It is separate from the Buyer mobile application and Vendor Portal and serves as the platform's controlled operations, verification, compliance, moderation, dispute, account-management, monitoring, and audit interface.

The System Workflow is the authoritative source for shared security, state, scoring, payment, privacy, accessibility, audit, and integration rules. This Admin Workflow defines administrative review, oversight, and enforcement without creating conflicting business rules.

The Admin Portal does not provide public registration. A Buyer or Vendor account cannot obtain Admin access through a profile change or public application. Every Admin action is authorized by the Laravel backend and attributed to an individual Admin account.

---

**Approved capstone operating basis — 5 September 2026.** MateryalPH is an academic prototype, not an asserted BIR-registered operating business. All Xendit integrations use TEST credentials and test accounts. Every payment screen, financial report, certificate preview and billing statement carries **DEMO — No real funds or BIR filing**. A successful test webhook demonstrates provider integration; it does not prove real collection, statutory withholding, remittance to the BIR, or government approval. Physical-payment demonstrations record simulated cash handover to the Vendor. Seeded identities and tax documents are conspicuously fictional and must never be submitted to regulators or used to represent a real business as verified.

The approved commercial design uses a **2% Vendor-paid commission on completed materials value after discounts and excluding materials VAT**, billed monthly for Online, COD and In-Store orders. The fee is distinct from Buyer-paid processor charges and Vendor withholding. No subscription or listing charge applies. The System Workflow's controls `FIN-01` through `FIN-12` are authoritative for calculation and implementation; the other workflows apply them within their existing screens. The production withholding entity is **UNCONFIRMED**. Test scenarios may simulate either responsibility path, but no Admin toggle can establish a real legal allocation or enable live money movement.

### Admin Sign-in

Administrators sign in using an internally issued email/password account and mandatory authenticator-app TOTP. Email is used for invitation, recovery, and security notices; email OTP is not treated as strong MFA. Public Google sign-up and public Admin sign-up are unavailable.

The authentication service applies HTTPS, server-side validation, adaptive password hashing, account and role checks, CSRF protection, rate limiting, risk-based bot protection, short-lived access tokens, rotated refresh tokens, and session revocation. Five failed attempts within 15 minutes trigger temporary throttling and a security event. A successful password or factor recovery revokes existing sessions and notifies the account holder.

The Admin Portal uses `Secure`, `HttpOnly` cookies and must not store authentication tokens in browser local storage. Sensitive actions—including Admin-role changes, permanent bans, platform-setting changes, data exports, and security-factor recovery—require recent reauthentication.

---

### Admin Account Creation

The initial Super Admin is created through a protected deployment command or seed procedure available only to authorized system operators. The command must not contain a reusable default password. It creates a pending Admin account and sends a time-limited, single-use setup invitation to the authorized email.

After the initial Super Admin exists, later Admin Staff accounts are created through the Admin Portal by an authorized Super Admin. The invitation contains the intended role, expiry, inviter, and one-time acceptance credential. The invited user sets a password, verifies the email, enrolls TOTP, receives recovery codes, and accepts the applicable Admin policy before access is activated.

Invitation, acceptance, role assignment, role change, suspension, factor reset, reactivation, and deactivation are recorded in the security audit log. Deactivation revokes all active sessions but preserves historical attribution.

---

### Admin Dashboard

**Overview**

The Admin Dashboard is the platform operations center. It is accessible only to active Admin accounts and renders modules according to their assigned permissions. Counts are linked to filtered queues and must not expose information outside the Admin's scope.

**Dashboard Sections**

**1. Dashboard:** Active Tier 2 Vendors, active Buyers, order requests awaiting Vendor response, confirmed orders, pending business-document reviews, pending product-compliance reviews, open disputes, appeals, account flags, unresolved invoice requests, failed background jobs, and external-integration health.

**2. Marketplace Analytics:**

The dashboard provides an interactive Philippines map using versioned Philippine Standard Geographic Code identifiers and approved administrative-boundary data. Its hierarchy is `Philippines → Region → Province or Independent/Highly Urbanized City → City or Municipality`, so NCR, independent cities, and municipalities are not omitted. The current geographic-data version and last aggregation time are displayed.

- **Design and navigation.** The default choropleth shows regions. Selecting a region drills into its provinces and independent or highly urbanized cities; selecting a province shows its component cities and municipalities. Breadcrumbs, Back, Reset Map, search, and keyboard-operable geographic selection are available. A synchronized accessible table exposes the same places, metrics, sorting, and selection without requiring map interaction.
- **Global filtering.** Clicking a geography applies its PSGC code to the entire dashboard, including KPI cards, trends, queues, category demand, response performance, and exports. The selected geography is visible in a removable filter chip and URL state. Date range, procurement type, category, fulfillment method, payment method, and order state may be combined with it.
- **Supply and Buyer presence.** Vendor Count uses active Tier 2 storefronts assigned to their verified business-address point. Registered Buyer Count uses each Buyer's current verified primary/default location. Active Buyer demand is attributed separately to the order delivery/pickup reference or Project site so a Buyer with projects in different areas is not incorrectly treated as demand only at the profile address.
- **GMV and order volume.** Gross GMV is the sum of confirmed marketplace order value for Online, COD, and In-Store Payment, excluding the separately disclosed processing fee and before refunds. Net GMV subtracts cancelled and refunded commercial value. Order Volume counts confirmed Vendor child orders. The dashboard displays gross and net values as daily, weekly, or monthly time series and never substitutes a cumulative snapshot for a trend.
- **Fulfillment and case rates.** Fulfillment Rate equals eligible orders completed by the reporting cutoff divided by confirmed orders due for fulfillment in the period. Cancellation Rate equals confirmed orders finalized as cancelled divided by eligible confirmed orders. Dispute Rate equals eligible confirmed orders with at least one transaction dispute divided by eligible confirmed orders. Numerators, denominators, exclusions, and date basis are available in metric help text.
- **Vendor response performance.** Response time is measured from an inquiry, package request, order request, or counter-offer becoming available to the Vendor until the first qualifying human response or quotation publication. Automated acknowledgments and auto-accept do not count as human response. The dashboard shows arithmetic mean as requested, plus median and 90th percentile to reveal outliers.
- **Category and material demand.** A heatmap can be switched among confirmed order count, normalized quantity where units are comparable, and commercial value. Demand is attributed to the relevant order or Project site and may be filtered by controlled category or canonical material. It supports Vendor recruitment decisions but is not represented as an official government market statistic.
- **Meaningful active users.** Buyer and Vendor activity are tracked separately as unique daily, weekly, and monthly users. A Buyer is active after submitting an order, accepting or countering a quotation, or confirming/reporting fulfillment. A Vendor user is active after publishing or revising a quotation, manually confirming or revising an order, recording fulfillment, or performing an equivalent human operational action. App opens, page views, automated jobs, and auto-accept events alone do not qualify.
- **Privacy and quality.** Aggregate queries use authorized analytics views rather than exposing individual coordinates. Small groups are suppressed or generalized under the approved disclosure-control rule. Records with unresolved geography appear in a separate data-quality count. PSGC changes are imported through a versioned job; historical orders retain the code and boundary version used for reporting, with documented remapping for current-view aggregation.

- **Materials Analytics.** Within this geographic section, authorized users select Materials Analytics to see categorized material/comparable-variant averages, 7/30/90-day or custom-date trends, a daily graph/table, current eligible Vendor/listing counts and recorded sample counts. Apply the selected PSGC area, including Philippines-wide scope, rather than imposing a 50 km circle on national monitoring. Averages use only MAT-01–MAT-07 public Tier 2 listed prices, equal weight per Vendor, applicable included materials VAT and comparable units/specifications. Transaction/order-state/payment filters remain relevant to GMV and demand panels, but are marked not applicable to listed-price history; they must never silently filter price observations by sales.
- **Source review and data quality.** `analytics.view_aggregates` permits aggregates only. `materials_analytics.inspect_sources` separately permits inspection of underlying public listing identities, price/version, capture time and geography, with an audit reason. It does not reveal private stock, Buyer coordinates, tax evidence or private quotations. Existing export permission is additionally required for export. A one-Vendor public-price average is labeled Limited Local Data; trend needs two Vendors at both exact endpoints. Existing small-cell protections for Buyer/demand personal data remain separate and unchanged. Show changed participation, missing-day gaps, source mapping exclusions, snapshot delay and separate current/history timestamps. Corrections append a reviewed replacement run and retain original evidence. Do not imply that platform coverage represents every Philippine supplier or an official government price index.
- **Controls and demonstration.** Super Admin receives source-inspection permission; an approved Custom Role may receive it independently of finance permissions. Use the same list/detail/chart components and calculation service as the other clients with an Admin-specific authorized response. TEST runs and exports show DEMO — Simulated Marketplace Data and never mix into live marketplace reporting. Snapshot health appears in Integration and Job Health. MAT-07 governs market-analysis tests; FIN-12 independently governs tax/fee demonstration.

Map color never carries meaning alone. Every scale has a legend, units, exact values on focus or selection, sufficient contrast, pattern or text alternatives where required, and a non-map table. Trend charts provide accessible summaries and downloadable authorized data.

**3. Vendor Management:**

- Separate Store Verification and Store Setup views for every Vendor, with independent progress, requirement-level, status, and activation-readiness information.
- Pending Store Verification queue with document-by-document manual review.
- Approved Vendor list with separate Store Activation and Marketplace Discoverability status.
- Activation-readiness checklist showing every mandatory requirement.
- Return for Correction, Approve, Reject, Temporarily Restrict, Suspend, Reactivate, and Permanently Ban actions where permitted.
- Mandatory reason for rejection, restriction, suspension, ban, or reversal.
- Xendit sub-account onboarding status and safe retry of an approved failed onboarding job; no secret keys or payout credentials are displayed.
- Document expiration monitoring based on the Admin-verified date.

The Vendor review workspace keeps the following concepts separate:

| **Workstream** | **Purpose** | **Normal successful status** | **Admin review** |
| --- | --- | --- | --- |
| Store Verification | Legal identity and identity evidence, Business Information, contacts, registered address, Supplier Type/niches, business registration, permits, tax information, and other regulatory evidence | `APPROVED` for each applicable mandatory Admin-reviewed requirement | Required; uploading information or a document never verifies it automatically |
| Store Setup | Public Store Profile, procurement capability, fulfillment and conditional delivery configuration, payment configuration, and other operational settings | `COMPLETED` for each applicable mandatory non-reviewed requirement | Not a substitute for Store Verification approval |

Requirement Level is `REQUIRED`, `OPTIONAL`, or `CONDITIONALLY_REQUIRED`. Requirement Status is `NOT_STARTED`, `IN_PROGRESS`, `SUBMITTED`, `PENDING_VERIFICATION`, `APPROVED`, `COMPLETED`, `CHANGES_REQUIRED`, `REJECTED`, `EXPIRED`, or `NOT_APPLICABLE`. These are separate concepts: a requirement level is never a status. `NOT_APPLICABLE` is allowed only for a conditionally required requirement whose documented condition does not apply; it cannot bypass an incomplete required item. Document metadata may separately show **Expiration Date: Not Applicable** when a document legitimately has no expiration date.

The selected Business Type is exactly one of **Sole Proprietorship**, **Partnership**, **Corporation**, **One Person Corporation (OPC)**, or **Cooperative**. It determines the applicable legal-name fields, registration authority, primary registration evidence, identity evidence, and tax or verification requirements: DTI business-name registration for Sole Proprietorship, SEC registration for Partnership, Corporation, and One Person Corporation (OPC), and CDA registration for Cooperative, together with applicable LGU permits, BIR Certificate of Registration, TIN, VAT or Non-VAT classification, and other regulatory documents. The queue displays only applicable requirements and records the applicability reason.

After Store Verification is submitted, the Vendor sees a confirmation and **Proceed to Store Setup** action. The Vendor may continue Store Setup while verification is `PENDING_VERIFICATION` and may use **Finish Later** to save progress and return to a limited Dashboard. Setup completion never changes a verification item to `APPROVED`. Team Accounts are optional, staff use individual fixed-role invitations, and staff neither repeat Vendor Onboarding nor bypass Store Activation.

**4. Buyer Management:** Buyer account status, dispute history, confirmed self-pickup no-show patterns, abuse reports, appeals, temporary restrictions, suspension, reactivation, and permanent-ban actions. No fixed number of reports or no-shows causes automatic suspension without review.

**5. Taxonomy Management:** Authorized users manage canonical material entries, aliases, platform codes, compatible units, structured technical attributes, category tags, and regulated-product mappings. A pending taxonomy suggestion must not block a Vendor from saving a draft listing. Changes are versioned and must not rewrite historical order or compliance snapshots.

**6. Product Compliance Queue:** Displays `PENDING_ADMIN_REVIEW` submissions, the Vendor-entered information, OCR or QR output, physical-marking evidence, current official reference used, and previous decisions. Authorized Product Compliance Staff may Approve, Return for Correction, or Reject with a reason. The system records reviewer, decision, timestamp, source version, and remarks. It does not label an unmatched entry counterfeit without an authorized determination.

**7. Dispute and Appeal Queue:** Displays Case ID, order, parties, issue type, evidence, current handler, deadline countdowns, status, requested remedy, refund capability, and prior decisions. A decision creates the applicable case, order, score-event, and dispute-conclusion refund instruction; it does not perform an undocumented escrow action.

**8. Flag, Restriction, and Suspension Management:** Displays system alerts, user reports, prior incidents, evidence, active sanctions, and expiration. Admins may impose or lift a permitted restriction with a mandatory reason. Existing confirmed orders receive an explicit continuation, monitored-fulfillment, cancellation, replacement, or refund plan.

**9. Score and Badge Monitoring:** Displays Vendor VCS, MQS, OHS, VPS, CRR, FRR, sample size, metric window, badge eligibility, and source events. Admins may investigate incorrect or fraudulent source data but cannot manually assign a performance badge or arbitrary score. Confirmed corrections create a reversible adjustment event and audit record.

**10. Transaction Log:** Read-only records of Xendit payment requests, verified payment events, Buyer processing fees, Cancellation Refunds, Dispute-Conclusion Refunds, reconciled compensating refunds, COD, and In-Store Payment. Filters include Vendor, Buyer, order, trigger, Case ID, channel, date, amount, payment state, and refund state. Admins cannot view secret credentials, change refund destinations, withdraw balances, or manually disburse funds.

Within this existing section, add authorized tabs for **Remittance assessments**, **Reconciliation exceptions**, **Commission statements**, **Tax adjustments**, and **Tax report packages**. Each has the same filterable TEST origin, Vendor/taxpayer, order/payment/statement, period, status and audit references under FIN-10. Read-only logs stay immutable; separately permissioned review/approval commands append new events rather than editing the log. The default dashboard states **DEMO_PLATFORM_WITHHOLDER — simulation**, while actual production responsibility remains UNCONFIRMED.

Finance KPIs show assessed CWT, simulated/provider-reported deductions, unreconciled differences, pending certificates, earned fee value, fee VAT, issued/collected commission bills, overdue receivables and refundable fee credits. These do not change GMV. A CWT amount is never counted as platform revenue. A collected fee is not counted as revenue again after its EARNED posting.

**11. Invoice Request Log:** Read-only tracking of Buyer invoice requests and Vendor-uploaded files, including order, request date, service target, upload date, invoice reference, uploader, correction state, and download event. MateryalPH documents are clearly distinguished from the Vendor's BIR-compliant invoice. Admins do not create or calculate a Vendor tax invoice.

FIN-09 extends this log to invoices already issued without Buyer requests, mismatched invoice totals, taxpayer electronic-invoicing coverage/deadline, platform fee bills and sample/real document provenance. A PDF attachment is not a declaration of electronic-invoicing compliance. No Admin may mark a SAMPLE document as an official invoice or a generic report export as an accepted BIR filing.

**12. Platform Settings:** Authorized Super Admins manage non-secret operational defaults, including SRS and FMS default weights, radius values, Vendor-response window, 24-hour Pending Payment window, quotation deadline limits, reminder offsets, dispute deadlines, rating windows, badge thresholds, budget warning threshold, invoice-request service target, analytics disclosure thresholds, upload limits, and feature flags. SRS and FMS weight groups must total 100%. VPS remains fixed at 50% VCS and 50% OHS. Buyer preference records remain in `buyer_ranking_preferences` and are never overwritten by a platform-default update. Admins may not impose a platform-wide numeric NRPC cap; oversight is through disclosure, evidence, flag, dispute, and enforcement rules.

Financial settings use versioned records rather than free-text formulas: 2% commission, FIN-02 rounding, billing schedule, effective tax rules/ATCs, calendar source, evidence requirements and demo scenario. Changing a statutory rate requires a cited effective legal basis and independent approval; it is not a commercial preference. No frontend control enables LIVE while responsibility, registration, fee treatment or refund funding is unconfirmed. Accepted order snapshots retain their fee policy; posted tax retains its original rule version. Tax-profile corrections and financial adjustments are separate commands with recorded reasons.

Xendit API keys, webhook verification tokens, Google API keys, email credentials, encryption keys, and other secrets are excluded from Platform Settings. The portal may display connection health and masked environment labels only.

**13. Audit Log:** Searchable, append-only records filterable by actor, role, action, resource, organization, result, date, correlation identifier, and reason. It includes quotation versions, auto-accept policies and decisions, inventory reservations, NRPC acceptance and flags, cancellations, and both refund triggers. Access to sensitive audit details is itself logged. No Admin may edit or delete an audit entry through the portal.

**14. Product Review Moderation Queue:** Displays the review, media, flag reason, verified-purchase reference, related dispute, prior moderation, and author display rules. Admin may Dismiss the Flag, Request Correction, Hide Pending Review, or Remove for a documented guideline violation. The original content and decision history remain preserved for audit. A Vendor cannot remove a review unilaterally.

**15. Budget Override Audit Log:** Read-only view of Buyer budget overrides, including project, work package, prior budget, order amount, overage, written reason, actor, and timestamp. Overrides are Buyer decisions and do not require Admin approval unless a separate fraud or account case exists.

**16. Privacy Request Management:** Tracks verified requests for access, correction, objection, deletion, restriction, portability where applicable, or another lawful privacy action. Each request records identity verification, scope, handler, legal or retention exception, response, completion date, and audit trail. Admins see only the personal information necessary for the assigned request.

**17. Integration and Job Health:** Displays safe operational status for Xendit, Google services, email, file storage, Laravel Reverb, queues, scheduled tasks, analytics aggregation, PSGC import, and OCR. It supports authorized retries of idempotent jobs and shows correlation identifiers without exposing secrets or sensitive payloads.

---

### Admin Account and Staff Management

The Admin Portal uses predefined roles with least privilege:

| **Role** | **Primary scope** |
| --- | --- |
| Super Admin | Admin accounts, non-secret platform settings, full authorized oversight, and final privileged account actions |
| Vendor Verification Staff | Vendor business information, registration documents, activation readiness, and document expiry |
| Product Compliance Staff | DTI-BPS regulated-product mapping and PS/ICC submission review |
| Order and Dispute Staff | Order, quotation, auto-accept, NRPC and cancellation investigation; disputes, remedies, appeals, and refund monitoring |
| User Management Staff | Buyer and Vendor account review, warnings, restrictions, suspension, reactivation, and abuse cases |
| Support Staff | User-support cases, safe account guidance, and escalation without enforcement or financial authority |

Custom Admin Roles are optional. If enabled, they use named, reusable permission sets configured only by the Super Admin. A Custom Role cannot grant Super Admin assignment, secret access, audit deletion, payout control, or permissions not held by the assigning administrator.

Every Admin account receives only one role at a time. Role changes are versioned so historical actions retain the role held when the action occurred. Permissions are enforced by backend policies on every request and tested through authorization tests. Support Staff cannot acquire enforcement authority merely by being assigned a case.

Geographic aggregate analytics require the separate `analytics.view_aggregates` permission. It is granted to Super Admin and may be assigned through an approved Custom Role. Row-level personal records, exact Buyer coordinates, bulk export, and sensitive evidence require separate permissions; access to the aggregate map never implies access to them.

Finance permissions follow FIN-10. Super Admin may view/review tax, approve statements, export reports and record externally evidenced outcomes, but the same user cannot prepare and approve an adjustment, tax override or filing package. Use two named Super Admin test accounts for that demonstration. Vendor Verification Staff may review registration/declaration evidence within assigned scope; they cannot authorize a new statutory rate or mark a tax return filed. Order and Dispute Staff may decide an order remedy and view its refund amounts without receiving full tax-document or filing authority. All other roles are denied finance exports unless explicitly assigned the approved permission set.

An Admin cannot review their own access change, recover their own TOTP through an administrative bypass, or modify records outside the assigned scope. Production database access, deployment commands, and environment secrets remain outside the normal Admin Portal.

---

### Admin Activity Attribution

Administrative attribution records the actual Admin user, role at the time, action, affected record, previous and new state, timestamp, result, reason, evidence or source reference, and correlation identifier.

- Vendor Verification Staff are attributed to business-document and activation reviews.
- Product Compliance Staff are attributed to PS/ICC and regulated-listing decisions.
- Order and Dispute Staff are attributed to investigations, decisions, remedies, clarification requests, and appeals.
- User Management Staff are attributed to warnings, restrictions, suspensions, reactivations, bans, and account-review decisions.
- Support Staff are attributed to support responses and escalations but not to a later enforcement decision made by another Admin.
- Super Admin actions remain individually attributed and are never recorded only as “system.”

When a case is transferred, the system records the former handler, new handler, transfer reason, and timestamp without rewriting earlier activity. Automated actions identify the responsible system job and triggering rule. A later Admin review remains a separate event.

---

### Vendor Verification and Activation Workflow

1. After Vendor Account Creation, Account / Email Verification, and Required Agreement Acceptance, the system makes the Vendor Portal Account active. The newly created Owner enters Welcome; Continue opens Vendor Onboarding, with separate Store Verification and Store Setup workstreams. Later sign-ins open the state-appropriate Dashboard. Staff go directly to their role-aware Dashboard and never repeat onboarding.
2. The Vendor submits applicable Store Verification information and documents. The system sets Store Verification to `PENDING_VERIFICATION`, records the submission, displays the review confirmation, and provides **Proceed to Store Setup**. Store Setup may proceed while Admin review is pending, and may also be drafted through Continue later before Verification submission. Neither route skips required submission or review. A Vendor may select **Finish Later** and return to the limited Dashboard.
3. Before queueing review, the system validates completeness, requirement level and applicability, file requirements, dependencies, supported document metadata, and malware/file-safety status. A conditionally required item is `NOT_APPLICABLE` only when its documented condition does not apply; required or optional levels cannot be used as statuses.
4. Vendor Verification Staff manually compare the entered business information with the selected Business Type and applicable DTI, SEC, CDA, LGU, BIR, TIN, permit, license, identity, and other regulatory evidence. Business Type changes, legal-business changes, tax changes, address changes, and replacement evidence trigger re-evaluation and reverification where applicable.
5. For each document, the Admin records the document number, issue date, expiration date or `NOT_APPLICABLE`, source, remarks, reviewer, timestamp, decision, reason, and audit reference. An expiration date is not the same as the onboarding status `NOT_APPLICABLE`; rejected, expired, or replaced evidence remains retained and requires correction or a new review where applicable.
6. **Approve** satisfies an applicable Admin-reviewed requirement at `APPROVED`. **Return for Correction** sets `CHANGES_REQUIRED` and requests a replacement, correction, or clarification. **Reject** sets `REJECTED` when the evidence does not satisfy the requirement. Every action requires a clear reason and is audit-logged.
7. The system recalculates the two workstreams and Store Activation readiness after every submission, review, correction, expiry, and setup change. Store Activation requires all applicable mandatory Store Verification requirements to be `APPROVED`, all mandatory Store Setup requirements to be `COMPLETED`, required delivery configuration when Vendor Delivery or Both is selected, mandatory Xendit xenPlatform sub-account onboarding for every Vendor seeking activation and marketplace participation, accepted Commission Terms including the approved 2% Vendor-paid FIN-03 commission, no blocking `PENDING_VERIFICATION` or `CHANGES_REQUIRED` item, no mandatory `REJECTED` or `EXPIRED` item, and no suspension or administrative hold.
8. Store Activation does not require a publishable product listing, inventory, or product-level compliance submission. Marketplace Discoverability is evaluated separately after activation and requires an eligible publishable listing, available and non-stale inventory, applicable product compliance, serviceability, and no discovery restriction. Product PS Mark, ICC Sticker, and other applicable compliance requirements continue to control publication of regulated listings.
9. Store Activation, rejection, later restriction, expiration, suspension, administrative hold, and restoration are audit-logged and notified to the Vendor. Team Accounts remain optional; invited staff use individual fixed-role accounts, never receive Owner credentials, do not repeat Vendor Onboarding, and cannot bypass Store Activation.

An Admin cannot override a missing mandatory requirement by editing the frontend. A permitted exceptional override, if introduced later, requires a dedicated policy, reason, authorization, and audit event.

For this capstone the activation checklist distinguishes SAMPLE tax documents and Xendit TEST capability from real BIR registration/KYC. Apply FIN-04 to the effective profile and route unavailable evidence to the correct outcome: missing COR blocks activation or live-selling readiness as applicable; the capstone itself does not claim live selling. An absent relief declaration means standard withholding rather than invented relief. Registration documents without legal expiry use `NOT_APPLICABLE`; declaration periods have their own validity rules. Show the fee Terms version and commission basis on activation review. No sample approval can be reused for a future live account.

The Tax Profile panel displays legal/trade identity, VAT status, tax year, prior-year position, declaration year and receipt, outside-platform disclosure scope, current local total, threshold-breach flag and withholding reason. Review changes create new versions. The preview tests their effect on future assessments only; disputed historical treatment opens an adjustment. Test scenarios cover both VAT and non-VAT Vendors, validated relief, missing declarations and thresholds without making an assertion about MateryalPH's own registration.

The Vendor Tax Profile is the single legal-tax source for the Vendor. Store Verification collects and versions it once; Payment Configuration references the effective or approved profile and must not collect duplicate tax-profile information. Tax evidence, withholding assignments, commission records, and financial history remain separate linked records under FIN-01 through FIN-12.

---

**Combined Business Information review and separate evidence decisions.** Use **Admin Portal → Vendor Management → Vendor Verification**. At desktop width, organize the existing case page into three compact panels: requirements and status selection on the left; the submitted information in clearly separated sections in the middle; Record Decision and Activation Restrictions stacked on the right. Maintain the existing navigation sidebar. On smaller screens stack these regions in reading order with labeled navigation and visible focus. Do not compress text or document previews until unreadable.

The information-only Business Information fields may be reviewed as one coherent information group. Supporting documents retain independent requirement IDs, versions and decisions. Selecting **Legal Identity** automatically loads its associated government ID front and applicable back preview into the same review context; it does not automatically approve that ID. The Record Decision area shows the precise selected group/evidence, declared values, previous verified values, file versions and preview. Approving information alone never marks every document approved. A batch decision, if offered, must list each included requirement and store a decision for each current version; an unselected or stale item remains unchanged.

**Legal structure and authority review.** Confirm the exact Business Type, Individual Registered Name where applicable, Company Registered Name where applicable and separate Public Store Name. Apply DTI evidence to Sole Proprietorship, SEC to Partnership/Corporation/OPC and CDA to Cooperative. Review applicable LGU and BIR records independently. For a non-individual entity, compare representative name, position, contacts, relationship, organization and authority scope with accepted records. An existing approved record may establish authority without a duplicate file; record its reference and the policy basis. Otherwise request the applicable Secretary's Certificate, Board/Partnership/Cooperative Resolution, SPA or equivalent approved evidence, not all document types.

Vendor Owner account role, business contact, employee role and legal signatory are different concepts. An Owner must satisfy the applicable authority check before an organization-binding commission/tax/payment attestation is effective. Staff onboarding assistance never establishes signatory authority. A representative change opens a new version/review and preserves the former effective period and previously signed agreements.

**Contacts, address and classification.** Review the effective verified Store Email, while keeping a pending email-change challenge separate; a failed challenge never changes the effective contact. Exactly one Primary Business Contact remains identified. The Vendor map confirms a structured Philippine address and stored coordinates; raw coordinates are hidden in Vendor onboarding but may appear to an authorized reviewer where needed. A changed approved address opens the affected review and, on effectiveness, updates discovery/analytics scope. Custom Other niches are repeatable labels, not new taxonomy entries or automatic reasons for rejection. Reject unsupported vehicle/equipment rental categories without rejecting permitted tools or equipment sold as products.

**Document inspection and OCR.** Treat OCR as a suggestion with provenance and confidence, not verified truth. Keep extracted, Vendor-declared and Admin-verified metadata separate. The reviewer may correct document number, issue date, expiry and remarks. Expiration has distinct states: unverified, no expiration, verified date and expired. Reject an expiry earlier than issue. Do not assign a fabricated annual expiry to BIR COR or another non-expiring document. View files only after the applicable safety checks; log access and use private short-lived links. A pending scan cannot satisfy an evidence requirement. Provide usable front/back image zoom or PDF viewing without exporting all private files into the public page payload.

Each Approve, Return for Correction or Reject decision records actor, assigned review scope, organization, requirement, submission version, document version where applicable, decision, reason, verified metadata, timestamp and audit reference. Refuse a stale decision with a reload notice. Resubmission replaces only the affected version and does not reset unrelated approvals. Preserve old files and remarks according to retention/hold rules; rejected evidence is not silently deleted.

**Tax declaration review.** Review BIR-received declaration evidence, taxable/effective period and threshold facts through the existing FIN controls. Yes is only an intention to submit; it does not grant relief. No or missing optional relief evidence applies standard treatment when required and does not itself block an otherwise eligible store. Missing mandatory COR/TIN evidence remains a blocker. The authoritative configured rate remains 0.5% of qualifying gross remittance under FIN-01; do not apply both the historic half-base expression and another halving. Separate declared VAT status from the reviewed effective classification and version corrections rather than rewriting financial history.

**Operational checklist on the review case.** Show Public Store Profile, Fulfillment Configuration, conditional Delivery Configuration, Payment Configuration and Store Operation. Public Store Profile requires the saved valid Logo and Banner plus all required profile fields; no Store Media row is created. Team Accounts are optional and absent from the completion checklist. S6 reviews the current saved configuration. Removing either required image changes a formerly completed profile to In Progress automatically; Admin cannot override a missing image by selecting Approve.

Check the seven-day explicit Open/Closed schedule and valid same-day times; date overrides take precedence only on their date. The schedule is public operational information and does not alter legal verification. For delivery, inspect complete enabled vehicles and category-specific capacities, including mixer m³ rather than conventional cargo dimensions. Self-Pickup only legitimately makes Delivery Configuration Not Applicable; enabling delivery reopens its applicability. Optional team creation or absence of products is never an activation blocker.

**Provider connection oversight.** View backend association, API version, environment, safe provider status, last reconciliation, capability readiness and error reference. The Owner initiates Connect Xendit; Admin does not paste an ID or mark a connection successful manually. `CONNECTED_TEST` is technical association only, never live KYC or tax approval. An unresolved attempt, provider outage or missing required payment/refund capability remains pending/blocked. Preserve the actual Vendor Business Type separately from any TEST placeholder entity sent to Xendit. The legacy-v2/new-v3 compatibility rule is defined in the Technical System Design.

**Activation decision and later changes.** Re-evaluate current versions transactionally: account/agreement eligibility, applicable authority and all mandatory approved Verification requirements, complete profile/media, fulfillment/delivery, TEST payment readiness, required hours and S6 completion, effective tax profile and no restriction. Persist the evaluated revision and result. If verification is pending, allow other setup work but keep marketplace operations limited. On later expiration, revocation or missing required data, create a reasoned restriction under the applicable rule; preserve access to existing fulfillment, disputes and refunds. A valid marketing/schedule change does not reset all business approvals. An active store with no eligible available listings remains outside offering-Vendor discovery and counts until listing gates pass.

**Staff and privacy oversight.** Support the fixed Owner, Store Manager, Store Staff, Customer Service Staff, Inventory Staff and Fulfillment Staff scopes. Store Manager staff-management delegation defaults off and covers only non-manager staff; the dispute-handling setting defaults on for Store Staff and Customer Service Staff. Protected Earnings/Transaction History remain Owner-only. Materials Analytics remains Owner/Manager-only under MAT rules. The Admin's ability to review a staff-action audit does not grant the employee more access. Staff names/avatars/roles may be public in authorized communication; their private contact/identity/authority files are not.

Notify the Owner of meaningful review outcomes, corrections, expiry/restrictions and activation results with specific continuation links. Notifications exclude full TIN, private documents and secret provider payloads. A closed store-hours label is not a suspended-store label and must not trigger a compliance enforcement event by itself.

---

### Product PS/ICC Compliance Review Workflow

1. A Vendor Owner, Store Manager, Store Staff, or Inventory Staff submits evidence through Photo/OCR, QR, or Manual Entry with mandatory marking evidence.
2. The system performs technical validation and an official-record comparison where a current source is available.
3. A confident valid match may become `VERIFIED` according to the approved rule. An uncertain, unavailable, or unmatched record becomes `PENDING_ADMIN_REVIEW` rather than automatically counterfeit.
4. Product Compliance Staff review the material category, required marking, entered identifier, manufacturer or importer, evidence quality, current DTI-BPS reference, and previous submissions.
5. The Admin selects Approve, Return for Correction, or Reject and supplies remarks. The system records the source and time of review.
6. Approval permits listing publication if all other listing fields and discovery conditions are complete. Return or rejection prevents the affected listing from publication or marketplace discoverability until corrected; it does not change the separate Store Activation state.
7. A later compliance-sensitive product edit removes the public verified state and opens reverification.

The Admin interface links to current official DTI-BPS references. MateryalPH review supports marketplace control but is not described as a government certification or laboratory test.

---

### Order, Quotation, Auto-Accept, and NRPC Oversight

Authorized Order and Dispute Staff may inspect the records necessary to investigate an order or flag without altering the Vendor's ordinary commercial configuration. The oversight view links the original Buyer request, locked Work Package where applicable, Vendor-editable duplicate, every quotation version, plain-language and field-level changes, deadlines, counter-offers, soft holds, acceptance-time inventory result, hard reservations, payment, fulfillment, cancellation, and refund history.

Auto-accept monitoring shows Vendor, SKU or variant, policy version, allotment and safeguards at the time, automated eligibility checks, transaction result, reservation movement, payment expiry, pause reason, and responsible configuration actor. Admins cannot manually force an order through a failed stock check or resume a Vendor's paused auto-accept configuration. Confirmed abuse, manipulation, or unsafe configuration is handled through a documented restriction or enforcement case.

An NRPC flag shows the Vendor-entered amount, reason, affected lines, Terms version, Buyer acceptance, separate Buyer objection, preparation evidence, order state, and cancellation cause. There is no platform-wide numeric cap. The Admin evaluates disclosure, actual preparation, proportionality, evidence, Vendor fault, product conformity, and applicable law. A decision may uphold, reduce, remove, or refund the NRPC through the appropriate case remedy. The Admin never edits the historical accepted amount; a modification creates a compensating decision and, when required, a linked refund.

---

### Dispute Resolution and Report Workflow

The process begins when an eligible Buyer or Vendor files a report connected to an order. A transaction dispute is eligible from `PROCESSING` onward. A post-completion return or dispute must be filed within seven calendar days after `COMPLETED`, subject to any non-waivable legal right. Safety, fraud, privacy, and account-abuse reports use their applicable reporting channel and are not rejected solely because the transaction window ended. Buyer issue types may include wrong item, defect, incomplete delivery, late or missing fulfillment, misleading listing, payment, invoice, or another supported transaction issue. Vendor issue types may include non-payment for a physical-payment order, confirmed pickup no-show, abusive communication, false evidence, or inaccessible delivery site.

The filing party completes the structured Refund/Dispute Request Form, selects an issue type, states the requested remedy, enters a requested amount where partial, and attaches available photos, video, order data, message reference, proof, invoice, or other evidence. The original masked payment method may be displayed for information, but the form never collects a different refund destination. The system creates a unique Case ID, timestamps the submission, preserves the original evidence, sets the dispute state, and notifies the other party. Filing alone does not create a refund.

**Case Statuses**

| **Status** | **Meaning** |
| --- | --- |
| `OPEN_AWAITING_RESPONSE` | Other party has 48 calendar hours to respond |
| `MUTUAL_RESOLUTION` | Both parties have 72 calendar hours to reach and confirm an agreement |
| `ESCALATED_ADMIN_REVIEW` | No response, no agreement, or a direct safety/compliance escalation requires Admin review |
| `AWAITING_CLARIFICATION` | Requested party has 24 calendar hours to provide additional evidence |
| `DECIDED` | Admin decision issued and remedy execution is being tracked |
| `APPEAL_OPEN` | One timely appeal with new relevant evidence is under review |
| `RESOLVED` | Decision and required remedy are complete |
| `CLOSED_INCONCLUSIVE` | Evidence is insufficient for a fault determination |

All deadlines use Asia/Manila time. If no response is received within 48 hours, the case escalates automatically. When a response is received, the parties receive 72 hours for mutual resolution. A confirmed agreement is recorded with both parties' acceptance. If the case remains unresolved, it enters Admin review.

The assigned Order and Dispute Staff reviews the order snapshots, payment events, inventory and fulfillment history, messages, evidence, account history relevant to the case, and applicable policies. If additional information is needed, the Admin issues a structured clarification request with a 24-hour deadline. Failure to respond does not automatically prove fault; the Admin decides using the available evidence and records the limitation.

**Permitted Outcomes**

- Dismissed.
- Replacement.
- Full Refund.
- Partial Refund.
- Warning.
- Score Adjustment through the applicable verified metric event.
- Temporary Restriction.
- Suspension.
- Permanent Ban.
- Inconclusive with monitoring where justified.

A score change cannot be an arbitrary number. The decision records the confirmed event—such as Vendor-caused non-fulfillment, validated defect return, or confirmed Buyer no-show—and the scoring service recalculates the applicable metric.

When a concluded dispute awards an online full or partial refund, the backend creates the idempotent **Dispute-Conclusion Refund** for the relevant original payment and Vendor sub-account and tracks authoritative status. This trigger is separate from an automatic Cancellation Refund. The Admin does not receive, hold, withdraw, redirect, or manually disburse funds. If the selected channel lacks a native refund, the documented contractually approved fallback is tracked as part of the remedy. A case is not marked Resolved until the required replacement, refund, or other action reaches its terminal state.

MateryalPH applies no standard cancellation fee. NRPC is a Vendor-determined portion of the existing order value and has no platform-wide numeric cap. It requires actual irreversible preparation, prior disclosure, explicit Buyer acceptance, and evidence when retained. It is forfeited on Vendor cancellation and cannot reduce a remedy for Vendor fault or defective, incorrect, unsafe, misrepresented, or nonconforming goods.

Either party may file one appeal within five business days only when new relevant evidence is provided or a material process error is identified. The appeal identifies the original decision and does not erase it. The appeal reviewer records whether the decision is Affirmed, Modified, or Reversed and the corresponding remedy changes.

Repeated behavior may justify a stronger action, but the Admin considers severity, evidence, proportionality, prior warnings, impact, and existing orders. A first incident does not always require only a warning, and a fixed number of flags does not automatically require a ban. Every enforcement action has a reason, effective time, scope, duration where temporary, notification record, and restoration condition.

---

### Payment and Refund Oversight

The Admin Portal is read-only for money movement. It displays payment and refund status needed for reconciliation and dispute review. Xendit keys, Vendor payout credentials, balances, and withdrawal controls are not available.

Payment success is based on a verified Xendit webhook or authoritative reconciliation, never solely on a Buyer redirect. Duplicate events are idempotent. A failed or expired payment with no captured funds has no refund. If authoritative reconciliation proves that funds were captured after an application failure, the system creates a compensating refund and alerts operations.

Refunds use separate triggers and records:

- **Cancellation Refund:** Automatically initiated when cancellation of an already-paid order becomes final. The calculation records cancellation cause, NRPC treatment, refundable amount, and responsible actor. Vendor cancellation refunds all Buyer-paid order amounts and forfeits NRPC.
- **Dispute-Conclusion Refund:** Automatically initiated only when a concluded dispute decision awards a full or partial refund. It stores the Case ID and decision version.

Each online refund record contains trigger, order, Case ID when applicable, Vendor sub-account, original payment request, original masked method, amount, supported-channel capability, Xendit reference, idempotency key, initiator or system rule, timestamps, and state. Online refunds return to the original payment method. Physical reimbursement records use their original cash collection and separate evidence states under FIN-07. `REFUND_PENDING` means the request is still being processed; even a successful provider event does not justify claiming that funds already appear in the Buyer's account. Failed refunds enter an exception queue without duplicating the request.

The Buyer-facing Payment Processing Fee, Vendor CWT and platform commission are stored separately. Commission follows FIN-03: 2% of completed materials value after discounts and excluding materials VAT, billed monthly for all payment methods. No commission split is made from Buyer payments in this capstone release. Any live processor-fee pass-through requires validation of the applicable channel/provider agreement and law.

Apply FIN-01–FIN-12 within Payment and Refund Oversight. The ordered finance process is:

1. Open a remittance group and verify environment, original successful collections, Vendor identity, assigned withholding scenario/entity and tax-profile version. Do not assess a mere withdrawal or direct Vendor cash receipt as a new sale.
2. Inspect FIN-05 components `C`, `R`, `D_r`, `V_r`, `P`, resulting `G`, threshold before/after, rate and `W`. The interface explains every deduction and displays source evidence. A negative/inconsistent base is `BASE_REVIEW_REQUIRED`; a reported mismatch is `RECONCILIATION_EXCEPTION`.
3. In the platform demo, show `SIMULATED_WITHHELD`. In the provider demo, reconcile the imported simulated deduction without creating a second one. Neither creates a live BIR payment. Link expected and reported settlement amounts to the original payment; payment success and tax reconciliation remain independent.
4. On completed orders inspect the earned 2% fee, using VAT-exclusive discounted materials value. The first-of-month job drafts fee statements. Approve without editing source assessments, issue with the FIN-03 due date, then monitor Owner fee payment to the platform test account. A late or failed fee payment creates a receivable task, not a Buyer cancellation or withheld refund.
5. On final cancellation or enforceable dispute refund, verify the Buyer entitlement, original payment allocation and any cash portion. Queue the correct existing refund trigger. Open separate fee credit and tax-adjustment cases. A Vendor's tax or fee debt cannot be deducted from Buyer reimbursement.
6. For a tax adjustment, the preparer records original period/assessment, reason, proposed correction, refund evidence and certificate impact. A different authorized reviewer approves or rejects. Posted/closed periods are amended by linked entries and the externally required process, never deleted or silently recalculated.
7. Prepare a package by withholding entity and tax period under FIN-08. Reconcile remittances to assessments, adjustments, selected ATCs, certificate totals and return/alphalist exports. Inspect missing evidence and due-date validation before permitting REVIEWED. The same user cannot prepare and approve the package.
8. Export a watermarked demo package with hash and source versions. Mark only EXPORTED or SIMULATED_SUBMISSION_RECORDED. Future live FILED/BIR_PAID outcomes require separate authentic submission/payment evidence. A provider certificate remains issued by that provider; an Admin cannot impersonate its issuer.

The financial case detail provides an expandable amount table, current responsible actor, timestamped event history, deadlines, private evidence and permitted next action. Mask taxpayer identifiers except for specifically authorized review/export. CSV exports neutralize spreadsheet-formula injection in user-supplied cells. Export and download events record the actual user and file hash. Alerts surface refund failure, declaration due date, threshold breach, missing certificate, unapproved billing draft and overdue statement without attaching sensitive documents to general notifications.

For physical reimbursements, track `VENDOR_REIMBURSEMENT_PENDING` and evidence-based `REIMBURSEMENT_CONFIRMED` independently of online refund status. A combined remedy closes only after every required online and physical component is terminal and satisfied. No Admin manually disburses funds or changes the original online refund destination. A test reset creates a new isolated fixture run; it cannot erase the demonstrated audit chain or mix test data into live exports.

The defense walkthrough uses FIN-06 and FIN-12: demonstrate a qualifying online order, VAT arithmetic, a missing declaration, threshold crossing under concurrency, direct cash, mixed NRPC, completed commission billing, cancelled-order refund and post-completion partial refund. Present the unresolved production withholding assignment explicitly as a verified deployment gate, rather than claiming an agreement that does not exist.

---

### Privacy, Accessibility, and Audit Controls

Admin access to personal information follows least privilege and the Philippine Data Privacy Act principles of transparency, legitimate purpose, proportionality, accuracy, security, and limited retention. High-volume export requires explicit permission and recent authentication. Export reason, filters, file, actor, and expiry are recorded. Files use private storage and expiring access.

The Admin Portal targets WCAG 2.2 Level AA. It supports keyboard navigation, visible focus, semantic headings and tables, labeled controls, error summaries, sufficient contrast, non-color status indicators, and accessible confirmation dialogs. Deadline timers include exact text and do not rely only on color.

Audit logs are append-only through the application. Corrections are represented by a new compensating event rather than editing prior history. System clocks, Admin identity, role, source record, decision reason, and correlation identifiers support traceability.

---

### Authoritative Compliance References

- [BIR RR No. 16-2023 — Merchant remittance withholding and exclusions](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2016-2023%203.pdf)
- [BIR RMC No. 8-2024 — Registration, declarations, thresholds and responsibility](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%208-2024%20(1).pdf)
- [BIR RR No. 5-2025 — Current 0.5% gross-remittance rate](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%205-2025.pdf)
- [BIR RMO No. 18-2025 — Replacement withholding codes](https://bir-cdn.bir.gov.ph/BIR/pdf/RMO%20No.%20018-2025.pdf)
- [BIR RMO No. 26-2025 — Corrected gross-remittance code descriptions](https://bir-cdn.bir.gov.ph/BIR/pdf/RMO%20No.%2026-2025%20Digest.pdf)
- [BIR RMC No. 55-2026 — Withholding alphalist submissions](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2055-2026.pdf)
- [BIR RR No. 11-2025 — Electronic invoicing and reporting](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2011-2025.pdf)
- [BIR RR No. 26-2025 — Electronic-invoice transition and coverage](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2026-2025%20Digest.pdf)
- [BIR Form 2550Q guidance — VAT rates and bases](https://bir-cdn.bir.gov.ph/BIR/pdf/2550Q%20guidelines%20April%202024_final.pdf)
- [Xendit — Philippine withholding on gross remittances](https://docs.xendit.co/docs/withholding-tax-on-gross-remittances-ph)
- [Xendit — xenPlatform fees](https://docs.xendit.co/docs/xenplatform-fees)
- [Xendit — Split payments and refund limitations](https://docs.xendit.co/docs/split-payments)
- [PwC — When the BIR says mine to online sellers, February 2024](https://www.pwc.com/ph/en/tax/tax-publications/taxwise-or-otherwise/2024/when-the-bir-says-mine-to-online-sellers.html)
- [Inquirer — Online-seller withholding implementation, July 2024](https://newsinfo.inquirer.net/1961672/bir-online-sellers-must-now-pay-withholding-tax)
- [Cruz Marcelo — RR No. 16-2023 overview](https://cruzmarcelo.com/quick-look-bir-revenue-regulations-no-16-2023-requires-e-marketplaces-and-digital-financial-services-providers-to-withhold-1-income-tax-on-remittances-to-merchants/)

- This workflow is a product and technical control specification, not legal advice. Philippine counsel, the Data Protection Officer, tax advisers, and the contracted payment provider must complete a pre-launch review and approve changes when governing requirements or contracts change.
- [Lawphil — Republic Act No. 11967, Internet Transactions Act of 2023](https://www.lawphil.net/statutes/repacts/ra2023/ra_11967_2023.html)
- [Lawphil — Republic Act No. 8792, Electronic Commerce Act of 2000](https://lawphil.net/statutes/repacts/ra2000/ra_8792_2000.html)
- [Lawphil — Republic Act No. 7394, Consumer Act of the Philippines](https://lawphil.net/statutes/repacts/ra1992/ra_7394_1992.html)
- [National Privacy Commission — Data Privacy Act](https://privacy.gov.ph/data-privacy-act/)
- [National Privacy Commission — Implementing Rules and Regulations](https://privacy.gov.ph/implementing-rules-regulations-data-privacy-act-2012/)
- [DTI-BPS — PS and ICC Marks](https://bps.dti.gov.ph/product-certification/ps-and-icc-marks)
- [DTI-BPS — Products Under Mandatory Certification](https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification)
- [DTI — E-Commerce Philippine Trustmark / Internet Transactions Act](https://trustmark.dti.gov.ph/)
- [DTI-BPS — PNS 2155:2020 Guidelines for E-Commerce Transactions](https://bps.dti.gov.ph/press-releases/28-2021/259-dti-issues-national-standard-guidelines-for-e-commerce-transactions)
- [BIR — Ease of Paying Taxes](https://www.bir.gov.ph/EOPT)
- [BIR RMC No. 77-2024](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2077-2024.pdf)
- [Philippine Statistics Authority — Philippine Standard Geographic Code](https://psa.gov.ph/classification/psgc)
- [Xendit — Accept Payments for Sub-Accounts](https://docs.xendit.co/docs/accepting-payments-for-sub-accounts)
- [Xendit — Refund Payment](https://docs.xendit.co/docs/refund-payment-request)
- [Xendit — Transaction Fees](https://docs.xendit.co/docs/transaction-fees)
- [Google — Places API Policies](https://developers.google.com/maps/documentation/places/web-service/policies)
- [OWASP — Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- [W3C — WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)

---

### Future Enhancements

Automated legal-document validation without human review, direct Admin financial controls, MateryalPH escrow or wallet, unrestricted Admin Custom Roles, and predictive enforcement are outside the current capstone scope.


### Owner decision — 2026-10-02: Store messaging and product cards (MSG-02)

This decision supersedes the product-required/locked-product entry wording in Phase 9. A Buyer may message an active Tier 2 Vendor directly from Store Profile without a product. General and product inquiries reuse one SALES / ITEM_BASED conversation per Buyer and Vendor store. The owner confirmed that Work Package quotation conversations and order-specific FULFILLMENT threads remain separate with their existing authority and commercial records.

Product Details opens that store conversation and prepares an unsent, removable product draft; opening it never sends a message. Do not attach again when the same product is the latest attached product. Preserve unsent Buyer text/product drafts locally in secure storage, and only restore after current conversation authorization succeeds. The composer offers a searchable, paginated picker restricted to that store's currently eligible active products. Text, product-only and text-with-product messages are supported. Product references use the existing listing variant UUID (`product_id`); snapshot listing ID, name, integer-centavo price and safe public image URL at send time. Preserve the snapshot after catalog changes and display No longer available when the offer is unavailable. Product cards do not modify quotations, inventory, or accepted terms.

Client-generated message IDs bind immutable sender, text and product content. Optimistic messages show Sending, failure and Retry; retry reuses the same identifier. Inbox rows show the public other-party identity/avatar, latest message preview (Sent a product: [name] for product messages), Manila timestamp and unread count, ordered by activity. Opening the thread marks received messages read. Loading, No messages yet and real failures with functional Retry are separate states.

Use existing Reverb viewer-authorized channels and account inbox invalidations. Reconnect reauthorizes and fetches missed history; REST polling is a recovery fallback. Typing is an ephemeral, debounced event with a server timestamp, no database/outbox persistence, and approximately three-second expiry. Read/send/file/channel checks continue to revalidate account, store, role and handler authority; preserve scanner, rate-limit, commercial-history and privacy safeguards. No Admin receives general conversation access through this change.

Legacy duplicate general inquiries are linked to the oldest canonical thread without moving or deleting immutable commercial history. They remain reachable from Earlier inquiry history; new general chat goes to the canonical thread. Existing quotation actions retain their purpose-specific authorization. The unique partial index excludes Work Package and fulfillment threads.


### Owner decision — 2026-10-02: Later quotations in a permanent store chat (MSG-03)

The owner approved later, separate quotations in the same general store conversation after an earlier quotation is accepted. Vendor sales staff use New quotation; Customer Service retains draft-only authority. Each quotation keeps its own immutable published versions and accepted order. An idempotent start action requires the current quotation version, and the new draft advances the version counter so a stale editor cannot overwrite it. Earlier accepted quotations remain Accepted with their original order links; they are never relabeled Superseded by a later purchase. Work Package inquiries keep their one-quotation commercial boundary; fulfillment threads cannot create quotations.

A Buyer may add or update the saved delivery location and heavy-vehicle access declaration from Delivery details inside the general thread, without a product or a blocking chat-entry dialog. Only the Buyer's owned, nonarchived locations are permitted; the intended site and alternate drop-off remain separate. Changes require the current conversation version and are rejected while the current quotation is Published or Viewed. An existing draft's version advances, and publication rechecks the delivery reference after route calculation. Existing accepted quotation and order snapshots remain unchanged. This follows from the permanent product-free store chat: delivery must not be fixed to its first entry.

Local runtime verification uses Reverb's private channels. Native Buyer sockets send the explicit application-origin label `https://materyalph-buyer` (not a network endpoint); it grants no channel permission. Browser origins remain explicitly allowlisted. Application keys must not contain a colon because Pusher signatures use `key:signature`. No secret values belong in documentation or client bundles.
