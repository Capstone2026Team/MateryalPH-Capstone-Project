# MateryalPH Store Verification and Store Setup — Build Specification

**Place at:** `docs/workflows/Vendor_Onboarding_Store_Verification_and_Store_Setup.md`
**Authority:** this file is the field-level and layout-level expansion of the Final Vendor Workflow §Vendor Onboarding and the Final Admin Workflow §Vendor Verification and Activation. Where this file and a Final Workflow disagree on *behavior*, the Final Workflow wins. Where they disagree on *field lists, layout, or step grouping*, this file wins because it is the later approved arrangement.
**Supersedes:** the five-step Store Verification arrangement. Tax Information is now inside Business Information. Store Verification has **four** steps; Store Setup has **six**.

Read together with: `AGENTS.md`, `docs/architecture/MateryalPH_Technical_System_Design.md` §12.5 and §13.2, `docs/architecture/MateryalPH_Technical_Design_Delta_FIN-04A_Withholding_Threshold.md`, `docs/design/MateryalPH_UI_UX_Implementation_Planner.md` §14–§17, `DESIGN.md`.

---

## 1. Why this document exists

Onboarding is the one surface where legal identity, private evidence, tax status, authority to bind an organization, map geography and Admin review all meet. It fails when it is built as "a long form." It must be built as **a requirement registry with a UI on top**. Every screen below renders server-derived requirement state; no screen decides whether the Vendor may submit or activate.

Three separations must never collapse:

1. **Public Store identity ≠ legal business identity.** `store_name` and `legal_business_name` are different columns and neither overwrites the other.
2. **Account access ≠ legal authority.** Being the Vendor Owner account holder does not make a person an authorized signatory for an organization.
3. **Store Verification ≠ Store Setup ≠ Store Activation ≠ Marketplace Discoverability.** Four independent states, four independent evaluations.

---

## 2. State model

**Workstreams.** `STORE_VERIFICATION` and `STORE_SETUP` progress independently. Store Setup may start, continue and reach `COMPLETED` while Store Verification is `PENDING_VERIFICATION`, `CHANGES_REQUIRED`, `REJECTED` or `EXPIRED`. Store Setup completion never changes a verification item to `APPROVED`.

**Requirement Level** — `REQUIRED`, `OPTIONAL`, `CONDITIONALLY_REQUIRED`.
**Requirement Status** — `NOT_STARTED`, `IN_PROGRESS`, `SUBMITTED`, `PENDING_VERIFICATION`, `APPROVED`, `COMPLETED`, `CHANGES_REQUIRED`, `REJECTED`, `EXPIRED`, `NOT_APPLICABLE`.

Level and status are independent columns. `NOT_APPLICABLE` is valid only for a `CONDITIONALLY_REQUIRED` item whose documented condition does not apply, and must carry an applicability reason. It can never mask an incomplete `REQUIRED` item. A document's metadata **Expiration Date: Not Applicable** is a different concept from the status `NOT_APPLICABLE`.

**Transitions.**

```
NOT_STARTED → IN_PROGRESS → SUBMITTED → PENDING_VERIFICATION → APPROVED
                                              ↓                    ↓
                                      CHANGES_REQUIRED          EXPIRED
                                              ↓                    ↓
                                          SUBMITTED  ←──────── (replacement)
                                              ↓
                                          REJECTED
```

Non-reviewed Store Setup items go `NOT_STARTED → IN_PROGRESS → COMPLETED`.

**Who may move what.** The Vendor may reach `SUBMITTED`. The system computes `PENDING_VERIFICATION`, `EXPIRED` and all aggregates. Only an authorized Admin sets `APPROVED`, `CHANGES_REQUIRED` or `REJECTED`, always with an actor, timestamp, reason and audit reference. `CHANGES_REQUIRED` and `REJECTED` require a non-empty reason.

**Activation gate.** A single backend service evaluates the ten activation conditions in the Final Vendor Workflow. The UI only renders its result and its blocking list. There is no client-side activation logic and no Admin frontend override of a missing mandatory requirement.

---

## 3. Step architecture

### Store Verification — 4 steps

| # | Step | Contains |
| --- | --- | --- |
| V1 | Business Information | Business Type · Registered Legal Identity · Government ID · Authorized Representative and Authority to Act · Public Store Name · Legal Business Name · Date of Establishment · Store Email · Store Phone · Primary Business Contact · Tax Information (TIN, VAT, BIR COR, Sworn Declaration) · Business and Compliance Evidence |
| V2 | Registered Business Address | Manual structured entry · interactive map selection · coordinates · review before save |
| V3 | Supplier Type / Classification | Supplier Type · canonical niches · custom Other labels · rental prohibition |
| V4 | Privacy, Review and Submit | Privacy Notice acknowledgment · full requirement summary · unsaved-change detection · submit |

### Store Setup — 6 steps

| # | Step | Contains |
| --- | --- | --- |
| S1 | Public Store Profile | Logo · banner · description · public contact · city/province summary · Store Media subsection · live marketplace-style preview |
| S2 | Fulfillment Configuration | Bulk Order Capability · Self-Pickup / Vendor Delivery / Both · delivery coverage · vehicle fields when applicable |
| S3 | Xendit TEST Connection | xenPlatform sub-account onboarding, captured provider link, sub-account reference, backend reconciliation |
| S4 | 2% Commission Terms | Versioned agreement, Owner or authorized signatory acceptance |
| S5 | Team Accounts | Optional; explains the existing post-setup invitation route |
| S6 | Review and Complete | Setup summary, unsaved-change detection, completion |

### Navigation contract

- Only the selected step is visible **and** keyboard reachable. Other steps are removed from the accessibility tree, not merely hidden visually.
- Switching steps preserves native form values in memory; it never auto-saves.
- `Save Draft` persists through the existing request builders with the current `lock_version`. `Finish Later` saves and returns to the limited Dashboard.
- Unsaved edits are listed on V4/S6 and must be saved before submission or completion.
- Privacy acknowledgment and commission choices persist in memory across step changes; only the final endpoints record them.
- Changing Business Type re-evaluates conditional identity fields **before** the next save.
- The address map initializes only when V2 is the selected step.
- Completion indicators are server-derived. The stepper never marks a step complete from client state.

---

## 4. Layout architecture

### 4.1 Page frame

```
┌────────────────────────────────────────────────────────────────────┐
│ ← Back to dashboard                                    (quiet link)│
│                                                                    │
│ Store Verification            ┌───────────────┬──────────────────┐ │
│ Pending verification · 6 of 9 │ Store         │ Store Setup      │ │
│ Complete your business…       │ Verification  │                  │ │
│                               └───────────────┴──────────────────┘ │
├────────────────────────────────────────────────────────────────────┤
│ Step 3 of 4 · 2 requirements need attention          (metadata)    │
│ ──────────────────────────────────────────────────── (subtle rule) │
│  ①  Business      ②  Registered    ③  Supplier     ④  Privacy,    │
│     Information      Business          Type /          Review      │
│                      Address           Classification  and Submit  │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│   [ selected step content — one surface, sections divided by       │
│     headings and 1px rules, not by nested cards ]                  │
│                                                                    │
├────────────────────────────────────────────────────────────────────┤
│ Finish Later                          Save Draft   Continue →      │
└────────────────────────────────────────────────────────────────────┘
```

