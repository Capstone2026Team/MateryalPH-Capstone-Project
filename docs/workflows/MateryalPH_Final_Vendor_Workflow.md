**Vendor Flow**

---

**Vendor Portal (Web Application using React.js)**

MateryalPH provides a dedicated **web-based Vendor Portal** developed using React.js. It is separate from the Buyer mobile application and Admin Portal and supports Vendor account management, onboarding, verification, storefront management, product compliance, inventory, orders, fulfillment, payment records, staff management, messages, disputes, and analytics.

The System Workflow is the authoritative source for shared security, state, scoring, payment, privacy, accessibility, audit, and integration rules. This Vendor Workflow defines Vendor-facing processes, permissions, and responsibilities.

**Approved capstone operating basis — 5 September 2026.** MateryalPH is an academic prototype, not an asserted BIR-registered operating business. All Xendit integrations use TEST credentials and test accounts. Every payment screen, financial report, certificate preview and billing statement carries **DEMO — No real funds or BIR filing**. A successful test webhook demonstrates provider integration; it does not prove real collection, statutory withholding, remittance to the BIR, or government approval. Physical-payment demonstrations record simulated cash handover to the Vendor. Seeded identities and tax documents are conspicuously fictional and must never be submitted to regulators or used to represent a real business as verified.

The approved commercial design uses a **2% Vendor-paid commission on completed materials value after discounts and excluding materials VAT**, billed monthly for Online, COD and In-Store orders. The fee is distinct from Buyer-paid processor charges and Vendor withholding. No subscription or listing charge applies. The System Workflow's controls `FIN-01` through `FIN-12` are authoritative for calculation and implementation; the other workflows apply them within their existing screens. The production withholding entity is **UNCONFIRMED**. Test scenarios may simulate either responsibility path, but no Admin toggle can establish a real legal allocation or enable live money movement.

The Vendor website includes a public landing page for supplier recruitment. The page explains the available Buyer audience, onboarding requirements, marketplace functions, the 2% Vendor-paid monthly commission policy under FIN-03, third-party payment fees, and applicable limitations without guaranteeing sales or revenue. The public landing page does not claim BIR registration, government approval, guaranteed sales, or live merchant activation. Internal environment and provider-status labels belong to authenticated operational surfaces and internal documentation, not public Vendor marketing copy.

- **Key Focus:** Marketplace purpose, eligibility, verification, setup, fees, fulfillment responsibilities, privacy, and Vendor obligations.
- **Call to Action:** **Create Vendor Account** or **Sign In**, leading to the Vendor Portal authentication page.

Existing Vendor users select **Sign In**. A business that is not yet registered selects **Sign Up** and creates the Vendor Owner account before onboarding.

---

**Vendor User Types**

- **Vendor Owner (Main Vendor Store Account)**

The Vendor Owner is the highest-authority account in the Vendor organization. The Owner controls legal-business information, Xendit onboarding and payout configuration, staff delegation, security, storefront settings, compliance, PS/ICC submissions, listings, inventory, orders, fulfillment, messages, disputes, and reports. If the Vendor has no staff accounts, all permitted store functions remain available to the Owner.

### **Vendor Team Account**

A Vendor Team Account belongs to one employee and is connected to the existing Vendor organization through a membership record. It does not create a separate store. Each employee uses an individual login identity, receives exactly one fixed role, and maintains an independent audit history.

The fixed roles are:

1. **Store Manager (Delegate Role)**
2. **Store Staff**
3. **Customer Service Staff**
4. **Inventory Staff**
5. **Fulfillment Staff**

Roles cannot be stacked, customized, or combined. Small stores may use Store Staff when one employee performs both customer-service and inventory functions. Vendor Sales Staff, Vendor Compliance Staff, and Vendor Custom Roles are not part of the final capstone model.

### **Pending or Restricted Account**

A Vendor user whose account, organization, onboarding, compliance, or marketplace status is pending or restricted receives only the functions permitted by that status. The Laravel backend checks account status, organization membership, role, and resource access on every protected request. Interface hiding is not treated as security enforcement.

---

**Vendor Sign-in and Sign-up**

# 1. Vendor Sign-in

The Vendor Owner and all Team Accounts use the same Vendor Sign-in page. After authentication, the backend resolves the user's organization, fixed role, delegated flags, account status, and permitted functions.

The supported methods are:

- **Email and Password**

The system validates the submitted email and password through HTTPS, input validation, risk-based bot protection, and account-aware rate limiting. A maximum of five failed attempts within 15 minutes triggers temporary throttling. The backend confirms that the email is verified, the password matches its adaptive hash, the membership remains active, and neither the user nor Vendor organization is suspended, deactivated, or banned.

The response remains generic when more detail could reveal whether an account exists. Passwords are never stored in plain text or reversible form.

- **Sign in with Google**

Google sign-in uses the OpenID Connect Authorization Code flow with PKCE. MateryalPH validates signature, issuer, audience, expiration, nonce, state, and `email_verified`, and uses Google's stable `sub` claim as the linked identity. A valid Google sign-in does not require a duplicate email OTP. An unlinked Google identity is directed to registration or the authorized staff-invitation process and never creates an active Vendor automatically.

**Privileged Verification**

The Vendor Owner and Store Manager must enroll an authenticator-app TOTP before using privileged functions. TOTP is required for a fresh privileged session and recent reauthentication is required for staff delegation, security changes, legal-business changes, payout configuration, and account deletion. Email OTP remains available for email verification, recovery, and risk-based step-up; it is not labeled strong MFA. MateryalPH sends no SMS OTP.

# Vendor Team Account Sign-in

After successful authentication, the system identifies:

- Vendor organization.
- User account and membership.
- Fixed role.
- Store Manager staff-management delegation, if applicable.
- Account and organization statuses.
- Required security step-up.

A Team Account sees only the sections and records permitted by its role. An employee cannot create another Vendor organization, assume ownership, or access another Vendor's information.

## 1.1 Forgot Password

The user submits an email address and receives a generic response. If the account is eligible, the system sends a unique, time-limited, single-use reset link or OTP. Reset requests are rate-limited and older active recovery credentials are invalidated when a newer reset is completed.

After a successful reset, the system invalidates the recovery credential, revokes active sessions and refresh tokens, records the event, and sends a security confirmation. An expired or used credential cannot change the password. Privileged accounts must complete their enrolled TOTP or an approved recovery process.

# 1.3 Authentication and Session Management

The Vendor Portal uses the shared JWT architecture. Short-lived access tokens and rotated refresh tokens are transmitted through `Secure`, `HttpOnly` cookies with CSRF protection and an appropriate `SameSite` policy. Tokens are not stored in browser local storage.

Sessions are revoked after logout, password reset, password change, email change, factor recovery, account suspension, membership deactivation, or organization ban. After authentication, the system evaluates account status, Vendor organization, role, delegation flags, email verification, business verification, onboarding, marketplace activation, and required reauthentication.

# 1.4 Authentication and Security Audit Trail

The system records significant events, including account creation, successful and failed login, Google authentication, password recovery, email verification, TOTP enrollment and recovery, credential changes, staff invitation and role changes, suspension, deactivation, and sensitive configuration actions. Each record contains the actor, organization, action, affected resource, previous and new value where appropriate, timestamp, result, device or correlation reference, and reason. Secrets and OTP values are excluded.

---

# 2. Vendor Sign-up and Registration

Registration creates a restricted Vendor Owner account and Vendor organization. It does not approve the business for marketplace participation. The canonical sequence is:

`Vendor Account Creation → Account / Email Verification → Required Agreement Acceptance → Vendor Portal Account Active → Vendor Onboarding`

Store Activation and Marketplace Discoverability are evaluated later as separate organization and marketplace states. A Vendor Portal Account becoming active does not activate the store or make it discoverable.

# 2.1 Account Creation

The Vendor may use:

- **Sign Up with Google.** After valid Google authentication, the verified email is recorded and no second email OTP is required. The Owner completes the missing required fields and agreements.
- **Sign Up with Email and Password.** The Owner provides name, business or store name, email, mobile number, password and confirmation, and required agreement acknowledgments. The system sends a six-digit, short-lived, single-use email OTP. The account remains `PENDING_VERIFICATION` until the email is verified.

Registration applies HTTPS, CSRF protection where applicable, server-side validation, rate limiting, duplicate-account prevention, bot protection, secure password hashing, and generic responses. One email address cannot create multiple MateryalPH account types in the current capstone.

### 2.2 Email and Mobile Number Registration

For Google Sign-Up, a valid `email_verified` claim sets **Email Verification Status: Verified**. For email/password sign-up, the email OTP expires, is single-use, is replaced by a newer code, and is subject to resend and attempt limits.

The Vendor Owner must provide a valid Philippine mobile or telephone number for legitimate administrative, order, and delivery coordination. The number is normalized where applicable and masked in the interface. It is a contact field only and is not verified through SMS. A change to the registered contact number requires recent authentication, confirmation, notification, and audit logging, but no SMS provider is used.

## 2.3 Agreement and Policy Acceptance

Before the Vendor Portal Account becomes active, the Vendor Owner accepts the applicable Vendor Terms of Service and Vendor Code of Conduct. The system stores agreement type, version, organization, accepting user, timestamp, and source. These are the Required Agreements in the canonical registration sequence.

A Privacy Notice is presented separately before personal, legal-business, identity, tax, or compliance information is submitted for Store Verification. It identifies the purpose, lawful basis, collected information, recipients, retention basis, rights, and contact process. Privacy Notice acknowledgment is not a substitute for accepting commercial agreements and does not automatically accept unrelated terms or optional processing activities. An NDA is used only for a separately identified business need.