- `Back to dashboard` precedes the title as a quiet navigation link. Title, status and description share one left alignment.
- The two workstream buttons form a compact paired control on the right at ≥1024px and reflow together beneath the title below that. There is no full-width workstream strip and no second header divider.
- The stepper uses equal-width desktop columns, 32px number circles, evenly padded equal-height steps, 14px labels that wrap naturally, a pale orange surface plus underline for the current step, and no horizontal scrolling, scrollbar or arrows at any width.
- The requirement checklist lives in the final review step, not in a permanent side column.

### 4.2 Section pattern inside a step

One surface. Sections are introduced by an H2, an optional one-line description and a subtle divider. Prefer spacing and rules over another card. One dominant filled action per decision area.

### 4.3 Grid

| Breakpoint | Behavior |
| --- | --- |
| ≥1280px | Content column max 1120px, centered. Two-column field rows. |
| 1024–1279px | Two-column field rows, reduced gutters. |
| 768–1023px | Two-column only where both fields are short; otherwise single column. Stepper wraps to two rows. |
| <768px | Single column. Stepper becomes a wrapped row of equal-height chips. Action bar becomes full-width stacked buttons. |
| 320px | No horizontal page overflow and no stepper overflow. This is a hard test, not a goal. |

Field rows must never leave an empty half-row. Paired controls on the same row share height (48px inputs), label alignment, vertical alignment and input styling. When one control has a trailing action — Store Email with `Change`/`Send Code` — the action occupies a fixed-width area so the input width does not shift between states.

### 4.4 Required components

Reuse from `packages/web-ui`; do not create page-local duplicates.

| Component | Contract |
| --- | --- |
| `OnboardingFlow` | Step registry, selection, focus transfer to the step heading, action bar, unsaved-change tracking |
| `RequirementBadge` | `level` + `status` → text + icon + semantic color. Never color alone |
| `FieldRow` | 1–2 children, equal height, responsive collapse, no empty half-row |
| `EmailVerificationPanel` | One named `store_email` input, read-only ⇄ editable, `Change`/`Send Code`, OTP entry, verified badge only on address match |
| `DocumentUploadField` | Accepted types, max size, scan state, version list, replace action, private short-lived preview URL, retry on failed preview |
| `AddressMapPicker` | Lazy init, pin place/move, structured resolve, lat/lng display, manual completion, stale-response rejection, accessible non-map alternative |
| `NicheSelector` | 27 canonical entries, multi-select, descriptions, custom Other labels, prohibited-term validation |
| `ReviewSummary` | Grouped requirement list, blocking reasons, unsaved-change list, jump-to-step links |
| `AuthorityScopePanel` | Representative identity, evidence selection, requested scopes, Admin decision state |

### 4.5 States every step must handle

Loading (skeleton, never a false empty), empty, per-field validation, cross-field validation, unauthorized, stale `lock_version` conflict, offline/provider failure with retry, upload scanning/pending/failed, success. Provider failures — geocode, mail, scanner, storage — degrade to manual completion or a clear retry; they never silently accept incomplete data.

### 4.6 Accessibility acceptance

WCAG 2.2 AA. Visible labels on every control. Step change moves focus to the step heading and announces the step via a live region. Errors are programmatically associated and summarized at the top of the step with jump links. Status is text + icon. Targets ≥44×44 CSS px for product controls; the documented dense-navigation exception applies only to the portal sidebar. Reduced motion removes the step transition. Browser checks run at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px.

---

## 5. Step V1 — Business Information

Privacy classes used below: **PUB** public marketplace data · **INT** internal, visible to authorized Vendor staff and Admin · **PRV** private evidence, authorized Vendor accounts and authorized Admin reviewers only, short-lived authenticated URLs · **TAX** private tax data, encrypted at rest and masked on read.

### 5.1 B1 — Business Type

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Business Type | `business_type` | Radio group | Always | One of `SOLE_PROPRIETORSHIP`, `PARTNERSHIP`, `CORPORATION`, `ONE_PERSON_CORPORATION`, `COOPERATIVE` | INT |

Each value is stored as a distinct legal classification. `ONE_PERSON_CORPORATION` may be treated internally as a corporate subtype for registration, tax, verification and integration rules, but it is always presented to the Vendor as its own selectable option.

The selected value drives: required legal-identity fields, required legal-name fields, registration authority, required primary registration document, supporting identity requirements, applicable tax requirements, applicable verification rules and which conditional requirements render. The interface shows only the applicable fields.

**On change.** Re-evaluate the applicable requirement set immediately, before the next save. Evidence that no longer satisfies the newly selected type stops counting toward its requirement and is retained but marked superseded. If the change affects previously submitted or approved business information, reopen the affected requirements for Admin review; never treat a prior approval as still valid.

### 5.2 B2 — Registered Legal Identity

**Individual Registered Name** — applies to `SOLE_PROPRIETORSHIP` and any other case where an individual proprietor or taxpayer must be identified.

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Surname | `individual_surname` | Text | Yes | 1–100, letters/space/hyphen/apostrophe/period | INT |
| First Name | `individual_first_name` | Text | Yes | as above | INT |
| Middle Name | `individual_middle_name` | Text | Conditional | as above | INT |
| Suffix | `individual_suffix` | Text | No | ≤10 | INT |
| Same as Vendor Owner's full legal name | `individual_same_as_owner` | Checkbox | No | Prefills from the Owner's registered/verified account data | — |

Helper text: "Individual Registered Name is your complete legal name as shown on the applicable government-issued identification and registration records."
The prefill is a convenience. The Vendor must still review and confirm that it matches the supporting legal records. The checkbox does not create a verified fact.

**Company Registered Name** — applies to `PARTNERSHIP`, `CORPORATION`, `ONE_PERSON_CORPORATION`, `COOPERATIVE`.

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Company Registered Name | `company_registered_name` | Text | Yes | 2–200 | INT |

Helper text: "Company Registered Name is the official legal name of the organization as recorded by the applicable government registration authority." The value must be consistent with the submitted registration evidence. For an OPC the flow may carry **both** the incorporator/Owner identity and the registered corporate name when the selected requirements demand it.

### 5.3 B3 — Government-Issued Identification

Collected where an individual proprietor, incorporator, authorized representative or other legally relevant person must be identified.

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| ID Type | `identity_document_type` | Select | Yes when B3 applies | Configured list | PRV |
| ID Number | `identity_document_number` | Text | Conditional on type | Type-specific mask; stored encrypted | PRV |
| Front image | `identity_document_front` | Upload | Yes | JPG/JPEG/PNG/PDF, configured max size, MIME and content validation, malware scan | PRV |
| Back image | `identity_document_back` | Upload | Conditional | Required when the selected document carries relevant information on both sides | PRV |

The document must correspond to the individual named in the applicable legal-identity section. Required fields and files are validated before Store Verification can be submitted.

Government ID never appears on the public Store Profile, in Buyer search, in public Vendor listings, in product listings, to other Vendors, or to Vendor staff without the required permission. Access is limited to authorized users and authorized Admin reviewers under the approved permission model, always through authenticated short-lived URLs.

### 5.4 B4 — Authorized Representative and Authority to Act

Renders for `PARTNERSHIP`, `CORPORATION`, `ONE_PERSON_CORPORATION` and `COOPERATIVE`, and for a Sole Proprietorship where the person completing onboarding is not the proprietor.

**The model keeps three concepts apart.**

| Concept | Meaning |
| --- | --- |
| Vendor Owner | The main MateryalPH Store account role |
| Authorized Representative | The person authorized to act for the legal business |
| Authorized Signatory | The person authorized to execute a specific legal, commercial, tax, payment or marketplace agreement |

One person may hold all three. The system must never assume they are the same person. **Account membership does not establish legal authority.** Where an agreement requires a legally authorized signatory, ordinary Vendor staff access is not sufficient.

**Representative information.**

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Full Legal Name | `representative_full_name` | Text | Yes | 2–150 | INT |
| Position / Title | `representative_position` | Text | Yes | 2–100 | INT |
| Email Address | `representative_email` | Email | Yes | RFC-valid, normalized | INT |
| Mobile / Telephone | `representative_phone` | Phone | Yes | E.164 or PH national format | INT |
| Relationship to the Business | `representative_relationship` | Select + text | Yes | `OFFICER`, `EMPLOYEE`, `ACCOUNTANT`, `AUTHORIZED_REPRESENTATIVE`, `CORPORATE_REPRESENTATIVE`, `COOPERATIVE_REPRESENTATIVE`, `OTHER` + label | INT |
| Government ID | see B3 | Upload | Conditional | Where required by the applicable rule | PRV |

The representative's details must correspond to the person identified in the submitted authority document.

**Conditional authority requirement.** The authority-document requirement is conditional, never blindly mandatory for every non-individual entity.

| Situation | Requirement outcome |
| --- | --- |
| The person is already sufficiently established as an authorized officer or signatory through accepted registration evidence | `CONDITIONALLY_REQUIRED`, satisfiable by selecting the existing evidence; the Admin decides whether it suffices |
| The person is an employee, accountant, representative or anyone whose authority is not otherwise established | `REQUIRED` — separate Authority Evidence must be uploaded |
| Sole Proprietorship where the representative is the proprietor | `NOT_APPLICABLE` with reason |

The applicable requirement is computed from Business Type, the representative's role, whether accepted records already show that person as an officer/signatory, the type of agreement or configuration being executed, and other approved verification rules. Do not demand every document type simultaneously.

**Authority Evidence.** Field label: **Authority to Act for the Organization**.

| Field | Key | Control | Validation | Privacy |
| --- | --- | --- | --- | --- |
| Evidence source | `authority_evidence_source` | Radio | `EXISTING_REGISTRATION_EVIDENCE` (pick a submitted document) or `SEPARATE_AUTHORITY_DOCUMENT` | INT |
| Document type | `authority_document_type` | Select | `SECRETARYS_CERTIFICATE`, `BOARD_RESOLUTION`, `SPECIAL_POWER_OF_ATTORNEY`, `PARTNERSHIP_AUTHORIZATION`, `COOPERATIVE_BOARD_RESOLUTION`, `OTHER_APPROVED` | INT |
| File | `authority_document_file` | Upload | PDF/JPG/JPEG/PNG, configured max size, MIME and content validation, malware scan, versioned | PRV |
| Document date | `authority_document_date` | Date | Valid, not future | INT |
| Requested scopes | `authority_scopes[]` | Multi-select | `TAX_DECLARATIONS`, `COMMISSION_AGREEMENT`, `PAYMENT_CONFIGURATION` | INT |

SEC records recognize Secretary's Certificates and Board Resolutions as corporate records; CDA rules and guidance likewise use Board Resolutions to evidence an authorized cooperative representative. Existing file-size, MIME/content, private-storage, malware-scan, versioning and audit rules apply unchanged. Authority evidence is private verification evidence and never appears on public Store Profiles, Buyer interfaces, product listings, Vendor search, public analytics or another Vendor's interface.

**Admin review of authority.** Before treating a representative as authorized for a legal or administrative action, an authorized Admin reviews: representative name, organization name, position or capacity, scope of authority, document date, signatures or certifications where applicable, consistency with the submitted business records, and other relevant evidence. Decisions are `APPROVE` → Approved, `RETURN_FOR_CORRECTION` → Changes Required (reason required), `REJECT` → Rejected (reason required).

**Protected actions.** Authority must be established before a representative may formally execute or attest marketplace agreements, the Commission Agreement, Xendit-related organizational configuration, tax declarations and other legally significant Vendor attestations. An authorized staff member may still enter draft information where permitted. Under the existing account model the Owner may prepare and submit organizational evidence before authority approval, but the **final attestation requires the current Owner-linked representative and an explicit Admin approval for the applicable scope**. A representative who is not linked to the Owner does not gain a new signatory login through this specification.

**Change control.** Representative and authority records are immutable. Changing the representative after approval preserves the previous representative record, the previous authority evidence, the effective period and who initiated the change; it requires new authority evidence where applicable and reopens Admin review. Replacement evidence retains its previous versions. Previously executed transactions and agreements stay associated with the representative and authority record effective when they were executed. A stale Admin decision carrying a prior step `lock_version` is rejected.

### 5.5 B5 — Business identity fields

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Registered / Legal Business Name | `legal_business_name` | Text | Yes | 2–200; must be consistent with the registration evidence | INT |
| Date of Establishment | `date_established` | Date | Yes | Valid calendar date, not in the future, comparable against registration evidence at review | INT |
| Public Store Name | `store_name` | Text | Yes | 2–100; prefilled from account creation; editable before submission | PUB |

`store_name` is the public trade name used in the storefront, Buyer search, product listings, quotations, orders, messages, recommendations, maps and other Buyer-facing surfaces. `legal_business_name` is the official registered name used for legal, registration, contractual and tax purposes — the registered proprietor/taxpayer identity, the DTI business name, the SEC company or partnership name, the OPC registered name, the CDA cooperative name, or another applicable registered identity.

A Vendor without a separate trade name may use the registered name as the Public Store Name, but they remain **two separate columns**. Changing one never automatically overwrites the other. The Vendor-entered establishment date stays subject to Admin verification where it is treated as a verified business fact.

**Row layout for B5 and B6.**

```
Registered Business Name            │ Date Established
Public Store Name                   (full width)
────────────────────────────────────────────────────  Store Contact Information
Store Email                         │ Store Phone Number
```

Store Email and Store Phone occupy one desktop/tablet row with equal width and equal height, and stack on mobile. A subtle divider introduces Store Contact Information.

### 5.6 B6 — Store Email and Store Phone