### 2.4 Verification Completion

The Account / Email Verification stage is complete when:

- The Vendor Owner account and Vendor organization have been created.
- The Owner's email is verified, either through the approved Google identity or the email OTP flow.
- Required registration contact information is recorded.

The Required Agreement Acceptance stage is complete when the current Vendor Terms of Service and Vendor Code of Conduct have been accepted by the Vendor Owner. After those stages succeed, the system makes the Vendor Portal Account active with:

- **Account Status:** `ACTIVE`
- **Vendor Onboarding Status:** `NOT_STARTED`
- **Store Verification Status:** `NOT_STARTED`
- **Store Setup Status:** `NOT_STARTED`
- **Store Activation Status:** `NOT_ACTIVE`
- **Marketplace Discoverability:** `NOT_DISCOVERABLE`

The Owner may enter the Vendor Portal and complete Vendor Onboarding but cannot receive marketplace orders or use full marketplace-management capabilities until Store Activation. Privacy Notice acknowledgment is recorded during Store Verification before submission and is not silently moved into the account-verification stage.

### Verification Security Controls

Verification uses HTTPS, secure OIDC handling, adaptive password hashing, expiring single-use email codes, request and attempt limits, server-side validation, enumeration-resistant responses, session security, TOTP for privileged functions, and immutable security-event logging. Google passwords, plaintext OTPs, access tokens, and recovery codes are never stored in logs.

---

## Vendor Onboarding

Onboarding collects the legal, operational, compliance, storefront, fulfillment, and payment information required for activation. It has two separate primary sections with separate progress and review states:

1. **Store Verification** — establishes the Vendor's legal, business, tax, regulatory, contact, classification, and registered-location information and submits applicable requirements for manual Admin review.
2. **Store Setup** — configures the public store profile, procurement capability, fulfillment and conditional delivery settings, payment configuration, and other operational settings.

The Vendor may save progress and return later. Completing Store Setup never implies that Store Verification is approved. Dependencies and activation eligibility are enforced by the backend.

### Requirement Levels and Statuses

Every onboarding requirement has a **Requirement Level** and a separate **Requirement Status**.

| **Concept** | **Allowed values** | **Meaning** |
| --- | --- | --- |
| Requirement Level | `REQUIRED`, `OPTIONAL`, `CONDITIONALLY_REQUIRED` | Whether the requirement is mandatory, optional, or mandatory only when its applicability condition is true |
| Requirement Status | `NOT_STARTED`, `IN_PROGRESS`, `SUBMITTED`, `PENDING_VERIFICATION`, `APPROVED`, `COMPLETED`, `CHANGES_REQUIRED`, `REJECTED`, `EXPIRED`, `NOT_APPLICABLE` | The progress, review, or completion state of that requirement |

`REQUIRED`, `OPTIONAL`, and `CONDITIONALLY_REQUIRED` are never progress statuses. `NOT_APPLICABLE` is used for a conditionally required requirement only when its documented business, tax, capability, or other applicability condition does not apply to this Vendor. It must not be used to bypass an incomplete required item.

Admin-reviewed Store Verification requirements normally satisfy activation only at `APPROVED`. Non-reviewed Store Setup requirements may satisfy activation at `COMPLETED`. Document metadata may separately record **Expiration Date: Not Applicable** when the document legitimately has no expiration; that metadata value is not the onboarding status `NOT_APPLICABLE`.

## 1. Store Verification

Store Verification is the first primary section of Vendor Onboarding. It is completed through manual Admin review supported by server-side validation, file-safety checks, and applicable document-verification tools. Uploading information or a document never changes it to `APPROVED` automatically.

The Vendor Portal distinguishes information entered by the Vendor, information submitted for review, information pending Admin verification, information requiring correction, and information approved by the Admin.

**Business Information and Document Verification**

Business Information is separate from the public Store Profile. It includes the fields and evidence applicable to the selected Business Type and Vendor configuration.

### Business Type

The Vendor selects exactly one legal Business Type:

1. **Sole Proprietorship**
2. **Partnership**
3. **Corporation**
4. **One Person Corporation (OPC)**
5. **Cooperative**

Each value is stored as a distinct business classification. An OPC may be treated internally as a corporate subtype for applicable registration, tax, and integration rules while remaining a separate selectable value in the Vendor interface.

The selected Business Type determines the applicable legal-name fields, registration authority, primary registration document, supporting identity evidence, and tax or verification requirements. Changing the Business Type after submission re-evaluates all applicable requirements. If the change affects previously submitted or approved information, the affected requirements are versioned and reopened for Admin review.

### Legal Identity

**Individual Registered Name** applies to a Sole Proprietorship and to other verification cases in which an individual proprietor, incorporator, authorized representative, or taxpayer must be identified. The Vendor provides the complete legal name exactly as it appears on the applicable government-issued ID and registration records:

- Surname.
- First Name.
- Middle Name.
- Suffix, where applicable.

The interface provides **Same as Vendor Owner's full legal name**. When selected, the system pre-fills the fields from the Owner's registered or verified account information, but the Vendor must review and confirm that it matches the supporting records. Helper text explains that the Individual Registered Name is the complete legal name shown on the applicable identification and registration records.

Where an organization name is required, **Company Registered Name** applies to a Partnership, Corporation, One Person Corporation (OPC), or Cooperative. It is the official legal name recorded by the applicable registration authority. The Vendor enters one Company Registered Name and must keep it consistent with the submitted registration evidence. An OPC may therefore require both the incorporator/Owner identity and the registered corporate name.

Where identification of an individual is applicable, the Vendor submits the required government-issued identification. The form may require ID Type, ID Number where applicable, front image, and back image when both sides contain relevant information. The document must correspond to the individual identified in the legal-identity section.

Government-issued identification is private verification information. It is never displayed on the public Store Profile, Buyer search, public Vendor listings, to other Vendors, or to Vendor staff without the required permission.

### Business Information

**Business or Store Name** is the Vendor's public-facing marketplace identity. The Store Name entered during account creation is pre-populated here. The Vendor may review or change it before final Store Verification submission. It may appear in the storefront, Buyer search, listings, quotations, orders, messages, and marketplace recommendations. If no separate trade name is used, the applicable registered taxpayer or legal-business name may be used where permitted.

Public Store Name and Legal Business Name remain separate data fields. The Store Name never replaces the Individual Registered Name or Company Registered Name.

**Date of Establishment** records when the business was established or officially registered. The date must be valid, not in the future, and consistent with applicable registration evidence where Admin review requires comparison. The Vendor-entered value remains subject to Admin verification when treated as a verified business fact.

**Store Email** is the primary address for store communication, business notifications, marketplace notices, and Vendor administration. A verified Google email may be pre-filled and does not require duplicate ownership verification. The Vendor may select **Use a different Store Email**. A replacement email is format-validated, receives a short-lived OTP, and becomes active only after successful OTP verification. If verification fails or expires, the existing verified Store Email remains unchanged.

**Store Phone Number** is the primary store contact. **Same as Vendor Owner phone number** pre-fills the Owner's registered number. It remains a contact field and is not treated as SMS-verified because the capstone does not use an SMS provider.

### Primary Business Contact

The Vendor Owner is displayed as the initial Primary Business Contact. The Owner may add multiple contacts. Each contact records full name, position or title, professional or personal email, and mobile or telephone number, together with applicable authorization flags such as:

- Authorized for business-verification communication.
- Authorized for account-administration communication.
- Authorized for general administrative communication.
- Authorized-representative designation, where applicable.

Exactly one contact is designated **Primary Business Contact** at a time. Changing that designation creates an audit event. An authorized-representative designation does not create a Vendor Portal account or staff permission; a separate Vendor Team Account invitation is required for system access.

### Registered Business Address

The Vendor provides the registered or principal operating address through either **Manual Address Entry** or **Interactive Map Selection**. Structured fields include street, building, unit, or establishment; barangay; city or municipality; province or applicable independent-city classification; and postal code.

The approved Google Maps integration may resolve a map pin into structured address information. The interface displays, where available, street/building, barangay, city or municipality, province or administrative area, postal code, latitude, and longitude. Latitude and longitude are displayed in their designated location fields after map selection. The Vendor reviews the resolved address before saving and must complete missing fields when geocoding cannot confidently provide them.

Location validation occurs before the location is used for discovery, location-based search, distance calculations, delivery coverage, delivery-fee calculation, supplier recommendation, Vendor Materials Analytics scope, or geographic reporting. Coordinates are stored separately from the human-readable address. A critical change to an approved address creates a new version or review event rather than silently overwriting the verified value. Google API keys and provider credentials remain protected and are not committed or unnecessarily exposed to the client.

### Supplier Type / Classification

The Vendor selects one applicable Supplier Type:

1. **Wholesaler / Distributor**
2. **Retail Hardware Store**
3. **Specialized Supplier**

The Vendor selects one or more Supplier Niches. Canonical niches may include Construction Materials; Electrical Supplies; Plumbing and Sanitary; Tools and Equipment; Finishing Materials; Fasteners and Hardware; Cement and Concrete; Roofing Materials; Formworks and Scaffolding; Wood and Lumber; Landscaping and Exterior; Steel and Reinforcement; Tools and Accessories; Masonry; Insulation and Waterproofing; Aggregates; Drainage and Septic Materials; Construction Chemicals; Flooring Materials; Wall and Ceiling Materials; HVAC Materials; Sanitary Fixtures; Fire Protection Materials; Paints and Finishes; Adhesives and Sealants; and Doors, Windows, and Glass. Substantially equivalent labels are consolidated into one canonical taxonomy.