**Store Email** is the primary address for store communication, marketplace notices, Vendor administration and store notifications. It must be verified before it becomes the active verified Store Email.

There is **exactly one** named `store_email` input. Never render a second "email to verify" field.

| State | Rendering |
| --- | --- |
| Default | The current Store Email, read-only, with a `Change` action. `Verified` badge shown only when the displayed normalized address equals the server-confirmed Store Email |
| Changing | The same input becomes editable; `Change` is replaced by `Send Code` in the same fixed-width area |
| Code sent | OTP entry appears; the existing request/confirm endpoints are used with this value |
| Confirmed | Refresh the authoritative snapshot, clear the code, return the field to read-only, restore `Change`, show `Verified` |
| Failed / expired | The existing verified Store Email remains unchanged; the request and the confirmation both remain recoverable |

Editing after requesting a code clears the old challenge UI. A pending or replacement address never inherits the previous address's verification state. If the Owner registered through an already-verified Google identity, that verified address may be prefilled and must not require duplicate ownership verification simply because it is reused as the Store Email.

Helper text: "This email will be used for store-related communication. A different email address must be verified before it can replace the existing Store Email."

**Store Phone Number.**

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Store Phone Number | `store_phone` | Phone | Yes | E.164 or PH national format | INT |
| Same as Vendor Owner phone number | `store_phone_same_as_owner` | Checkbox | No | Prefills from the Owner's registered phone | — |

Store Phone is an ordinary contact field. It is never presented as SMS-verified and **no OTP is added to it in this implementation**.

### 5.7 B7 — Primary Business Contact

The principal person responsible for administrative and business communication with MateryalPH. The Vendor Owner's information is shown as the initial default.

| Field | Key | Required | Validation | Privacy |
| --- | --- | --- | --- | --- |
| Contact full name | `primary_contact_name` | Yes | 2–150 | INT |
| Position or title | `primary_contact_position` | Yes | 2–100 | INT |
| Email address | `primary_contact_email` | Yes | RFC-valid, normalized; verified through the approved email-verification process where verification is required | INT |
| Mobile or telephone | `primary_contact_phone` | Yes | E.164 or PH national format | INT |

Where the entered contact email is already an approved verified email belonging to the same authorized person, reuse the existing verification rather than forcing a duplicate ownership challenge. The Primary Business Contact stays distinct from public Store contact information when the Vendor chooses different public-facing details.

### 5.8 B8 — Tax Information

Tax information is collected **once, here**. Payment Configuration in Store Setup references the approved or currently effective Vendor Tax Profile and must never re-collect it.

**Taxpayer Identification Number.**

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Core TIN | `tin_core` | Text, numeric | Yes | Exactly 9 numeric digits. Accept digits only; reject letters, reject symbols other than interface-handled formatting, reject any length other than 9. Display formatting is normalized separately from the stored canonical value | TAX |
| Registration scope | `tin_branch_scope` | Radio | Yes | `HEAD_OFFICE` or `BRANCH` | TAX |
| Branch Code | `tin_branch_code` | Text, numeric | Yes | 3 or 5 numeric digits per the configured BIR branch-code format. Digits only; reject letters and unsupported symbols; stored separately from the Core TIN. No arbitrary alphanumeric values | TAX |

When `HEAD_OFFICE` is selected, prefill the Head Office branch code from the configured format — `000` for the 3-digit representation, `00000` for the 5-digit representation — and label it **Head Office (HO)**. Do not make the Vendor type it. Never assume every location is the Head Office: selecting `BRANCH` requires the registered branch code shown on the BIR records.

Guidance: "Enter the 9-digit TIN and applicable Branch Code exactly as shown on your BIR registration records."
Head Office helper: "The Head Office Branch Code is automatically assigned using the BIR format configured for this verification flow."

TIN and Branch Code are stored as private business-tax information, encrypted at rest, masked on read, associated with the Vendor Tax Profile and marked pending verification until an Admin reviews them against the BIR Certificate of Registration. The complete TIN and Branch Code never appear on public Store Profiles, Buyer search, Vendor maps, public product listings, public analytics, other Vendors' interfaces or any other public marketplace surface. Authorized interfaces may show masked values.

**VAT Registration Status.**

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Declared VAT status | `vat_status_declared` | Radio | Yes | `VAT_REGISTERED` or `NON_VAT_REGISTERED` | TAX |
| Verified VAT status | `vat_status_verified` | Admin-only | — | Set by an authorized Admin against the submitted BIR evidence | TAX |

Declared and verified status are separate columns. An inconsistent declaration is returned as `CHANGES_REQUIRED` with a reason; the Vendor then corrects the information or supplies suitable replacement evidence. Never infer VAT status or a withholding exemption from an unchecked box or from an 8% income-tax election.

**BIR Certificate of Registration.**

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| BIR COR | `bir_cor_document` | Upload | Yes | JPG/JPEG/PNG/PDF, configured max size, MIME and content validation, file-type rules, malware scan, private storage, versioned | PRV |

The Admin may read registered taxpayer or legal-business name, TIN, branch information, registration status, VAT or Non-VAT status and other tax-registration information from the document. Uploading does not verify the Tax Profile; the requirement stays at its submission/review status until an authorized Admin approves it. Never assign an invented annual expiration date to a COR — where no expiration applies the Admin records **Expiration: Not Applicable**. A missing mandatory BIR registration requirement is an activation blocker.

**Sworn Declaration.**

Explanatory text: "A BIR-received Sworn Declaration may be submitted when your applicable annual gross remittances are expected not to exceed ₱500,000.00. The declaration is subject to review and applicable BIR rules."

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Will you submit a Sworn Declaration? | `sworn_declaration_claim` | Radio YES/NO | Yes | — | TAX |
| Taxable year | `sworn_declaration_taxable_year` | Year select | When YES | Valid taxable year; records the applicable period | TAX |
| BIR-received copy | `sworn_declaration_document` | Upload | When YES | **PDF only**; must be the BIR-received / BIR-stamped copy; configured max size, content validation, malware scan, versioned | PRV |

Selecting YES grants **no** tax exemption, withholding exemption, reduced withholding, threshold relief or any other treatment. The upload is a claim under review. Selecting NO records that no relief declaration was submitted for the period and applies the standard configured withholding treatment.

Configured withholding for the marketplace is 1% on one-half of applicable gross remittances, expressed as `W = money(G × 0.005)` half-up, subject to statutory exceptions and threshold rules. Never describe it internally as "1% of all remittances." The tax engine keeps withholding rate, withholding tax base, gross-remittance threshold, effective period, declaration status and Admin verification status as distinct concepts.

**Threshold behavior (FIN-04A).** The ledger keeps a per-taxpayer, per-taxable-year counter of gross remittances. When the cumulative amount would reach **₱500,000.01**, the account flips from relief to subject-to-withholding, the crossing remittance itself is fully covered, and the status is sticky for the rest of that taxable year regardless of any uploaded or approved declaration. A later refund or a lower running total does not restore relief. See `MateryalPH_Technical_Design_Delta_FIN-04A_Withholding_Threshold.md`. Phase 3 captures the claim only; Phase 11 implements the counter.

The Vendor Owner is the account responsible for formally attesting and submitting tax declarations. Vendor staff must not attest the Sworn Declaration on the Owner's behalf unless a future approved authorization model allows it. Failing to submit an optional threshold/relief declaration must not by itself block Store Activation where the approved finance rules permit standard withholding to apply.

**Vendor Tax Profile.** The submitted information creates or updates the organization-level Vendor Tax Profile: taxpayer identity, legal entity classification, TIN and branch information, VAT classification, applicable fiscal or taxable period, supporting evidence, Sworn Declaration evidence, declaration status, effective period, environment, evidence origin, verification decision, withholding assignment or scenario and version history. Corrections create a new version or an audited change; they never silently rewrite prior financial history and never retroactively modify previously accepted prices, completed payments, immutable financial snapshots or posted financial records unless an approved adjustment process creates the correction record.

### 5.9 B9 — Business and Compliance Evidence

Primary registration evidence by Business Type:

| Business Type | Required primary registration evidence |
| --- | --- |
| Sole Proprietorship | DTI Business Name Registration |
| Partnership | SEC Registration |
| Corporation | SEC Registration |
| One Person Corporation | SEC Registration |
| Cooperative | CDA Registration |

Only the applicable requirements render. Changing Business Type recalculates the document requirements; previously uploaded evidence that no longer satisfies the newly selected type stops appearing as satisfying the requirement.

| Requirement | Key | Level | Notes |
| --- | --- | --- | --- |
| Primary registration document | `primary_registration_document` | REQUIRED | Per the table above |
| LGU Business Permit | `lgu_business_permit` | REQUIRED | Issued by the local government unit |
| Optional certifications | `optional_certifications[]` | OPTIONAL | ISO certifications, industry-specific licenses, professional or regulatory certifications, other business credentials |

Optional certifications never block Store Activation unless a specific marketplace function, regulated product, law, selected Vendor capability or approved rule makes one mandatory. The system may cap the number of optional files, individual file size, total upload size and supported file types to prevent collecting unrelated information.

**Document metadata.** For every uploaded business or compliance document, store: document type, document number, upload date and time, uploading user, organization, file reference, submission status, verification status, Admin reviewer, Admin remarks, verified issue date, verified expiration date, Not Applicable expiration status, replacement or superseded-document reference and audit reference. The Vendor may enter supporting metadata at submission; **Vendor-entered metadata is never automatically treated as verified information**.

---

## 6. Step V2 — Registered Business Address

The registered or principal operating address applicable to the marketplace account. Two equally valid entry paths: **Manual Address Entry** and **Interactive Map Selection**. Both produce the same stored record.

| Field | Key | Required | Validation | Privacy |
| --- | --- | --- | --- | --- |
| Street / building / unit / establishment | `address_line` | Yes | 2–200 | INT |
| Barangay | `barangay` | Yes | Structured PH field | INT |
| City or Municipality | `city_municipality` | Yes | Structured PH field | INT |
| Province or independent-city classification | `province` | Yes | Structured PH field; independent and highly urbanized cities classified correctly | INT |
| Postal code | `postal_code` | Yes | 4 digits | INT |
| Latitude | `latitude` | Yes | −90..90, 7 decimals | INT |
| Longitude | `longitude` | Yes | −180..180, 7 decimals | INT |

Use structured Philippine address fields, not a single unvalidated text blob. Coordinates are stored **separately** from the human-readable structured address: coordinates support geospatial computation; the structured address supports presentation, administrative classification, verification, filtering and reporting.

**Map behavior.** The map uses the approved Google Maps integration for the configured environment. Provider credentials stay in protected server or environment configuration and are never committed or unnecessarily exposed to the client; the browser key and the server key are separate restricted keys. The map initializes only when V2 is the selected step.

The Vendor places or moves a pin. The system attempts to resolve the coordinates into structured address components and may prefill street/building, barangay, city/municipality, province or administrative area, postal code, latitude and longitude. Latitude and longitude are **displayed** in their designated fields whenever a map location is selected.

Hard rules:

- The Vendor reviews the resolved address before it is saved.
- The system never silently accepts an incomplete or incorrectly resolved address.
- Where geocoding cannot confidently supply a required component, manual completion is allowed or required.
- Stale lookup responses are discarded; a later response for an earlier pin position must not overwrite the current one.
- A provider failure degrades to manual structured entry with a clear message and retry, never to a blocked step.
- An accessible non-map alternative exists and is fully sufficient on its own.

Store location may later be used for Vendor discovery, location-based search, distance calculation, delivery-coverage evaluation, delivery-fee calculation, supplier recommendation, Vendor Materials Analytics scope and geographic marketplace reporting.

**Change control.** A critical change to a previously approved Registered Business Address creates a new version or review event and reopens the affected requirement. It never silently overwrites a verified value.

---

## 7. Step V3 — Supplier Type / Classification

| Field | Key | Control | Required | Validation |
| --- | --- | --- | --- | --- |
| Supplier Type | `supplier_type` | Radio | Yes | `WHOLESALER_DISTRIBUTOR`, `RETAIL_HARDWARE_STORE`, `SPECIALIZED_SUPPLIER` |
| Supplier Niches | `supplier_niches[]` | Multi-select | Yes, ≥1 | Canonical list below |
| Custom Other labels | `supplier_custom_niches[]` | Repeatable text | When `OTHER_CATEGORY` is selected | 2–60 each; multiple allowed; prohibited-term validation |

**Canonical niches — 27 entries.** Each renders with a short scope description.

1 Construction Materials · 2 Electrical Supplies · 3 Plumbing and Sanitary · 4 Tools and Equipment · 5 Finishing Materials · 6 Fasteners and Hardware · 7 Cement and Concrete · 8 Roofing Materials · 9 Formworks and Scaffolding · 10 Wood and Lumber · 11 Landscaping and Exterior · 12 Steel and Reinforcement · 13 Tools and Accessories · 14 Masonry · 15 Insulation and Waterproofing · 16 Aggregates · 17 Drainage and Septic Materials · 18 Construction Chemicals · 19 Flooring Materials · 20 Wall and Ceiling Materials · 21 HVAC Materials · 22 Sanitary Fixtures · 23 Fire Protection Materials · 24 Paints and Finishes · 25 Adhesives and Sealants · 26 Doors, Windows, and Glass · 27 Other Category

Selecting **Other Category** reveals a text field where the Vendor may describe another relevant construction-material niche, and may add as many custom labels as needed. A custom label is stored as a **Vendor-provided custom classification label**. It never automatically creates a new canonical MateryalPH taxonomy category. Marketplace search, Vendor matching, analytics, canonical categorization and product classification continue to use the approved taxonomy while retaining the custom label separately. A custom Other label does not by itself require separate Admin approval before completing Store Verification, provided it does not violate a prohibited-category rule.

Multiple valid niches may be selected when the business operates across several supported categories.