The Vendor may select **Others — Specify Category**. The supplied text is stored as a Vendor-provided custom classification label and does not automatically create a new canonical MateryalPH category. A valid Other label does not require separate Admin approval solely because it is custom, provided it does not violate a prohibited-category rule. Canonical taxonomy mapping may be reviewed later.

MateryalPH does not support construction-vehicle or equipment-rental services as marketplace inventory. Category validation rejects entries such as Construction Vehicle Rental, Vehicle Rental, Construction Equipment Rental, Equipment Rental, or Rental, case-insensitively and after reasonable normalization. Selecting Tools and Equipment does not make construction-vehicle rental a supported service.

### Business and Compliance Verification

The required primary registration evidence is determined by Business Type:

| **Business Type** | **Required Primary Registration Evidence** |
| --- | --- |
| Sole Proprietorship | Applicable DTI Business Name Registration |
| Partnership | Applicable SEC Registration |
| Corporation | Applicable SEC Registration |
| One Person Corporation (OPC) | Applicable SEC Registration |
| Cooperative | Applicable CDA Registration |

The system shows only requirements applicable to the selected Business Type. All Vendors provide applicable LGU-issued Business Permit, BIR Certificate of Registration, TIN, declared VAT or Non-VAT status, and other regulatory evidence required by the business type, location, or marketplace activity. Optional ISO, industry, professional, or regulatory certifications do not block activation unless a product, law, or selected capability makes them mandatory.

### Tax Information and Vendor Tax Profile

Tax information is collected once in Store Verification and is the source for the Vendor Tax Profile. Payment Configuration references the approved or effective Vendor Tax Profile and must not collect duplicate legal tax information.

The Vendor provides the applicable TIN and branch code exactly as shown on BIR records. The system validates structure, rejects clearly malformed values, stores the full value as private business-tax information, and masks it in authorized displays. The full TIN is never exposed on public Store Profiles, Buyer search, Vendor maps, public listings, public analytics, or another Vendor's interface.

The Vendor declares **VAT Registered** or **Non-VAT Registered**. The system keeps **Declared VAT Status** separate from **Verified VAT Status**. Admin verifies the declaration against the BIR evidence. An inconsistency produces `CHANGES_REQUIRED` or another documented review decision; it does not silently change the Vendor's declaration.

The Vendor uploads the applicable BIR Certificate of Registration in an allowed format such as JPG, JPEG, PNG, or PDF. Content type, maximum size, MIME/content, file-safety, malware scan, private-storage, and access rules apply. Admin compares the COR's legal or taxpayer name, TIN, branch, registration status, and VAT/Non-VAT information where shown. Uploading a COR does not verify the tax profile.

The Vendor is asked whether to **Submit applicable Sworn Declaration or withholding-supporting declaration?** with **Yes** or **No**. A declaration may affect withholding only when the Vendor qualifies under the applicable tax rules and submits valid evidence. Selecting Yes never automatically grants exemption, reduced withholding, threshold relief, or another tax treatment. Selecting No records that no applicable declaration was submitted for the period; where permitted by FIN-04, standard withholding applies and activation is not blocked solely by an optional relief declaration. Missing mandatory BIR registration remains an activation blocker.

Where applicable, declaration evidence records declaration year, type, threshold position, BIR-received or other document, receipt/reference, prior-year position, outside-platform remittance scope, submission date, effective period, verification status, and Admin remarks. The Vendor Owner attests the declaration. A Store Manager may prepare a correction draft when authorized but cannot replace the Owner's required attestation.

The Vendor Tax Profile maintains taxpayer identity, legal-entity classification, TIN and branch information, VAT or Non-VAT classification, fiscal or tax period, evidence, declaration evidence, effective period, environment, evidence origin, verification decision, withholding assignment/scenario, and version history. Corrections create a new version or audited change and never rewrite prior accepted prices, payments, immutable financial snapshots, or posted financial records.

The Vendor may view **Submit declaration**, **View withholding status**, **Explain missing evidence**, and **Report threshold exceeded** actions. All withholding, remittance, commission, provider, and tax responsibilities remain governed by FIN-01 through FIN-12. TEST/DEMO evidence is visibly sample evidence and never becomes production approval. A Sworn Declaration is not automatic tax treatment, and Xendit connection is not proof of withholding responsibility.

### Document Metadata and Verification

For every business or compliance document, the Vendor supplies the file and any entered metadata. Metadata includes, where applicable, document type, document number, upload timestamp, uploading user, organization, file reference, submission status, verification status, reviewer, remarks, verified issue date, verified expiration date, replacement/superseded-document reference, and audit reference.

Vendor-entered metadata is never treated as officially verified. Admin review records the verified document number, issue date, expiration date or **Expiration Date: Not Applicable**, document source, remarks, reviewer, review timestamp, decision, and reason. The system distinguishes no expiration, expiration not yet verified, verified expiration, and expired document. It prevents an expiration date earlier than the issue date.

Each Admin-reviewed requirement uses `APPROVED`, `CHANGES_REQUIRED`, or `REJECTED` as applicable. Rejected, expired, or replacement evidence requires correction or replacement and a new review where applicable. A previously approved document may remain effective while a replacement is reviewed when the compliance rule permits; an expired or materially invalid document may create an immediate restriction.

### Submission Validation

Before Store Verification can be submitted, the system validates the applicable Business Type, legal-name and identity fields, business/store name, establishment date, verified Store Email, Store Phone Number, contacts, registered address and coordinates where required, Supplier Type and niches, registration evidence, LGU and BIR information, TIN, VAT/Non-VAT declaration, Vendor Tax Profile fields, applicable declarations, document numbers, supported file type and size, malware/file-safety state, acknowledgments, and other conditional requirements.

If a required item is missing or invalid, submission is blocked and the exact requirement is identified. A conditionally required item that does not apply is recorded at level `CONDITIONALLY_REQUIRED` and status `NOT_APPLICABLE` with its applicability reason. Submission does not mean verification.

### Privacy Notice

Before submission of personal, legal-business, identity, tax, or compliance information, the system presents the applicable Privacy Notice. It explains collected categories, purposes, processing activities, authorized recipients/processors, retention basis, data-subject rights, privacy-request process, and other required information. The system records the Vendor/User, organization, Privacy Notice version, timestamp, processing activity, source/interface, and acknowledgment.

Privacy Notice acknowledgment is stored separately from Terms of Service, Vendor Code of Conduct, Commission Agreement, payment agreements, and other commercial terms. It does not automatically accept unrelated agreements or optional processing.

### Store Verification Submission Confirmation

After successful submission, the system sets the Store Verification section to `PENDING_VERIFICATION` and displays:

**“Business information and documentation successfully submitted. Your Store Verification is awaiting Admin review.”**

The page provides **Proceed to Store Setup**. The Vendor may begin Store Setup immediately and may continue it while Admin review is pending. The store cannot be activated until all applicable mandatory Store Verification requirements reach `APPROVED`.

### Pending Verification, Correction, and Reverification

Admin reviews Store Verification manually through the Admin Portal. Review includes completeness, consistency, dependency validation, file and document validation, malware or file-safety results, and comparison with applicable DTI, SEC, CDA, LGU, BIR, and TIN evidence.

For every reviewed requirement, Admin may:

- **Approve** — the requirement satisfies the applicable rule and becomes `APPROVED`.
- **Return for Correction** — the Vendor must correct, replace, clarify, or supplement the requirement; the status becomes `CHANGES_REQUIRED` and Admin provides a clear instruction.
- **Reject** — the evidence does not satisfy the requirement in its current form; the status becomes `REJECTED` and Admin provides a reason.

Every decision records the reviewer, timestamp, decision, reason, document number where applicable, issue date, expiration date or **Expiration Date: Not Applicable**, source, remarks, and audit reference. The old evidence is retained. A correction or replacement follows `CHANGES_REQUIRED → SUBMITTED → PENDING_VERIFICATION → APPROVED` where applicable. An approved document that later expires becomes `EXPIRED` and requires replacement. Critical changes to Legal Business Name, Company Registered Name, Business Type, registered address, TIN/branch, VAT classification, mandatory registration evidence, or other critical compliance evidence create a new version/review and may restrict the affected capability until approved.

Changing ordinary public marketing text or a public profile image does not by itself require full business reverification.

## 2. Store Setup

Store Setup is the second primary section of Vendor Onboarding. It may begin after Store Verification is submitted, even while review is pending. Its operational checklist and completion state are independent from Store Verification. It includes Business Store Profile, Fulfillment Configuration, conditional Delivery Configuration, Payment Configuration, optional Vendor Team Account Management, Finish Later and limited-dashboard behavior, and Store Activation readiness.

**Business Store Profile Setup**

The Business Store Profile is a draft marketplace profile until Store Activation. It contains:

- Logo or profile image.
- Store Name pre-populated from Business Information.
- Store Banner.
- Store Description.
- Promotional images and optional promotional video.
- Approved public business contact information.
- Public operating information.

Legal-business fields remain separate and cannot be changed through the public Store Profile editor. Media is validated for supported type, maximum size, safety, appropriate content, intellectual-property requirements, accessibility metadata, and other configured rules. Government ID, TIN, business-verification documents, private tax records, payout credentials, authentication information, and private employee information never appear publicly.

## 3. Fulfillment Configuration

## Bulk Order Capability

| **Declared capability** | **Procurement eligibility** |
| --- | --- |
| Yes — can accommodate bulk orders | Item-Based Procurement + Project-Based Procurement |
| No — cannot accommodate bulk orders | Item-Based Procurement only |

The selected capability controls future procurement eligibility and Project-Based matching. It does not create a separate competitive RFQ bidding queue. A later authorized change affects future marketplace eligibility and does not rewrite accepted orders or quotations.

**Services Capability**

- Self-Pickup.
- Vendor Delivery.
- Both.

If **Self-Pickup only** is selected, Delivery Configuration has requirement level `CONDITIONALLY_REQUIRED` and status `NOT_APPLICABLE` because Vendor Delivery is not enabled. If **Vendor Delivery** or **Both** is selected, Delivery Configuration becomes conditionally required and must be completed before Store Activation. Physical payment methods are configured separately: COD may be enabled for eligible Vendor Delivery orders and In-Store Payment for eligible Self-Pickup orders. Online Xendit onboarding remains mandatory regardless of physical-payment settings.

## 4. Delivery Configuration

Delivery Configuration applies only when Vendor Delivery is selected. The Vendor records vehicles it actually operates or legitimately controls for Vendor Delivery. Categories include Motorcycle, Pickup, Van, Truck, and Custom Vehicle Type. Truck subtypes may include Open Truck, Flatbed Truck, and Wing Van. Unconfigured vehicles must not appear as available fulfillment options.

| **Field** | **Description** |
| --- | --- |
| Vehicle image | Operational image shown where relevant |
| Number of Vehicles | Positive integer representing usable vehicles |
| Capacity per Vehicle (kg) | Maximum cargo payload |
| Cargo Length, Width, and Height (m) | Usable cargo-space dimensions |
| Heavy Vehicle Classification | Used for site-accessibility rules |
| Base Fee (₱) | Fixed amount applied per applicable trip |
| Per-Kilometer Rate (₱/km) | Distance-based delivery amount |
| Maximum Delivery Distance (km) | Maximum supported service distance |

The system validates positive quantities, valid numeric ranges, non-negative rates, required dimensions where applicable, and a required distance limit. It may provide an initial heavy-vehicle classification based on vehicle type while allowing an authorized correction when the actual vehicle differs.

The system recommends a suitable vehicle; it does not dispatch automatically. The Vendor confirms or changes the recommendation and confirms any multiple vehicles or trips before the Buyer pays the final delivery fee. Existing accepted-order delivery snapshots are not changed when a vehicle configuration is later edited, deactivated, or removed.

## 5. Payment Configuration (Using Xendit Activation)

Every Vendor seeking Store Activation and marketplace participation must complete **Xendit xenPlatform sub-account onboarding**, regardless of supported Business Type. For the current capstone, Xendit remains TEST/DEMO-only. TEST/DEMO connection does not prove live payment processing, production KYC, BIR registration, statutory withholding responsibility, remittance, or government approval. MateryalPH stores only the required account identifier, capabilities, connection status, environment, evidence origin, and reconciliation references. Payment credentials and secret keys remain with Xendit or protected server configuration.

MateryalPH applies the 2% Vendor-paid commission under FIN-03, earned on completed materials value after discounts and excluding materials VAT, and billed monthly for every payment method. It is not deducted from Buyer payments in this capstone release. The Buyer pays the separately disclosed order Payment Processing Fee in the demo; live pass-through requires validated channel/provider terms. The Vendor reviews transaction records and uses the Xendit dashboard for provider balances and withdrawals. MateryalPH has no internal Vendor wallet or escrow.

Enabled payment channels come from the actual Xendit environment. Each channel must have documented limits, expiry, settlement, and refund capability. A channel without native refund support remains disabled unless an approved Vendor-managed refund process is implemented and disclosed. Online full-order payments and NRPC assurance payments for COD or In-Store Payment use separate payment purposes and references. An NRPC assurance payment expires after 45 minutes and is credited against the remaining physical-payment balance; it is not an additional charge.

The Payment Configuration screen separates **Xendit TEST/DEMO connection**, **Vendor Tax Profile summary**, **Withholding arrangement**, **Commission Terms**, **Online payment channels**, **Physical payments**, and **Refund capability**. Unknown actual withholding responsibility is displayed as **Production assignment unconfirmed**. The default teaching scenario is `DEMO_PLATFORM_WITHHOLDER`; a second scenario exercises provider reconciliation. Neither claims a real tax deduction by Xendit. All payment references retain their environment and evidence origin.

The Owner accepts the 2% fee schedule, its exclusive materials base, monthly collection, VAT-inclusive fee treatment where applicable, cancellation/partial-refund credits, statement due-date rule and dispute process. Store these as a versioned agreement. No fee is added to an existing accepted order by changing settings. The monthly bill uses `PLATFORM_FEE_PAYMENT` to the platform test account, not the Vendor's Buyer-payment sub-account.

COD and In-Store amounts are collected directly by the Vendor. Authorized Store Staff may record cash received and evidence; Fulfillment Staff may record handover evidence but cannot independently mark cash collected without the relevant payment-record permission. A record stores amount, time, recorder, source and Buyer acknowledgment. It does not fabricate a Xendit webhook. Partial collection leaves an outstanding obligation. Changes use correction events; the outstanding amount may not become negative. NRPC principal is deducted from the remaining balance exactly once under FIN-02.

Payment Configuration reaches `COMPLETED` only when the required Xendit connection and onboarding state are confirmed, required payment capabilities and settings are complete, the effective Vendor Tax Profile is compatible with activation, Commission Terms are accepted by the Vendor Owner, and no applicable payment or provider requirement remains unresolved. A provider outage, unavailable capability, unconfirmed outcome, or unsupported refund route keeps the applicable requirement pending or blocked.

## 6. Vendor Team Account Management

Team Accounts are optional and never block Store Activation. After the Vendor Owner has completed and submitted the required Store Setup configuration, the Owner may invite staff even when Store Verification is still pending. The Owner may also create Team Accounts after Store Activation. Every invitation identifies the employee, email, contact number where required, exactly one fixed role, organization, expiry, and inviting actor. The employee accepts through an individual account and never receives or uses the Owner's credentials.

The fixed Vendor Team roles are **Store Manager**, **Store Staff**, **Customer Service Staff**, **Inventory Staff**, and **Fulfillment Staff**. Each employee has one fixed role and individual audit history. A Team Account belongs to the Vendor organization and does not repeat Vendor Onboarding, create another store, or bypass Store Activation. A staff member may sign in before activation only in the limited-access state permitted by the organization's state and the staff member's role.

When the Owner creates or edits a Store Manager, the system presents an off-by-default toggle: **Allow this Store Manager to manage staff accounts**. A delegated Store Manager may manage only Store Staff, Customer Service Staff, Inventory Staff, and Fulfillment Staff. The Manager cannot manage another Store Manager, create or deactivate another Store Manager, change the Owner, transfer ownership, grant delegation to self or another person, change their own role or access, edit payout credentials, or delete or alter audit records. The Owner is notified of every delegated staff-management action. Access is revoked when the staff account, Vendor account, or delegation is deactivated; active sessions are revoked and historical attribution is retained.

### Finish Later and Limited Dashboard

The Vendor may select **Finish Later** at any permitted point in Store Verification or Store Setup. The system saves the current progress, preserves each requirement's level and status, and returns the Vendor to the limited Vendor Dashboard.

After Store Verification is submitted, the confirmation page provides **Proceed to Store Setup**. The Vendor may continue Store Setup while Store Verification is `PENDING_VERIFICATION`. Store Setup may reach `COMPLETED` while Store Verification remains `PENDING_VERIFICATION`, `CHANGES_REQUIRED`, `REJECTED`, `EXPIRED`, or incomplete. Store Setup completion never changes a Store Verification item to `APPROVED`.

While Vendor Onboarding is incomplete or Store Activation has not occurred, the limited Dashboard exposes only functions needed to continue onboarding and manage the account. It provides:

- Store Profile.
- Store Account Settings.
- Continue Store Verification.
- Continue Store Setup.
- Review Pending Verification.
- Correct Changes Required.
- Review onboarding progress.

The Dashboard displays separate Store Verification and Store Setup checklists, overall onboarding progress, requirement level, status, pending verification, changes required, rejected or expired blockers, dedicated Continue actions, and current Store Activation status. It clearly states that the Vendor may continue permitted Store Setup work while Admin review is pending. Marketplace operations remain locked until Store Activation. Optional Team Account access follows the rule above.

### Vendor Activation Requirements

A Vendor is eligible for **Store Activation** only when every applicable mandatory activation requirement has its required successful final status:

1. The Vendor Owner account is active, the Owner email is verified, and the required Vendor Terms of Service and Vendor Code of Conduct are accepted.
2. Store Verification has been submitted.
3. All applicable mandatory Store Verification requirements are `APPROVED`, including required legal identity, Business Information, contacts, registered business address, Supplier Type/niches, Business Type-specific DTI/SEC/CDA evidence, LGU permit, BIR/TIN and applicable regulatory evidence.
4. No blocking Store Verification requirement remains `PENDING_VERIFICATION` or `CHANGES_REQUIRED`, and no mandatory item is `REJECTED` or `EXPIRED`.
5. The Vendor Tax Profile is in the applicable successful state under FIN-01 through FIN-12. TEST/DEMO evidence is never live registration or production approval.
6. All mandatory Store Setup requirements are `COMPLETED`, including Business Store Profile, Supplier and Bulk Order capability, fulfillment method, and other required operational configuration.
7. Delivery Configuration is `COMPLETED` when Vendor Delivery or Both is selected, and is `NOT_APPLICABLE` only when the condition does not apply because the Vendor selected Self-Pickup only.
8. Required Xendit xenPlatform sub-account onboarding is complete for this Vendor, with the required TEST/DEMO connection and capabilities confirmed. Xendit onboarding is mandatory for every Vendor seeking Store Activation and marketplace participation, regardless of Business Type. It does not prove live payment processing or production withholding responsibility.
9. Commission Terms have been accepted by the Vendor Owner as a versioned agreement, including the approved 2% Vendor-paid commission under FIN-03.
10. No blocking payment, refund, compliance, or administrative restriction remains; the Vendor is not suspended and is not under an administrative hold.