**Rental Category Restriction.** MateryalPH does not support construction-vehicle or equipment-rental services as marketplace inventory. Supplier Type and niche entries that clearly represent unsupported rental services are rejected — for example Construction Vehicle Rental, Vehicle Rental, Construction Equipment Rental, Equipment Rental, Rental. Validation is case-insensitive and normalizes whitespace, capitalization, punctuation and equivalent prohibited wording.

Rejection message: "Vehicle and equipment rental services are not currently supported by MateryalPH. The marketplace currently supports construction materials, supplies, tools, equipment offered as supported products, and other approved procurement categories."

Selecting **Tools and Equipment** never converts construction vehicles into supported rental inventory.

---

## 8. Step V4 — Privacy, Review and Submit

**Privacy Notice.** The current published Privacy Notice is presented before submission and explains, in clear language: categories of information collected, purpose of collection, applicable processing activities, authorized recipients or processors, retention basis, data-subject rights, the privacy-request process and other required privacy information. A published current Privacy Notice is a precondition for submission; if none is published, submission is blocked with a clear operational message rather than a silent failure.

The Vendor must acknowledge it before completing submission. The system records the Vendor/User identifier, organization, Privacy Notice version, date and time, applicable processing activity, source or interface, and the acknowledgment record itself.

Privacy acknowledgment is stored **separately** from Terms of Service, the Vendor Code of Conduct, the Commission Agreement, payment agreements and other commercial agreements. Acknowledging the Privacy Notice never implies acceptance of unrelated commercial terms or optional processing.

**Review summary.** Grouped by step, showing each requirement with its level, status, blocking reason where applicable, and a jump link. Unsaved edits are listed explicitly and must be saved before submission.

**Submission validation.** The server validates, and the UI mirrors: Business Type · required legal-identity information · required legal-name information · required government-issued identity evidence · Legal Business Name · Public Store Name · Date of Establishment · verified Store Email · required Store Phone Number · required Primary Business Contact · Registered Business Address · required geolocation/address information · Supplier Type · Supplier Niches · required primary registration evidence · required LGU documentation · required BIR registration information · required Tax Profile fields · applicable declaration information · supported file types · maximum file sizes · required document numbers · required acknowledgments · other applicable conditional requirements · Privacy Notice acknowledgment.

A missing or invalid item blocks submission and the response identifies the **exact** requirement to complete or correct — never a generic failure.

**After submission.** Store Verification moves to `PENDING_VERIFICATION`. Submission does not mean the Vendor is verified.

**Confirmation page.** Dedicated page with: "Business information and documentation successfully submitted. Your Store Verification is awaiting Admin review." and a **Proceed to Store Setup** action. The Vendor may begin Store Setup immediately and is not required to wait for Admin approval. The Store still cannot be activated until every mandatory Store Verification requirement reaches its required successful final status and all other Store Activation conditions pass.

---

## 9. Store Setup — S1 to S6

Independent checklist. May begin after Store Verification is submitted.

**S1 Public Store Profile.** Editable form plus a marketplace-style preview with banner, overlapping logo, name, description, public contact details and city/province summary. Text changes appear immediately. Store Media is a subsection beside the editor and preview; a successful upload refreshes the preview without discarding unsaved fields. Missing media shows structured placeholders; a failed preview offers retry. Legal fields cannot be edited here. Private staff contacts, tax data and evidence are excluded from the profile and the preview. Media is validated for supported type, maximum size, safety, appropriate content, intellectual-property requirements and accessibility metadata. Operating hours and additional gallery media are not implemented by the current surface and must not be fabricated in the preview.

**S2 Fulfillment Configuration.** Bulk Order Capability — Yes enables Item-Based and Project-Based eligibility, No enables Item-Based only; it creates no competitive RFQ bidding queue and never rewrites accepted orders. Services Capability — Self-Pickup, Vendor Delivery or Both. Self-Pickup only sets Delivery Configuration to `CONDITIONALLY_REQUIRED` / `NOT_APPLICABLE`. Vendor Delivery or Both makes Delivery Configuration conditionally required before activation, with vehicle category, count, capacity (kg), cargo length/width/height (m), heavy-vehicle classification, base fee, per-kilometer rate and maximum delivery distance. Unconfigured vehicles never appear as fulfillment options. Editing a vehicle later never changes an accepted order's delivery snapshot.

**S3 Xendit TEST Connection.** xenPlatform sub-account onboarding is mandatory for every Vendor seeking Store Activation, regardless of Business Type. The Vendor creates the sub-account and Authorized Representative invitation through the Xendit Dashboard. MateryalPH may guide the Vendor to the provider flow and capture the resulting exact HTTPS link, but never constructs an undocumented Dashboard URL and never silently creates the account. Capture the provider sub-account ID and reconcile it through permitted backend-only API/webhook mechanisms — a saved link alone never proves connection. Invitation links are sensitive: restrict access, mask in the UI where possible, redact from logs. TEST/DEMO only; TEST capability is not live payment processing, production KYC, BIR registration, statutory withholding responsibility or government approval. If the provider cannot support the required link or reconciliation operation in the configured environment, keep the connection unverified and report the provider limitation rather than fabricating success.

**S4 2% Commission Terms.** Versioned agreement covering the 2% Vendor-paid commission, its exclusive-materials base, monthly collection, VAT-inclusive fee treatment where applicable, cancellation and partial-refund credits, the statement due-date rule and the dispute process. Accepted by the Vendor Owner or an Admin-approved representative holding the `COMMISSION_AGREEMENT` scope. Changing settings never adds a fee to an already accepted order.

**S5 Team Accounts.** Optional; never blocks activation. Explains the existing post-setup invitation route. Fixed roles: Store Manager, Store Staff, Customer Service Staff, Inventory Staff, Fulfillment Staff. One fixed role per membership. Store Manager staff-management delegation is off by default, cannot reach another Store Manager, ownership, payout credentials or audit records, and notifies the Owner on every delegated action.

**S6 Review and Complete.** Setup summary, unsaved-change list, completion. Completion never approves a verification item.

**Finish Later and the limited Dashboard.** Available at any permitted point in either workstream. Saves current progress, preserves every requirement's level and status, and returns to the limited Dashboard, which exposes Store Profile, Store Account Settings, Continue Store Verification, Continue Store Setup, Review Pending Verification, Correct Changes Required and onboarding progress — with separate checklists, blockers, dedicated Continue actions and the current Store Activation status. Marketplace operations stay locked until Store Activation.

---

## 10. Admin — Vendor Management → Vendor Verification

### 10.1 Queue

Columns: organization, Public Store Name, Business Type, submitted at, oldest pending requirement age, blocking count, assigned reviewer, status. Filters: status, Business Type, requirement type, age, reviewer, expiry window. Sort defaults to oldest pending first. Every list is paginated.

### 10.2 Case detail

The reviewer sees the Vendor's submitted information **in organized sections that mirror the Store Verification steps** — never an unstructured document list. Each section shows its fields, its evidence, its current requirement level and status, its version history and its decision controls.