Team Accounts are optional and do not block activation. Product listing, product inventory, and product-level compliance submission are not prerequisites for Store Activation. Activation eligibility is evaluated by the backend and every activation, restriction, rejection, expiration, and restoration is recorded with the actor or system process, checklist result, rule version, timestamp, previous and new marketplace state, and reason.

### Store Activation and Marketplace Discoverability

**Store Activation** means that the Vendor organization has completed mandatory onboarding and may use the Vendor marketplace-management capabilities allowed by its account roles. Store Activation is separate from product publication and does not require an active product listing.

**Marketplace Discoverability** means that the activated Vendor is eligible to appear to Buyers as an offering Vendor in search, product discovery, recommendations, analytics counts, and supplier-discovery surfaces. An active Store with zero eligible active listings remains:

**Store Activation: Active**

**Marketplace Discoverability: No Active Listings**

The activated Store becomes discoverable only when the applicable marketplace conditions are satisfied, including:

- Store Activation remains active.
- At least one eligible and publishable product listing exists.
- Required inventory is available and not stale or otherwise restricted.
- Product-level compliance is approved where the material is regulated.
- Fulfillment and serviceability conditions for the discovery context are satisfied.
- No marketplace restriction blocks discovery.

Product-level PS Mark, ICC Sticker, or other required compliance still controls publication of the regulated listing. Store Activation must not be interpreted as approval or publication of every product. Listing and Product Compliance states remain distinct from Store Activation, Marketplace Discoverability, payment/Xendit status, and the Store Verification and Store Setup states.

---

**Vendor Marketplace Operations**

After activation, authorized users manage the store according to their fixed roles. Sensitive business, compliance, security, payment, or fulfillment-configuration changes may require recent authentication and administrative reverification. Existing obligations remain visible during a restriction when needed to complete orders, respond to disputes, or preserve evidence.

---

**Vendor Digital Storefront**

Tier 2 Vendors receive a digital storefront with active listings, public availability, service coverage, fulfillment methods, declared payment methods, verified compliance indicators, public ratings, and earned badges. Internal quantities, legal documents, private contacts, payment credentials, and employee account information are excluded.

**Dashboard Panel Overview**

**Performance Indicators** show CRR, order-processing time, Vendor-caused cancellation rate, return rate, on-time rate, and score eligibility. **Action Items and Alerts** show manual confirmation requests, auto-accept pauses, quotation and counter-offer deadlines, NRPC acceptance or flags, fulfillment tasks, inventory confirmation, compliance corrections, invoice requests, cancellation refunds, dispute-conclusion refunds, and system notices. **Detailed Panels** show gross sales records, order volume, storefront traffic, disputes, and product quality without presenting MateryalPH reports as official tax accounting.

**Navigation Topbar**

- Current page and Asia/Manila system date.
- Notifications.
- Accessible light or dark theme.
- Personal account and security settings.
- Sign Out.

Email changes require verification, notice to the previous email, session revocation, and audit. Vendor Owner and Store Manager security settings include TOTP and recovery-code management. Theme and notification preferences are per user, not per organization.

**Navigation Sidebar**

- **Store Operation**

  - **Orders**

**Flow**

1. An authorized user opens a combined Item-Based and Project-Based order list and filters by procurement type, state, date, Buyer, or Order ID.
2. A new request opens with Buyer information, CCS when eligible, line items, price snapshots, quantities, inventory, fulfillment preference, site details, payment preference, and project reference where applicable.
3. Within 24 hours, the Vendor confirms, rejects with a reason, proposes a permitted revision, or—only for an eligible Item-Based order without NRPC—allows the configured auto-accept transaction to confirm it.
4. Manual or automatic confirmation hard-reserves inventory and records the expected fulfillment or pickup date. For delivery, the Vendor confirms the vehicle, trip count, access feasibility, and final delivery fee.
5. A revision or NRPC proposal moves the request to Buyer approval. No payment or preparation may start until the Buyer accepts the latest commercial version and any NRPC Terms.
6. After full online payment is verified, an NRPC assurance payment is verified for COD or In-Store Payment, or an approved physical-payment method without NRPC is recorded, the order becomes `CONFIRMED` and may enter `PROCESSING`.
7. Fulfillment milestones update the shared order timeline. Physical quantity on hand is reduced only when the reserved stock is fulfilled, not when it is reserved.
8. A return, cancellation, cancellation refund, dispute, dispute-conclusion refund, invoice request, or rating remains linked to the same immutable order and line-item snapshots.

**Logic**

Order status follows the System Workflow: `AWAITING_VENDOR_CONFIRMATION`, `AWAITING_BUYER_APPROVAL`, `AWAITING_NRPC_ACCEPTANCE`, `AWAITING_PAYMENT`, `CONFIRMED`, `PROCESSING`, `READY_FOR_PICKUP`, `OUT_FOR_DELIVERY`, `DELIVERED`, `PICKED_UP`, `COMPLETED`, `CANCELLATION_REQUESTED`, `DECLINED`, `EXPIRED`, `CANCELLED`, and `DISPUTED`. Payment, refund, quotation, and dispute states remain separate.

Every line stores listing, variant, normalized unit, confirmed quantity, unit price snapshot, subtotal, applicable compliance reference, and inventory reservation. Listing-price changes never rewrite an order snapshot. Buyer-facing public stock status does not replace internal quantity validation.

MateryalPH calculates transaction arithmetic, the remittance withholding assessment and commission estimate through FIN-02–FIN-06. Vendor tax classifications are validated inputs; the system does not calculate the Vendor's full income/business-tax return or issue the Vendor's official invoice. Each Order Detail separates **Buyer payment breakdown**, **Vendor settlement/withholding**, **Monthly commission**, and **Vendor invoice**. The Buyer total is unchanged by Vendor CWT and platform commission. Authorized users can expand the computation to see source lines, VAT allocation, qualifying deductions, rate, threshold decision, expected receipt and reconciliation evidence. Unknown provider deductions show a review state, not an invented net payout.

**Conditions**

Vendor Owner, Store Manager, Customer Service Staff, and Store Staff may confirm or reject an order. Because a price, NRPC, or other commercial revision changes the amount payable, only the Vendor Owner, Store Manager, or Store Staff may publish it. Customer Service Staff may prepare a draft for an authorized publisher. Inventory Staff may correct inventory and manage permitted SKU auto-accept allotments but cannot accept the commercial order or set monetary safeguards. Fulfillment Staff may act only after confirmation and payment conditions are satisfied. A rejection requires a reason. Repeated unavailable-item confirmations or non-response affect only the applicable defined metric.

**Design**

The list shows Order ID, request time, response deadline, Buyer, procurement type, manual or auto-accepted source, state, payment state, refund state, NRPC indicator, total, assigned handler, and action. Order Detail shows line items, inventory, reservation, quotation or revision source, change summary, fulfillment, NRPC, payment, refund, history, evidence, messages, and related case or invoice records. Controls are role-aware, labeled, keyboard accessible, and confirmed before irreversible action.

### Item-Based

Item-Based is a filtered view of the shared Orders module. The Vendor reviews each requested line and may confirm all lines, reject the request, or propose available quantities. A partial revision recalculates the total and waits for Buyer acceptance. Confirmed quantities are reserved; cart quantities are not.

**Auto-Accept by Stock Threshold**

Auto-accept is optional, disabled by default, and configured per SKU or variant. Vendor Owner and Store Manager may enable or pause the feature, set the remaining stock allotment, and configure independent maximum unit-count and order-value safeguards. Inventory Staff may update the SKU or variant allotment but cannot change monetary safeguards or enable organization-wide authority. Store Staff and Customer Service Staff may view why an order was or was not auto-accepted but cannot modify the policy.

The Vendor-only configuration shows physical quantity on hand, hard-reserved quantity, available-to-sell quantity, soft-held quantity, auto-accept allotment remaining, unit cap, amount cap, pause reason, last editor, and last update. Internal quantities never appear to Buyers.

When an eligible Item-Based request arrives, the backend locks all affected inventory and configuration rows and rechecks the complete Vendor child order. Every SKU must have active allotment, adequate available stock, and compliant limits; the Vendor, listing, fulfillment method, and account must remain eligible; and NRPC must be disabled. If every check passes, the database transaction creates immutable accepted snapshots, creates hard reservations, reduces each allotment, records the automated actor and policy version, and moves an online order to `AWAITING_PAYMENT` or an eligible physical-payment order to `CONFIRMED`. If any check fails, no line changes and the whole child order is routed to manual review.

When an allotment reaches zero, that SKU or variant pauses immediately and sends an in-app notification and email to the permitted Vendor users. Replenishing stock or releasing a reservation does not resume it. An authorized user must review the internal quantity and deliberately resume auto-accept. An auto-accepted online order expires after 45 minutes if payment is not verified; the hard reservation is released and any restored allotment remains paused when it previously reached zero. Repeated unpaid attempts are rate-limited and flagged without automatically penalizing a legitimate Buyer.

An order that needs NRPC always bypasses auto-accept. The Vendor must manually review the request, enter the NRPC amount and reason, and obtain Buyer acceptance before preparation.