Sections: Business Information · Legal Identity and Government ID · Authorized Representative and Authority · Tax Profile · Business and Compliance Evidence · Registered Business Address · Supplier Type / Classification · Privacy acknowledgment record · Activation readiness.

The Admin checks completeness, consistency, document validity, legal-registration details, applicable dates, tax information, identity information where authorized, supporting evidence and other relevant requirements, comparing entered data against the selected Business Type and the applicable DTI, SEC, CDA, LGU, BIR, TIN, permit, license and identity evidence.

**Snapshot contents.** Current Privacy Notice, masked representative information, current document versions, correction reasons, and for each evidence item its scan state and version chain.

### 10.3 Decisions

Per reviewed requirement: **Approve** → `APPROVED`; **Return for Correction** → `CHANGES_REQUIRED`, reason required; **Reject** → `REJECTED`, reason required. Every decision records actor, role, timestamp, before/after state, reason, evidence version, correlation ID, notification and audit reference. Decisions carry the evidence version they were made against; a decision submitted with a stale step `lock_version` is rejected with a conflict response.

Authority decisions additionally record the approved scopes from `TAX_DECLARATIONS`, `COMMISSION_AGREEMENT`, `PAYMENT_CONFIGURATION`.

### 10.4 Verified document metadata

Only an authorized Admin records verified values: verified document number, issue date, expiration date **or Expiration: Not Applicable**, verification remarks, review evidence or source, verification decision, reviewer and review timestamp.

Rules: `expiration_date < issue_date` is rejected. The model distinguishes *no expiration applies*, *expiration not yet verified*, *expiration verified*, and *document expired*. A previously approved document may stay effective while a replacement is under review where the applicable compliance rule permits; an expired, revoked or materially invalid document may create an immediate restriction where the rule requires it.

Where OCR is supported it may extract document number, registered name, issue date, expiration date, TIN or branch information and other document-specific values. **OCR output is review assistance only.** It never approves a document and never becomes authoritative verified metadata without Admin review.

### 10.5 Correction and resubmission

A `CHANGES_REQUIRED` item lets the Vendor correct information or upload replacement evidence and moves through `CHANGES_REQUIRED → SUBMITTED → PENDING_VERIFICATION → APPROVED`. Old evidence is never silently destroyed: the previous file, previous metadata, previous verification decision, Admin remarks, the replacement relationship and the audit history are all preserved. Unrelated requirements that remain valid are **not** reset because another requirement was returned.

### 10.6 Reverification triggers

A critical change to previously approved legal-business information reopens the affected requirement: Legal Business Name · Company Registered Name · Business Type · Registered Business Address · TIN or branch information · VAT classification · a required registration document · other critical compliance evidence · replacement of the authorized representative or of relevant authority evidence.

Changing a public Store Profile image, Store banner, ordinary marketing description or other non-legal public presentation content does **not** trigger business reverification unless an approved policy specifically requires it. Reverification targets the affected requirement; it never resets the Vendor's entire Store Verification record when a narrower reopen is possible.

An approved document that later expires becomes `EXPIRED`, and the Vendor uploads a replacement where continued validity is required.

### 10.7 Admin limits

An Admin cannot override a missing mandatory requirement from the frontend. Any future exceptional override needs a dedicated policy, reason, authorization and audit event. Vendor Verification Staff may review registration and declaration evidence within their assigned scope; they cannot authorize a new statutory rate or mark a tax return filed.

---

## 11. Data model delta

Additive migrations only. Existing records are retained.

| Table | Purpose | Key columns |
| --- | --- | --- |
| `vendor_onboarding_requirements` | The registry every UI renders | `organization_id`, `workstream`, `requirement_key`, `level`, `status`, `applicability_reason`, `blocking`, `lock_version` |
| `vendor_onboarding_drafts` | Per-workstream draft payload + version | `organization_id`, `workstream`, `payload` (jsonb), `lock_version`, `updated_by` |
| `vendor_representative_versions` | Immutable representative records | `organization_id`, `full_name`, `position`, `email`, `phone`, `relationship`, `effective_from`, `effective_to`, `created_by`, `supersedes_id` |
| `vendor_authority_reviews` | Authority decisions and scopes | `representative_version_id`, `evidence_source`, `document_version_id`, `scopes[]`, `decision`, `reason`, `reviewer_id`, `decided_at` |
| `vendor_verification_change_history` | Encrypted before/after of critical legal fields | `organization_id`, `field_key`, `old_value_encrypted`, `new_value_encrypted`, `actor_id`, `reopened_requirements[]`, `occurred_at` |
| `vendor_documents` / `vendor_document_versions` | Evidence and its immutable versions | `document_type`, `file_reference`, `checksum`, `scan_state`, `uploaded_by`, `superseded_by`, verified metadata columns |
| `vendor_addresses` / `vendor_address_versions` | Structured address + separate geography point | structured columns, `location` geography(Point,4326) with GiST index, `version`, `review_state` |
| `vendor_supplier_classifications` | Type, canonical niches, custom labels | `supplier_type`, `niche_keys[]`, `custom_labels[]` |
| `vendor_tax_profiles` / `vendor_tax_profile_versions` | Single organization-level legal-tax source | `taxpayer_key`, `tin_core_encrypted`, `tin_branch_code_encrypted`, `branch_scope`, `vat_status_declared`, `vat_status_verified`, `declaration_claim`, `declaration_year`, `effective_from/to`, `representative_version_id` |
| `privacy_acknowledgments` | Separate from commercial agreements | `user_id`, `organization_id`, `notice_version_id`, `activity`, `source`, `acknowledged_at` |
| `vendor_activation_history` | Append-only activation evaluations | `previous_state`, `new_state`, `checklist_version`, `blocking_items[]`, `actor_or_process`, `reason`, `occurred_at` |

Agreement acceptances gain `representative_version_id` so an executed agreement stays bound to the representative and authority record effective at execution.

Storage split: **only public Store media goes to Cloudinary**; tax, identity and authority evidence stays on the configured private disk. Scanning fails closed. Private evidence is reachable only by the owning Vendor's authorized accounts and authorized Admin reviewers, through authenticated short-lived URLs.

---

## 12. API surface

Extend the existing `/api/v1` operations; do not rename them. All responses use `{ data, meta, errors }`. All mutations carry the current `lock_version`.