Auto-accept additionally requires validated price-tax classifications and current fee Terms. The order-value safeguard uses the Buyer commercial total including applicable materials VAT and delivery, before channel-specific processor fees. Missing monetary classification routes the complete order to manual correction without reservation or payment. CWT and commission are not subtracted to make a large order appear below the safeguard.

### Project-Based

Project-Based displays **Quotation Inquiries**, **Package Requests**, and **Project Orders**, not a broadcast RFQ bidding queue. The system first compiles estimates from active listings. A Buyer may then open an inquiry with any Vendor displayed in the result list. Only the contacted Vendor receives that inquiry.

The inquiry contains two records: the Buyer's immutable locked Work Package and the Vendor-editable working duplicate. The Vendor may use its duplicate to propose product matches, substitutions, specifications, quantities, units, prices, delivery method, payment method, vehicle or trip count, expected fulfillment date, and NRPC. Every change stores before-and-after values and appears to the Buyer in a plain-language comparison. The system estimate remains a separately labeled baseline and is never overwritten.

The Vendor publishes an immutable quotation version with a Buyer-response deadline. The default is 24 hours and the permitted range is 1–72 hours. Editing after publication creates a new version, invalidates the previous version, resets the exact displayed deadline, and requires the Buyer to review again. The Buyer may accept, reject, or counter. A counter-offer releases soft holds and gives the Vendor 24 hours to revise and republish. The **Delete Quotation** action is available only before acceptance and records `WITHDRAWN`; it does not physically erase the quotation or audit events.

Published lines create planning-only soft holds. They do not block Item-Based auto-accept stock. When the Buyer accepts, the backend atomically verifies every line. Insufficient stock creates `STOCK_REVALIDATION_REQUIRED`, makes no reservation, and prevents payment until the Vendor republishes. Successful acceptance creates hard reservations, assigns the Work Package to the Vendor, and expires other active Vendor quotations for that Work Package. Conversation records remain available.

When the Buyer selects the Vendor directly from a system estimate, the Vendor receives a package request containing the locked Work Package, optional informational Note, system price snapshots, site, fulfillment preference, projected delivery fee, and 24-hour response deadline. The Note requires no separate Vendor action. The Vendor manually confirms availability, final delivery arrangement, expected fulfillment date, final amount, and any NRPC, or proposes a permitted revision. Project-Based procurement never uses auto-accept.

Project-Based access requires Bulk Order Capability. Turning that capability off prevents new matches but does not cancel confirmed obligations.

- **Fulfillment**

**Flow**

1. Authorized users view confirmed orders that require preparation.
2. For Self-Pickup, the Vendor prepares the order, marks `READY_FOR_PICKUP`, sends the notice, and records handover with timestamp and Buyer or authorized-receiver confirmation.
3. For Vendor Delivery, the Vendor assigns the confirmed vehicle or trips, marks `OUT_FOR_DELIVERY`, and records delivery with photo, timestamp, receiver name, and optional signature.
4. The order moves to `DELIVERED` or `PICKED_UP` and waits for Buyer confirmation.
5. After two calendar days and required reminders, the system may auto-confirm unless a dispute is open.

**Logic and Conditions**

The vehicle recommendation excludes configurations that cannot meet capacity, distance, or confirmed site-access requirements. Multiple trips are supported only when disclosed and accepted before payment. A fulfillment proof record is mandatory. Real-time GPS tracking is outside scope.

Only Fulfillment Staff, Store Manager, and the Owner may update fulfillment milestones, record handover, or upload delivery proof. Store Staff may view the fulfillment state needed for customer support or inventory coordination but does not perform fulfillment duties.

- **Messages**

**Flow**

1. A Buyer starts a conversation from a product, Vendor profile, order, or Project-Based comparison.
2. It is assigned to the designated Customer Service Staff or Store Staff; if none is configured, it routes to the Owner.
3. The responder becomes the current Message Handler.
4. The Buyer may ask an ordinary question or initiate an Item-Based or Project-Based quotation request.
5. An authorized user may transfer the conversation. All prior sender and handler history remains unchanged.
6. At `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`, Fulfillment Staff may receive a linked delivery-coordination thread without taking ownership of the original sales conversation.

The Buyer sees the store logo and name plus the current staff handler's avatar, display name, and role. Personal email, login identifier, and private number remain hidden. A transfer creates a visible system message. Store Manager and Owner may monitor all conversations; a monitoring view does not change the Handler unless the viewer replies or explicitly takes ownership.

Customer Service Staff, Store Staff, Store Manager, and Owner may handle sales conversations. Fulfillment Staff may use only the linked fulfillment thread. Conversation access and every message are checked and attributed server-side.

**Order-from-Chat**

The Vendor may create a formal quotation from an eligible message thread. Item-Based quotations use the product or cart reference. Project-Based quotations use the Buyer's locked Work Package and Vendor-editable duplicate. Both use the same service and differ only through the stored procurement-context flag.

The quotation builder requires product or material lines, specifications, quantity, unit, unit price, fulfillment method, payment method, expected fulfillment date, and response deadline. Site Delivery also requires the system-suggested vehicle type and trip count to be confirmed or replaced with a valid configured alternative. The system calculates line subtotals, delivery fee, NRPC designation within the order value, Payment Processing Fee where applicable, Amount Due Now, later physical-payment balance, and total.

Each published line also records the tax category, inclusive price, discount allocation and included VAT under FIN-02. The Vendor sees a separate estimated completion commission and withholding preview with an **Estimate — finalized at remittance** label. The preview never promises threshold relief or current net cash. Editing price, discount, tax category, fulfillment fee or NRPC creates a new quotation version with a readable Buyer change summary and renewed acceptance. Item-Based and Project-Based quotations call the same financial service.

NRPC is disabled by default. Only Vendor Owner, Store Manager, or Store Staff may enter and publish its amount, affected lines, and required reason. Customer Service Staff may prepare a quotation draft but cannot publish a monetary change. The Vendor determines the order-specific NRPC amount; there is no platform-wide numeric cap, but the amount cannot exceed the eligible prepared-material subtotal, must reflect actual irreversible preparation, and remains subject to Buyer acceptance, evidence, flagging, and Admin review. Any NRPC quotation requires manual handling and cannot use auto-accept.

Publishing creates an immutable quotation version and soft holds. The Buyer sees the exact deadline and plain-language changes from the attached source. A later edit creates a new version, resets the deadline, and makes the prior version unacceptable. Rejection, counter-offer, expiry, or Vendor withdrawal releases soft holds immediately. Acceptance performs the atomic stock check and creates hard reservations only when all lines remain available.

Every quotation event uses the shared audit and notification layer: creation, draft edit with before/after values, publication, view, counter-offer, acceptance, rejection, expiry, withdrawal, inventory validation, order creation, actor, role, and timestamp. The Vendor may withdraw an unaccepted quotation but cannot erase it from the audit record.

- **E-Invoices**

The module tracks required Vendor invoice records as well as Buyer copy/correction requests. In production the Vendor issues the appropriate invoice through its registered process when legally due, even without a Buyer request or completed-order status, and may upload a copy once issued. MateryalPH records transaction calculations but does not assign official Vendor invoice numbers or issue that invoice. In TEST every sample is labeled DEMO. FIN-09 distinguishes an uploaded PDF from compliance with structured electronic invoicing and records applicable taxpayer coverage/deadlines.

The request records `REQUESTED`, `UPLOADED`, `DOWNLOADED`, `RETURNED_FOR_CORRECTION`, or `CLOSED`. The service target is three business days after the request and never extends a stricter legal deadline. A later refund may require the Vendor to upload the legally appropriate adjustment document according to current BIR rules; the system must not invent a “credit note” requirement without confirmation of the applicable document.

Vendor Owner, Store Manager, and Store Staff may upload. Customer Service Staff may view request status and communicate with the Buyer but cannot upload the official file unless the role definition is formally changed. The PDF, invoice number, invoice date, uploader, timestamp, and related order are audit-logged.

Invoice records also store issuer, document type, applicable tax breakdown, related lines, source system, sample/live origin and amendment references. The system compares the uploaded invoice's totals with the accepted order. A difference creates `INVOICE_RECONCILIATION_REQUIRED` for explanation/correction; it never retroactively charges the Buyer. Vendor goods invoices, platform service bills, processor invoices and Form 2307 certificates use separate record types. The Vendor remains responsible for its own tax returns and supported withholding-credit claims.

- **Notifications**

Notifications include order requests, response deadlines, Buyer revisions, verified payments, fulfillment deadlines, messages, disputes, compliance correction, document expiry, stale inventory, invoice requests, Xendit connection health, and platform notices. Routine updates use in-app or push delivery; important records use email. No SMS provider is used.

Users may configure optional categories per channel, but mandatory security, legal, suspension, payment, and dispute notices cannot be disabled. A notification deep-links only to a resource the recipient is authorized to access.

Finance notices add declaration review/due date, threshold crossing, tax adjustment, certificate availability, reconciliation exception, monthly statement issue/due/overdue and fee-credit status. Notify the Owner and permitted Manager; general staff do not receive attached private tax evidence.

- **Disputes**

A transaction dispute may be opened from `PROCESSING` onward. A post-completion return or dispute must be filed within seven calendar days after `COMPLETED`, subject to any non-waivable legal right. The Vendor may respond to an eligible Buyer case, submit evidence, offer replacement or voluntary refund, reject with evidence, or request Admin review. The response window is 48 calendar hours. If a response is filed, the parties have 72 calendar hours to confirm a mutual resolution. Unresolved or unanswered cases escalate to Admin. A requested clarification has a 24-hour response window. One appeal may be filed within five business days with new relevant evidence.

Customer Service Staff and Store Staff may manage the response when dispute handling is enabled by the Owner. The Owner may require all disputes to route to the Owner. Store Manager may act. Fulfillment Staff may contribute fulfillment evidence but cannot decide a commercial remedy. Only the Owner may initiate a voluntary financial refund, unless the backend executes a documented Admin decision through the supported Vendor sub-account process.

Filing a dispute does not create a refund. When a concluded dispute awards a full or partial refund, the backend automatically creates the idempotent Dispute-Conclusion Refund instruction linked to the Case ID. Its online portion uses the original payment and verified provider states; its cash portion uses the separate evidenced Vendor reimbursement under FIN-07. The online portion remains `REFUND_PENDING` until authoritative evidence produces `PARTIALLY_REFUNDED`, `REFUNDED`, or `REFUND_FAILED`. A cash-only case never waits for a nonexistent Xendit refund webhook.

**Cancellation and NRPC**

The Buyer may withdraw before Vendor confirmation and may request cancellation with a valid reason from `CONFIRMED` through `PROCESSING`. Cancellation is unavailable at `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`; the Buyer may still use applicable dispute, return, warranty, and statutory remedies. A Vendor cancellation requires a reason at any nonterminal stage and records the responsible actor.

When cancellation of an already-paid order becomes final, the backend automatically initiates the separate Cancellation Refund. Vendor-caused cancellation forfeits every NRPC claim, refunds all Buyer-paid order amounts, releases the reservation, and contributes to NFR. An eligible Buyer-caused cancellation during `PROCESSING` may retain the accepted NRPC only when the Vendor submits evidence of the actual irreversible preparation. For COD or In-Store Payment, the online NRPC assurance payment is the refundable source; for full online payment, the refund amount is calculated from the paid order total.

NRPC cannot be retained for Vendor fault or for defective, incorrect, unsafe, misrepresented, or nonconforming goods. It is not a standard cancellation fee and is not added on top of the agreed order value. A Buyer flag does not automatically block an accepted order, but it creates an Admin review record and preserves the objection separately from acceptance.

FIN-07 governs the financial consequences. No commission is earned on cancellation or retained NRPC; an earlier fee record is reversed through a referenced credit. Previously withheld tax opens a separate adjustment review and does not reduce the Buyer refund. For physical cash already collected, the Vendor must fulfil and evidence the reimbursement separately from the online NRPC refund. A refund of an uncollected cash balance is prohibited. Insufficient provider funds create a visible refund exception and Owner action; they never count as successful Buyer reimbursement.

- **Store Management**

  - **My Products**

**Flow**

1. An authorized user selects **Store → My Products → Add Product** and enters the material name.
2. The system normalizes the name, performs exact alias and `pg_trgm` fuzzy matching, suggests a canonical category and read-only platform code, and permits reviewed unmatched names.
3. The user selects one to three approved search tags.
4. The user enters display name, brand, manufacturer name and address, country of manufacture, description, unit, Vendor SKU, base price, internal quantity, public availability, base weight, and base dimensions.
5. Optional variants define their own attributes, price modifier, weight, dimensions, and inventory.
6. Category-specific technical fields are loaded.
7. At least one general product photo is uploaded.
8. A regulated product completes the applicable PS/ICC evidence path.
9. The listing moves to the applicable status.

**Listing Statuses**

`DRAFT`, `PENDING_COMPLIANCE`, `PENDING_ADMIN_REVIEW`, `ACTIVE`, `INACTIVE`, `TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED`, and `REJECTED` are distinct states. An Out-of-Stock listing is excluded from discovery and matching. A regulated listing cannot become Active until the applicable compliance submission is verified.

**Conditions**

Vendor Owner, Store Manager, Store Staff, and Inventory Staff may create and edit listings. Vendor Owner, Store Manager, Store Staff, and Inventory Staff may submit PS/ICC evidence. Customer Service Staff and Fulfillment Staff cannot change product, price, inventory, or compliance data.

Manufacturer, certification, or required marking changes return an active regulated listing to compliance review. The last approved information remains in history and the public verified indicator is withheld until review succeeds.

- **Vehicles**

The Owner or Store Manager may add, update, deactivate, or remove future-use vehicle configurations. Fulfillment Staff may view and assign an eligible vehicle to an order but cannot change fees, capacity, or service coverage. Existing order snapshots remain intact after configuration changes.

- **Transaction History**

Transaction History replaces the former Wallet module. It is a read-only MateryalPH record of full-order payments, NRPC assurance payments, verified payment events, Buyer processing fees, Cancellation Refunds, Dispute-Conclusion Refunds, compensating refunds after reconciled technical failure, COD records, and In-Store Payment records. It does not display or control a MateryalPH balance. A link may direct the Owner to the authorized Xendit dashboard for balance and withdrawal management.

The Owner and Store Manager may view store-wide records. Other staff see only payment status required for their assigned order and never payout credentials or full financial reports.

Within Transaction History, tabs are **Payments**, **Physical receipts**, **Remittances and CWT**, **Commission statements**, **Refunds and adjustments**, and **Tax documents**. These extend the existing sidebar item and do not create a wallet. Each row exposes environment, order/statement reference, gross amount, applicable deductions, net amount, evidence origin, status and drill-through audit trail.

The commission tab shows estimated versus earned fees, unbilled items, disputed items, approved statements, due dates, payments and credits under FIN-03. The Owner may accept Terms, question a line with evidence and pay a positive issued statement. The Manager can inspect and prepare a dispute but cannot authorize the fee payment. A successful payment requires a verified Xendit TEST event or a distinctly labeled simulation. One statement cannot be paid twice; duplicate or late captures enter reconciliation and compensation review.

The CWT tab shows the effective profile, tax year, documented local/outside-platform threshold position, computation and responsible entity/scenario. It distinguishes assessed, simulated withheld, provider-reported, reconciled, adjustment required and certificate availability. A tax export is not proof that tax was remitted. Tax documents retain the actual/sample issuer; the platform does not replace a provider's name with MateryalPH. Declarations, certificates and export downloads require organization authorization and create audit events.

- **Vendor Team Accounts**

  - **Team Accounts**

**Flow**

1. The Owner opens Team Accounts and invites an employee.
2. The Owner enters name, email, contact number where required, and one fixed role.
3. For a Store Manager, the Owner decides whether to enable **Manage Staff Accounts**. The toggle is off by default.
4. The employee accepts the expiring invitation and creates or connects an individual account.
5. The membership becomes active and the employee sees only permitted features.
6. The Owner may change the fixed role, revoke delegation, suspend, deactivate, or remove the membership.
7. A delegated Store Manager may manage only the four non-manager staff roles. Every action notifies the Owner.

Invitation, acceptance, role, delegation, suspension, reactivation, and deactivation are audit-logged. Historical attribution remains after deactivation. Access loss is enforced on the employee's next request and active sessions are revoked.

  - **Team Tracking**

The Owner and Store Manager may view authorized organization activity. Other employees see only their own relevant activity. Records include actor, role at the time, action, affected resource, previous and new value where appropriate, timestamp, result, and correlation reference. No Vendor user may edit or delete an audit entry.

- **Analytics**

  - **Store Performance**

Store Performance displays VPS, VCS, MQS, OHS, CRR, FRR, eligibility counts, and metric windows exactly as defined in the System Workflow. Scores below their sample threshold display **New Vendor — Building Track Record**. The portal does not maintain a second formula or threshold set.

The Owner and Store Manager may view store-wide performance. Store Staff, Customer Service Staff, Inventory Staff, and Fulfillment Staff see only role-relevant operational measures or their attributed activity.

- **Materials Analytics**

Vendor Owner and Store Manager open **Analytics → Materials Analytics** under `materials_analytics.view_competitors`; all other Vendor roles are denied by backend policy. The view defaults to the organization's verified store location and 50 km, with approved smaller radius options. It provides categorized material/specification/variant rows, 7/30/90-day or custom-date filters, daily competitor averages, trend graphs/tables, capture time and the Vendor's own comparable price in a separate column.

The shared MAT-01–MAT-07 service excludes the requesting organization, then requires three distinct competing Vendors at every displayed point/variant/endpoint. Below that threshold show Insufficient Competitor Data, no number and no exact sub-threshold count. Do not show individual offers, store names, IDs, logos, locations, links, per-offer timestamps or other identifying response/export fields. Authorized users can inspect a material's specifications and aggregate variants, but cannot open competitors through this analytics page. Graphs use gaps for suppressed/missing data. A Buyer-visible material detail response cannot be requested using a Vendor session.

The purpose is manual price planning. An **Edit My Listing** action is offered only when the current user also has the existing listing-edit permission and the organization owns the listing. It opens the normal editor; explicit confirmation creates an audited price version. Analytics never changes a price, infers a competitor's quantity or exposes a private quotation. Show the daily average time separately from the current own-listing time and note when participation changed. Use DEMO — Simulated Marketplace Data for fixtures. Server responses, downloads, chart tooltips and caches enforce the same restrictions; public Buyer browsing is outside this interface's confidentiality guarantee.

The Owner/Manager can encounter loading, empty, not-yet-comparable, insufficient history/competitors, stale, offline and denied states. Retry is read-only and never updates prices. Store Performance and Earnings remain separate analytics sections; tax and commission continue to follow FIN-01–FIN-12 rather than market-price estimates.

  - **Earnings**