| Operation | Notes |
| --- | --- |
| `GET /vendor/onboarding` | Authoritative snapshot: both workstreams, requirement registry, step completion, activation readiness with blocking list, current Privacy Notice version, masked representative and tax values, current document versions, correction reasons |
| `PATCH /vendor/onboarding/verification/draft` | Accepts business type, legal identity, representative details, numeric `tin_core` and `tin_branch_code`, branch length, head-office flag, VAT declaration, declaration claim and year, address, classification. `409` on stale `lock_version` |
| `PATCH /vendor/onboarding/setup/draft` | Store Setup draft |
| `POST /vendor/onboarding/documents` | Types include primary registration, LGU permit, BIR COR, sworn declaration, individual ID front/back, representative identity front/back, authority evidence, optional certification. Returns version and scan state |
| `POST /vendor/onboarding/store-email/request-code` · `/confirm` | Existing OTP endpoints reused by the single `store_email` field |
| `POST /vendor/onboarding/address/resolve` | Server-side geocode proxy; the browser never holds the server key |
| `POST /vendor/onboarding/verification/submit` | Requires the Privacy Notice acknowledgment payload; validates the full checklist; returns the exact failing requirement keys |
| `POST /vendor/onboarding/setup/complete` | Store Setup completion |
| `POST /vendor/onboarding/finish-later` | Persists and returns the dashboard destination |
| `GET /admin/vendor-verifications` | Paginated queue |
| `GET /admin/vendor-verifications/{id}` | Sectioned case snapshot |
| `POST /admin/vendor-verifications/{id}/requirements/{key}/decision` | `APPROVE` / `RETURN_FOR_CORRECTION` / `REJECT`, reason, verified metadata, evidence version, `lock_version` |
| `POST /admin/vendor-verifications/{id}/authority/decision` | Authority decision + approved scopes |
| `GET /vendor/documents/{versionId}/url` · `GET /admin/documents/{versionId}/url` | Authenticated short-lived private URL |

**Error codes.** `ONBOARDING_STALE_VERSION` · `REQUIREMENT_INCOMPLETE` (with `requirement_keys[]`) · `STORE_EMAIL_UNVERIFIED` · `OTP_INVALID` · `OTP_EXPIRED` · `TIN_FORMAT_INVALID` · `BRANCH_CODE_FORMAT_INVALID` · `PROHIBITED_CATEGORY` · `ADDRESS_INCOMPLETE` · `GEOCODE_UNAVAILABLE` · `DOCUMENT_SCAN_PENDING` · `DOCUMENT_SCAN_FAILED` · `AUTHORITY_REQUIRED` · `AUTHORITY_SCOPE_NOT_APPROVED` · `PRIVACY_NOTICE_UNAVAILABLE` · `PRIVACY_ACKNOWLEDGMENT_REQUIRED` · `ACTIVATION_BLOCKED` (with blocking list).

---

## 13. Privacy and exposure matrix

| Data | Public Store Profile | Buyer search / listings / maps | Other Vendors | Vendor staff without permission | Authorized Vendor accounts | Authorized Admin |
| --- | --- | --- | --- | --- | --- | --- |
| Public Store Name, logo, banner, description, public contact, city/province | Yes | Yes | Yes | Yes | Yes | Yes |
| Legal Business Name, Company Registered Name, Date Established | No | No | No | No | Yes | Yes |
| Government ID, authority evidence, registration/permit files, BIR COR, sworn declaration | No | No | No | No | Yes (short-lived URL) | Yes (short-lived URL) |
| Core TIN, Branch Code | No | No | No | No | Masked | Masked; full value only where the approved review permission applies |
| Representative identity | No | No | No | No | Masked | Yes |
| Exact coordinates | Derived distance only | Derived distance only | No | No | Yes | Yes |
| Withholding counter and tax status | No | No | No | No | Yes | Yes |

---

## 14. Acceptance tests

**Structure and navigation.** Four verification steps and six setup steps render. Only the selected step is visible and keyboard reachable. Focus transfers to the step heading. Switching steps preserves native values without saving. Save Draft and Finish Later use the existing builders, version checks and dashboard destination. Unsaved edits appear on the review step and block submission until saved. Completion indicators come from the server.

**Business Type.** Each of the five values renders only its applicable identity, evidence and tax fields. Changing type recalculates requirements before save, stops counting superseded evidence, and reopens affected approved requirements for review.

**Legal identity.** Individual name fields and the Owner prefill behave correctly; the prefill creates no verified fact. Company name required for the four non-individual types. OPC can carry both incorporator identity and corporate name.

**Representative and authority.** Officer already shown in accepted records can satisfy the requirement from existing evidence; an employee or accountant cannot and is forced to upload. Sole proprietor path yields `NOT_APPLICABLE` with a reason. Final attestation without an approved scope is refused. Replacing the representative preserves the prior record, reopens review and leaves previously executed agreements bound to the old record. A decision with a stale `lock_version` is rejected.

**TIN.** 9 digits accepted; 8 and 10 rejected; letters and symbols rejected. Branch code accepts 3 and 5 digits including `000` and `00000`; 4 digits rejected; alphanumeric rejected. Head Office prefills and does not require typing; Branch requires an entered code. Stored values are encrypted and masked on read.

**Store Email.** Exactly one named `store_email` input exists in the DOM. Initial read-only state, change, confirm, re-change. Verified badge only when the displayed normalized address matches the server-confirmed address. A pending replacement never inherits verification. Editing after requesting a code clears the challenge. Request failure and confirmation failure are recoverable. Draft payloads carry the right value. Input and action widths and heights stay stable between `Change` and `Send Code`.

**Store Phone.** No OTP path exists. Owner prefill works.

**Tax.** Declared VAT does not set verified VAT. COR upload does not approve the Tax Profile. A COR with no expiry accepts Expiration: Not Applicable and rejects an invented date. Sworn Declaration YES requires claim + taxable year + PDF and grants no relief. Declaration NO records standard treatment. Missing optional declaration alone does not block activation; a missing mandatory BIR registration does.

**Address.** Manual-only completion succeeds with no map interaction. Map pin resolves and displays latitude and longitude. Incomplete geocode requires manual completion. A stale resolve response is ignored. Provider failure degrades to manual entry. Coordinates and structured address are stored separately. A critical address change creates a version and reopens review.

**Classification.** Multi-niche selection persists. Other Category accepts multiple custom labels without creating taxonomy entries. Prohibited rental phrasing is rejected case-insensitively and after whitespace/punctuation normalization. Selecting Tools and Equipment does not permit rental inventory.

**Privacy and submission.** Submission without acknowledgment is refused. Acknowledgment records user, organization, notice version, timestamp, activity and source, and is stored separately from commercial agreements. Missing Privacy Notice blocks submission with an operational message. Each missing requirement is named exactly. Successful submission sets `PENDING_VERIFICATION` and shows the confirmation page with Proceed to Store Setup.

**Admin.** Sectioned case view. Approve / Return / Reject with required reasons. Verified metadata recorded by the Admin only. `expiration_date < issue_date` rejected. OCR never auto-approves. Correction preserves prior file, metadata, decision, remarks and relationship. Unrelated approved requirements are not reset. Stale decisions rejected.

**Authorization.** Cross-Vendor document access returns a safe `403`/`404`. Unauthorized staff cannot read private evidence. A hidden button never authorizes anything. Activation bypass attempts fail at the backend gate.

**Accessibility and responsiveness.** Browser checks at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px: no horizontal page or stepper overflow, ≥14px step labels, all step buttons within the navigation bounds, one equal-height field row at ≥1024px, matching contact-input geometry, reduced-motion keyboard navigation, and every status conveyed by text or icon in addition to color.