Earnings follows FIN-11 and displays commercial sales, included transaction VAT, returns, online collections, recorded physical collections, processor charges, CWT credit records, earned commission, unpaid fee statements and estimated cash receipts separately. Withholding is not recorded as a reduction of sales or a platform commission. Cash receipts do not equal taxable income. These operational computations and exports support reconciliation but do not replace the Vendor's accounting books, official tax returns or registered invoicing process. Demo aggregates are visibly TEST-only.

The Owner and Store Manager may view store-wide earnings. Other staff do not receive store-wide revenue access. Reports may be exported as CSV or spreadsheet with an **Internal Operational Report — Not a Tax Invoice** notice.

- **Store Profile (Vendor Owner) / Staff Profile (Vendor Team Accounts)**

**Vendor Owner**

The Owner sees Public Store Profile, Business Information, Business Documents, Fulfillment Configuration, Payment Connection, Security, and Staff. Public-profile changes save after validation. Legal-business, address, compliance, or payment changes may require recent authentication and reverification. A field with an active review cannot be overwritten without closing or replacing the prior submission through a documented action.

**Vendor Team Account**

The Staff Profile contains:

- Staff profile picture, editable by the employee.
- Name, pre-filled from the account.
- Position or fixed role, read-only to the employee.
- Account creation date, read-only.
- Store membership, read-only.
- Personal security and notification preferences.

The Staff Profile does not edit the Vendor's public Business Store Profile. Buyer-facing communication may display the staff avatar, display name, and role beside the store identity. The employee cannot change the role or store membership.

---

### Vendor Team Account Management

## Vendor Owner (Main Store Account)

The Owner has full organization control and access to PS/ICC submissions. The Owner creates Store Managers and other staff, monitors all activity, configures auto-accept and its safeguards, publishes quotations and NRPC terms, retains payout and legal-business authority, and remains the highest-level account.

## Store Manager (Delegate Role)

The Store Manager has broad operational visibility and may manage conversations, order confirmation, quotation publication, order-specific NRPC, auto-accept configuration, listings, inventory, compliance, fulfillment, disputes, and reports. The Manager cannot transfer ownership, edit payout credentials, delete logs, delete the organization, change legal ownership, or grant delegation. Staff management is available only when the Owner enables the dedicated flag.

## Employee Roles

### Store Staff

Store Staff combines Customer Service Staff and Inventory Staff functions, including order confirmation, messages, quotation publication, order-specific NRPC within the governing rules, permitted disputes, listings, internal inventory, price changes, and PS/ICC submissions. It may view auto-accept outcomes but cannot enable the feature or change its organization-level monetary safeguards. It excludes delivery dispatch, handover, and delivery-proof duties.

### Customer Service Staff

Customer Service Staff monitors and confirms unchanged order requests, views stock necessary for confirmation, handles inquiries and assigned sales, prepares quotation drafts, and manages disputes when enabled. It cannot publish a quotation or commercial revision, set NRPC, change listings, prices, inventory, auto-accept configuration, compliance, fulfillment proof, or financial configuration.

### Inventory Staff

Inventory Staff manages listings, internal stock, variants, permitted prices, SKU or variant auto-accept allotments, and PS/ICC evidence and corrections. It cannot enable auto-accept, set its monetary safeguards, publish quotations, set NRPC, confirm commercial orders, communicate as the sales handler, update fulfillment, or access store-wide earnings.

### Fulfillment Staff

Fulfillment Staff prepares assigned confirmed orders, records fulfillment milestones and proof, assigns an approved vehicle, and communicates through the linked delivery thread or an approved telephone call. It cannot alter prices, inventory definitions, compliance, payment settings, or commercial refunds.

## Restricted Actions

No employee, including Store Manager, may transfer ownership, access another Vendor, delete audit history, create another Vendor organization under the membership, edit payout credentials, change their own role, or grant access beyond the fixed delegation rule. Only the Store Manager may view store-wide operations and earnings; specialized staff remain restricted to their scope.

## Attribution Rules

Every action records the actual user who performed it. The system never attributes a staff action only to the store. The Owner's monitoring view is recorded separately and does not change operational ownership.

### Sales Attribution

An order is attributed to the Customer Service Staff or Store Staff who handled the accepted inquiry or was explicitly assigned as sales owner. Direct Owner or Store Manager actions are attributed to that person. Inventory-only or fulfillment-only work does not become sales attribution.

### Message Attribution

The current Message Handler is the authorized person who claims, is assigned, or replies to the conversation. A transfer changes the current Handler but preserves prior actions and senders. The fulfillment thread is linked but remains separately attributed.

### Inventory Attribution

Each listing, quantity, reservation, stock movement, variant, price, and compliance change stores the actor and before-and-after value. Concurrent changes use transactional validation and cannot silently overwrite a later revision.

### Fulfillment Attribution

Each preparation state, vehicle assignment, dispatch, handover, delivery proof, receiver, and timestamp identifies the employee who recorded it.

## Off-Platform Communication Logging

An approved delivery-coordination telephone call records employee, order, channel, and timestamp without recording call content. The Vendor must not use this log to imply that the platform captured or verified the conversation.

## Employee Lifecycle

The Owner may deactivate any employee, including a Store Manager. A delegated Store Manager may deactivate only permitted non-manager staff. Deactivation revokes sessions and access but preserves historical attribution. Reassignment of unfinished work identifies both the former and new responsible users.

---

**Inventory and Stock Visibility Strategy**

The Vendor maintains exact internal quantities while Buyers see only `In Stock`, `Limited Stock`, or `Out of Stock`. Internal inventory includes quantity on hand, hard-reserved quantity, available-to-sell quantity, soft-held quantity, auto-accept allotment, reorder level, and movement history. Units Sold is displayed only from completed eligible orders.

Cart placement does not reserve stock. A published quotation creates only a soft hold, which informs the Vendor of projected demand but does not reduce saleable stock or the auto-accept pool. Manual confirmation, eligible Item-Based auto-accept, or quotation acceptance creates a hard reservation through row-level locking and an all-or-nothing database transaction. Rejection, counter-offer, quotation expiry or withdrawal, payment expiry, approved quantity reduction, or cancellation releases the applicable hold or reservation.

`available_to_sell = quantity_on_hand − hard_reserved_quantity`. Delivery or pickup reduces physical quantity on hand and the matching hard reservation in one transaction. An auto-accept action reduces its separate allotment but does not falsely record physical stock as sold. All configuration, hold, reservation, release, adjustment, and fulfillment movements record the source, actor or automated policy, before/after values, order or quotation, and timestamp.

- **Behavioral Nudge System — Keeping Listings Fresh**

The Vendor may configure an in-app, push, or email reminder time. Day 7 and Day 12 reminders warn that confirmation is required. After 15 consecutive days without stock confirmation, the listing becomes `TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED`. It is not called an account suspension. A valid stock confirmation restores eligibility immediately unless another restriction applies. No SMS reminder is sent.

**Vendor Material Listing, Inventory, and Compliance Quality Assurance**

Product data is divided into a product definition, Vendor listing, variants, inventory, price snapshots, media, and compliance submissions. This prevents inventory changes from rewriting technical or compliance history. Bulk spreadsheet updates validate every row, return row-specific errors, and apply only validated changes through an auditable import job.

### Enhanced Compliance Verification (Three-Path Input)

For a DTI-BPS regulated material, the authorized Vendor user selects:

- **Path A — Photo or Camera Capture.** The user captures the physical PS Mark, ICC sticker, or required marking. OCR proposes values for review.
- **Path B — QR Code Scan or Upload.** The system decodes an available QR payload or verification reference and retains the image as evidence.
- **Path C — Manual Entry.** The user enters the applicable number and manufacturer or importer information and must attach a clear physical-marking photo.

All paths converge on **Review and Confirm**. OCR and QR results remain editable because extraction is assistance, not proof. The backend validates required fields and compares them with the configured current official source where available. A match may produce `VERIFIED`; an uncertain or unavailable match produces `PENDING_ADMIN_REVIEW`, not an accusation of counterfeiting. Admin may approve, return for correction, or reject with a reason.

Only the applicable PS, ICC, or other required marking is requested. The system does not assume every regulated material uses the same certification. Public badges show limited verified information and never expose private documents unnecessarily.

### Official Verification References

- [DTI-BPS PS and ICC Marks](https://bps.dti.gov.ph/product-certification/ps-and-icc-marks)
- [DTI-BPS Products Under Mandatory Certification](https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification)

Official DTI-BPS sources remain authoritative. MateryalPH verification is an operational marketplace control and not a replacement for government enforcement or professional product testing.

---

- **Store Operation**
  - Orders
  - Fulfillment
  - Messages
  - E-Invoices
  - Notifications
  - Disputes
- **Store Management**
  - My Products
  - Vehicles
  - Transaction History
  - Vendor Team Accounts
    - Team Accounts
    - Team Tracking
- **Analytics**
  - Store Performance
  - Materials Analytics (Vendor Owner and Store Manager only)
  - Earnings
- **Store or Staff Profile**

---

Tax and fee source references are maintained with FIN-01–FIN-12 in [the System Workflow](MateryalPH_Final_System_Workflow.md). The reviewed legal baseline includes RR No. 16-2023 as amended by RR No. 5-2025, RMC No. 8-2024, RMO Nos. 18-2025 and 26-2025, RMC No. 55-2026, and the applicable invoicing issuances. Operational dates and external requirements must use the same versioned source register across all portals.

### Future Enhancements

Multi-branch management, custom Vendor roles, a Vendor RFQ bidding queue, live GPS tracking, MateryalPH wallet or escrow, automated tax-invoice issuance, and construction-vehicle rental are outside the current capstone scope.
