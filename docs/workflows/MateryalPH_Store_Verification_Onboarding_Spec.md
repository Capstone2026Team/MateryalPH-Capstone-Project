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
| V1 | Business Information | Business Type · Registered Legal Identity · Government ID · Authorized Representative and Authority to Act · Public Store Name · Legal Business Name · Date of Establishment · Store Email · Store Phone · Tax Information (TIN, VAT, BIR COR, Sworn Declaration) · Business and Compliance Evidence |
| V2 | Registered Business Address | Manual structured entry · interactive map selection · coordinates · review before save |
| V3 | Supplier Type / Classification | Supplier Type · canonical niches · custom Other labels · rental prohibition |
| V4 | Privacy, Review and Submit | Privacy Notice acknowledgment · full requirement summary · unsaved-change detection · submit |

### Store Setup — 6 steps

| # | Step | Contains |
| --- | --- | --- |
| S1 | Public Store Profile | Logo · banner · description · public contact · city/province summary · Store Media subsection · live marketplace-style preview |
| S2 | Fulfillment Configuration | Bulk Order Capability · Self-Pickup / Vendor Delivery / Both · delivery coverage · vehicle fields when applicable |
| S3 | Xendit TEST Connection | Server-side TEST sub-account provisioning and authoritative backend/provider connection status |
| S4 | Team Accounts | Optional staff configuration; excluded from setup completion and activation requirements |
| S5 | Store Operation | Required weekly operating schedule; every day explicitly Open or Closed |
| S6 | Review and Complete | Setup summary including public Store Hours, unsaved-change detection, completion |

### Navigation contract

- Only the selected step is visible **and** keyboard reachable. Other steps are removed from the accessibility tree, not merely hidden visually.
- Store Setup edits auto-save after validation with version checks; switching steps and Finish Later flush pending valid changes before navigation.
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
| Front image & Back image | `identity_document_front` | Upload | Yes | JPG/JPEG/PNG/PDF, configured max size, MIME and content validation, malware scan | PRV |
| Back image | `identity_document_back` | Upload | yes except passport| Required when the selected document carries relevant information on both sides | PRV |

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

### 5.7 B7 — Retired duplicate contact collection

As approved on 23 September 2026, Store Contact Information (verified Store Email and Store Phone) is the single source for business communication. Do not collect, store, expose, or require a separate Primary Business Contact. Owner identity and Authorized Representative / Authority to Act remain separate requirements. Existing audit and compliance history is retained.

### 5.8 B8 — Tax Information

Tax information is collected **once, here**. Payment Configuration in Store Setup references the approved or currently effective Vendor Tax Profile and must never re-collect it.

**Taxpayer Identification Number.**

| Field | Key | Control | Required | Validation | Privacy |
| --- | --- | --- | --- | --- | --- |
| Taxpayer Identification Number (TIN) | `tin` | Text, numeric with optional hyphens | Yes | One field: 9-digit taxpayer number followed by a 3 to 5 digit branch code. Accept 12–14 digits or `999-999-999-000` formatting. Use `000` when no branch code applies. No separate office selection or branch format control | TAX |

Guidance: "Your 9-digit TIN and 3 to 5 digit branch code. Please use 000 as your branch code if you don't have one (e.g. 999-999-999-000)."

The combined canonical digits are encrypted in `tin_encrypted`. Taxpayer matching and withholding aggregation continue to use the first nine digits. Existing historical versions keep their IDs, decisions and hashes; storage migration combines their encrypted identifiers without creating a tax correction. Legacy office metadata is retained only in historical versions, excluded from responses and new versions. Editable drafts remove the retired keys.

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


**Document metadata.** For every uploaded business or compliance document, store: document type, document number, upload date and time, uploading user, organization, file reference, submission status, verification status, Admin reviewer, Admin remarks, verified issue date, verified expiration date, Not Applicable expiration status, replacement or superseded-document reference and audit reference.

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


Use structured Philippine address fields, not a single unvalidated text blob. Coordinates are stored **separately** from the human-readable structured address: coordinates support geospatial computation; the structured address supports presentation, administrative classification, verification, filtering and reporting.

**Map behavior.** The map uses the approved Google Maps integration for the configured environment. Provider credentials stay in protected server or environment configuration and are never committed or unnecessarily exposed to the client; the browser key and the server key are separate restricted keys. The map initializes only when V2 is the selected step.

The Vendor places or moves a pin. The system attempts to resolve the coordinates into structured address components and may prefill street/building, barangay, city/municipality, province or administrative area, postal code, latitude and longitude. The map appears below the structured address fields at full content width. Latitude and longitude remain system-managed and are not displayed as form fields.

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

**Review summary.** Grouped by step, showing each requirement with its level, status, blocking reason where applicable, and a jump link. Unsaved edits are listed explicitly. Progress saves automatically on step changes and Finish Later; final submission saves the latest form and promotes pending evidence atomically. No manual Save Verification Draft prerequisite applies. Saved pending documents remain separate from Admin submissions.

**Submission validation.** The server validates, and the UI mirrors: Business Type · required legal-identity information · required legal-name information · required government-issued identity evidence · Legal Business Name · Public Store Name · Date of Establishment · verified Store Email · required Store Phone Number · Registered Business Address · required geolocation/address information · Supplier Type · Supplier Niches · required primary registration evidence · required LGU documentation · required BIR registration information · required Tax Profile fields · applicable declaration information · supported file types · maximum file sizes · required document numbers · required acknowledgments · other applicable conditional requirements · Privacy Notice acknowledgment.

A missing or invalid item blocks submission and the response identifies the **exact** requirement to complete or correct — never a generic failure.

**After submission.** Store Verification moves to `PENDING_VERIFICATION`. Submission does not mean the Vendor is verified.

**Confirmation page.** Dedicated page with: "Business information and documentation successfully submitted. Your Store Verification is awaiting Admin review." and a **Proceed to Store Setup** action. The Vendor may begin Store Setup immediately and is not required to wait for Admin approval. The Store still cannot be activated until every mandatory Store Verification requirement reaches its required successful final status and all other Store Activation conditions pass.

---

## 9. Store Setup — S1 to S6

Independent checklist. May begin after Store Verification is submitted.

The required Setup Checklist has five entries: Public Store Profile, Bulk Capability, Fulfillment Method, Xendit TEST Connection, and Store Operation. Delivery Configuration is evaluated within Fulfillment Method when delivery applies. Store Media is a subsection of Public Store Profile, and Team Accounts remains optional outside the checklist and activation gate. Public Store Profile completes only when its saved name and description and persisted clean Logo and Banner are present; removal or clearing required data recalculates its status and progress. Valid Store Setup edits auto-save with version checks, and the API snapshot supplies the current checklist.

**S1 Public Store Profile.** Editable form plus a marketplace-style preview with banner, overlapping logo, name and description. Text changes appear immediately. Store Media is a subsection beside the editor and preview; a successful upload refreshes the preview without discarding unsaved fields. Missing media shows structured placeholders; a failed preview offers retry. Legal fields cannot be edited here. Private staff contacts, tax data and evidence are excluded from the profile and the preview. Media is validated for supported type, maximum size, safety, appropriate content, intellectual-property requirements and accessibility metadata. Operating hours and additional gallery media are not implemented by the current surface and must not be fabricated in the preview.

**S2 Fulfillment Configuration.** Bulk Order Capability — **Yes** enables both Item-Based and Project-Based procurement eligibility; **No** enables Item-Based procurement only. Enabling Bulk Order Capability does not create a competitive RFQ bidding queue, auction, or automatic vendor competition mechanism, and changing this setting later must never modify, cancel, or rewrite an already accepted order.

Services Capability — **Self-Pickup, Vendor Delivery, or Both**. **Delivery Configuration is conditionally required.** When the Vendor selects **Self-Pickup only**, Delivery Configuration is marked `NOT_APPLICABLE`; this hides the Delivery Configuration. When the Vendor selects **Vendor Delivery** or **Both**, Delivery Configuration is displayed and becomes required before Store Activation.

For Vendor Delivery, the Vendor may add and configure **as many delivery vehicles as needed**. Each configured vehicle must include:

| **Field**                             | **Description**                                                                                  |
| ------------------------------------- | ------------------------------------------------------------------------------------------------ |
| Vehicle Category                      | Identifies the general class of vehicle                                                          |
| Vehicle Type, where applicable        | Identifies the specific vehicle type under the selected category                                 |
| Vehicle Name                          | Vendor-defined name used to identify the vehicle or vehicle configuration                        |
| Vehicle Brand                         | Brand or manufacturer of the vehicle, where applicable                                           |
| Vehicle Image                         | Vendor-uploaded image of the vehicle shown where relevant                                        |
| Number of Vehicles                    | Positive integer representing the number of usable vehicles under the configuration              |
| Maximum Weight Capacity (kg)          | Maximum supported cargo payload                                                                  |
| Mixer Capacity (m³), where applicable | Maximum ready-mixed concrete volume supported by a Concrete Mixer Truck / Transit Mixer          |
| Cargo Length (m)                      | Usable cargo-space length                                                                        |
| Cargo Width (m)                       | Usable cargo-space width                                                                         |
| Cargo Height (m)                      | Usable cargo-space height                                                                        |
| Heavy Vehicle Classification          | Indicates whether the vehicle is subject to applicable heavy-vehicle or site-access restrictions |
| Base Fee (₱)                          | Fixed delivery amount applied per applicable trip                                                |
| Per-Kilometer Rate (₱/km)             | Distance-based delivery charge                                                                   |
| Maximum Delivery Distance (km)        | Maximum supported delivery service distance                                                      |

For **Maximum Delivery Distance**, MateryalPH provides a **map interface with a visual delivery-radius overlay** centered on the Vendor's configured store or fulfillment location. When the Vendor enters or changes the maximum delivery distance, the map updates the radius to visually represent the approximate geographic coverage of that vehicle configuration.

The displayed radius represents the configured delivery coverage and does not guarantee that every destination inside the radius is accessible. Actual fulfillment eligibility may still depend on road accessibility, heavy-vehicle restrictions, routing conditions, site-access restrictions, and other applicable delivery constraints.

Supported vehicle categories include:

* Motorcycle
* Pickup
* Van
* Truck

### Truck Types

**Truck types** may include:

* Box Truck
* Wing Truck
* Flatbed Truck
* Concrete Mixer Truck / Transit Mixer
* Custom Vehicle Type

A **Concrete Mixer Truck / Transit Mixer** is a specialized vehicle intended specifically for transporting **ready-mixed concrete** from the batching or supply location to the delivery or construction site.

When **Concrete Mixer Truck / Transit Mixer** is selected, the standard vehicle-identification and operational fields remain applicable, including:

* Vehicle Category
* Vehicle Type
* Vehicle Name
* Vehicle Brand
* Vehicle Image
* Number of Vehicles
* Maximum Weight Capacity (kg)
* Mixer Capacity (m³)
* Heavy Vehicle Classification
* Base Fee (₱)
* Per-Kilometer Rate (₱/km)
* Maximum Delivery Distance (km)

Because a concrete mixer does not use a conventional cargo compartment in the same way as a general cargo truck, the following fields are marked `NOT_APPLICABLE` and hidden for this vehicle type:

* Cargo Length (m)
* Cargo Width (m)
* Cargo Height (m)

For a Concrete Mixer Truck / Transit Mixer, **Mixer Capacity (m³)** becomes the primary specialized capacity field used to determine how much ready-mixed concrete the vehicle can transport per trip.

### Van Types

**Van types** may include:

* Compact / Mini Panel Van
* Mid-Size Cargo Van
* Full-Size Cargo Van
* Custom Vehicle Type

### Pickup Types

**Pickup types** may include:

1. Compact Pickup
2. Mid-Size Pickup
3. Heavy-Duty Pickup
4. Custom Vehicle Type

### Custom Vehicle Type

**Custom Vehicle Type** — a Vendor may configure a custom vehicle type when the available predefined vehicle types do not appropriately represent the vehicle being used.

To help Vendors make an appropriate selection, MateryalPH must provide a short and understandable description for every predefined Vehicle Category and Vehicle Type.

When **Custom Vehicle Type** is selected, the Vendor must provide the custom vehicle type name and all applicable operational information required by the fulfillment recommendation logic, including capacity, cargo dimensions or specialized capacity, delivery fees, maximum delivery distance, heavy-vehicle classification, and other applicable constraints.

The exact **Vehicle Category** and **Vehicle Type** must remain distinguishable. For example, **Truck** may be the Vehicle Category while **Flatbed Truck** or **Concrete Mixer Truck / Transit Mixer** is the corresponding Vehicle Type.

---

### Fulfillment Recommendation Logic

The configured vehicle information is used by MateryalPH to recommend an appropriate delivery vehicle for an order. The system automatically determines the **most suitable configured and available vehicle offered by the Vendor** by evaluating the physical and operational requirements of the order.

For normal cargo vehicles, the recommendation may use the product or combined order's actual weight and cargo dimensions, including length, width, and height, together with a **volumetric or dimensional weight calculation** where applicable.

The vehicle recommendation may consider:

* Actual Order Weight
* Volumetric / Dimensional Weight
* Cargo Length, Width, and Height
* Required Material Volume (`m³`), where applicable
* Mixer Capacity (`m³`), where applicable
* Vendor Vehicle Weight Capacity
* Vendor Vehicle Cargo Dimensions
* Delivery Distance
* Vehicle Availability
* Site-Access Restrictions
* Number of Required Vehicles
* Number of Required Trips
* Heavy-Vehicle Restrictions
* Other approved fulfillment constraints

### Ready-Mixed Concrete and Mixer-Truck Logic

The **Concrete Mixer Truck / Transit Mixer recommendation logic applies specifically to ready-mixed concrete products**.

When an order contains ready-mixed concrete that requires mixer-truck delivery, MateryalPH does not rely on normal cargo length, width, and height calculations for vehicle suitability. Instead, the system evaluates the required quantity of ready-mixed concrete in cubic meters (`m³`) against the configured **Mixer Capacity (`m³`)** of the Vendor's available Concrete Mixer Trucks / Transit Mixers.

The recommendation may additionally consider:

* Required ready-mixed concrete volume (`m³`)
* Mixer Capacity (`m³`) per vehicle
* Number of available mixer trucks
* Number of required trips
* Maximum Weight Capacity
* Delivery Distance
* Maximum Delivery Distance
* Vehicle Availability
* Heavy-Vehicle Classification
* Site-Access Restrictions
* Applicable delivery fees

For example, if an order requires more ready-mixed concrete than one configured mixer truck can transport in a single trip, MateryalPH may identify that the order requires **multiple mixer trucks, multiple trips, or a combination of both**.

This specialized mixer-truck calculation must not automatically be applied to ordinary cement products such as **bagged cement**. Bagged cement and other conventional construction materials continue to use the normal cargo weight, dimensions, capacity, and vehicle-suitability logic.

### Volumetric / Dimensional Weight

Where volumetric or dimensional weight is applicable, MateryalPH uses the product or combined shipment dimensions to estimate the cargo space required by the order.

The calculation is used together with:

* Actual physical weight
* Cargo dimensions
* Vehicle maximum weight capacity
* Vehicle usable cargo dimensions

The resulting calculation is used only as part of the vehicle-suitability and fulfillment-recommendation logic. It does not by itself automatically determine or finalize the Vendor's delivery arrangement.

### Heavy-Vehicle Restrictions and Alternative Drop-Off Zone

During ordering, the Buyer may indicate whether the delivery destination is subject to a known **Heavy-Vehicle Restriction** using **Yes** or **No**.

If the Buyer selects **Yes**, the Buyer must specify an **alternative drop-off zone** where the applicable delivery vehicle can reasonably unload the materials without entering the restricted area.

The system must retain both:

* The Buyer's intended delivery or project location
* The alternative drop-off zone

The alternative drop-off zone becomes the applicable vehicle delivery point for fulfillment and delivery-distance calculations when the restriction applies.

If the Buyer selects **No**, the Buyer's specified delivery location is used as the intended drop-off point, subject to normal routing, accessibility, Vendor confirmation, and other applicable fulfillment validation.

The Buyer's Heavy-Vehicle Restriction response assists the recommendation process but must not be treated as a guarantee that the selected road or site is legally or physically accessible. The Vendor remains responsible for confirming the practical delivery arrangement before finalization.

### Vehicle Eligibility

An unconfigured, incomplete, unavailable, disabled, or otherwise ineligible vehicle must never appear as a valid fulfillment recommendation. The system must evaluate only the vehicles currently configured and available from the Vendor fulfilling the applicable order.

The configured vehicle information is used by MateryalPH to recommend an appropriate delivery vehicle for an order. The system automatically determines the most suitable configured and available vehicle offered by the vendor by evaluating the order's physical delivery requirements. The recommendation may use the product or combined order's weight and cargo dimensions, including width, length, and height, together with a volumetric or dimensional weight calculation where applicable.

The vehicle recommendation may consider:
Actual Order Weight
Volumetric / Dimensional Weight
Cargo Length, Width, and Height
Vendor Vehicle Weight Capacity
Vendor Vehicle Cargo Dimensions
Delivery Distance
Vehicle Availability
Site-Access Restrictions
Number of Required Vehicles or Trips
Heavy-Vehicle Restrictions 

### Vendor Confirmation

MateryalPH **does not automatically dispatch a vehicle or assign the recommended vehicle as final**.

The system's vehicle recommendation remains advisory until confirmed by the Vendor.

The Vendor must review the recommended vehicle and may:

* Confirm the recommended vehicle
* Select another eligible configured vehicle
* Use multiple vehicles
* Configure multiple trips where applicable

before finalizing the delivery arrangement.

Where the order cannot be fulfilled by a single suitable vehicle, or where multiple vehicles or multiple delivery trips are required, MateryalPH may identify the capacity limitation and assist the Vendor in determining an appropriate arrangement.

The Vendor must confirm:

* Selected vehicle or vehicles
* Number of vehicles
* Number of trips
* Applicable delivery arrangement
* Final applicable delivery charge

before the Buyer is presented with and pays the finalized delivery charge.

### Accepted-Order Delivery Snapshot

Once an order and its delivery arrangement are accepted, MateryalPH stores an immutable **delivery snapshot** containing the fulfillment information applicable to that order, including where relevant:

* Vehicle Category
* Vehicle Type
* Vehicle Name
* Vehicle Brand
* Vehicle capacity
* Cargo dimensions
* Mixer Capacity (`m³`), where applicable
* Number of vehicles
* Number of trips
* Heavy-Vehicle Classification
* Applicable drop-off location
* Base Fee
* Per-Kilometer Rate
* Applicable delivery distance
* Final delivery charge
* Other relevant fulfillment details

Editing, replacing, disabling, or deleting a vehicle configuration later must **never modify the delivery snapshot, delivery charge, vehicle arrangement, or fulfillment terms of an already accepted order**. Any subsequent vehicle configuration changes apply only to future fulfillment recommendations and future orders.

**S3 Xendit TEST Connection.** A backend-created xenPlatform TEST Owned sub-account is mandatory for every Tier 2 Vendor seeking Store Activation, regardless of actual MateryalPH Business Type. This account is platform-controlled for simulated payments; LIVE merchant onboarding is a separate future workflow. Keep one step title and explain that Xendit is MateryalPH's payment service provider.

The Vendor Owner clicks **Connect Xendit**, subject to current PAYMENT_CONFIGURATION authority. MateryalPH calls `POST /v2/accounts` with the server-only master TEST credential, `type=OWNED`, trusted store name in `public_profile.business_name`, and the verified Store Email when available, otherwise the authenticated Owner email. Xendit requires an email field for account creation but sends no Vendor registration invitation in this TEST flow. TEST onboarding never overwrites the Vendor's actual MateryalPH Business Type.

Validate the provider response, account ID, Owned type, and matching operation identity before storing the backend-owned association. A create response remains **PENDING** until a separate backend `GET /v2/accounts/{id}` confirms `LIVE`; the Owner may select **Check account status** again if needed. Only authoritative provider `LIVE` becomes `CONNECTED_TEST` and displays **Xendit — Connected** with a visible TEST indicator. Browser-supplied identifiers never establish a connection. Xendit's TEST sub-accounts cannot log in or be activated, so no hosted partner registration link is presented as a way to complete TEST setup.

Reuse an existing confirmed association. Reserve creation under an organization lock and release the lock before networking. Explicit provider rejections allow retries; uncertain attempts retain their reservation for safe investigation instead of automatically creating another account. Audit attempts, failures and success without provider payloads or credentials.

**DEMO — No real funds or BIR filing.** TEST connection does not activate live payments or establish production KYC, BIR registration, statutory withholding compliance, or government approval. Future LIVE onboarding must follow Xendit's applicable production invitation, merchant verification, KYC and activation rules; it is outside this implementation. See `services/api/docs/xendit-onboarding.md`.

**S4 Team Accounts.** Vendor Team setup is **optional** and does not block Store Activation. The Vendor Owner may create Team Accounts before or after Store Activation.

A Vendor Team Account belongs to an individual employee and is connected to the existing Vendor organization. Creating a Team Account does **not** create another store or Vendor organization. Each employee receives their own individual login account, and the Vendor Owner's credentials must never be shared with employees.

If no Vendor Team Accounts are created, all operational functions that would otherwise be assigned to employees remain available through the **Vendor Owner (Main Store Account)**.

---

## Team Invitation Information

Each Team Account invitation records:

* Employee full name
* Email address
* Contact number, where required
* Vendor organization
* Exactly one fixed role
* Invitation expiration
* Inviting user
* Invitation status
* Creation date
* Acceptance date, where applicable

The employee receives the invitation through the provided email address.

All invitation, acceptance, membership, role, activation, deactivation, and staff-management changes must be audit-logged.

---
### Team Account Logic

# Vendor Owner — Main Store Account

The **Vendor Owner** is the highest-level account within the Vendor organization and retains overall control of the store.

The Vendor Owner can monitor employee-attributed activities, including:

* Employee responsible
* Action performed
* Affected record
* Date and time
* Current status
* Relevant before-and-after changes, where applicable

This allows Vendor activities to be traced to the individual employee who performed them.

The Vendor Owner retains access to all Vendor Portal sections and may perform all permitted organization-level functions, including:

* Store administration
* Orders
* Fulfillment
* Customer communication
* Disputes and appeals
* Product and inventory management
* Vehicle management
* E-Invoices
* Financial information
* Analytics
* Team Account administration
* Team activity monitoring
* Store Profile management
* Business and compliance document management

Where a function is delegated to an employee, the Vendor Owner retains oversight of that function.

---

# Staff Roles

Available Vendor Team roles are:

1. **Store Manager**
2. **Store Staff**
3. **Customer Service Staff**
4. **Inventory Staff**
5. **Fulfillment Staff**

Each Team Account has **exactly one fixed Vendor role at a time**.

Roles must not be arbitrarily stacked or combined.

The Vendor Owner selects the role that most closely represents the employee's actual responsibilities.

Except for specifically defined settings such as Store Manager staff-management delegation and Customer Service dispute handling, the Vendor Owner must not manually construct arbitrary permissions for an employee. Each role follows its predefined work scope.

Access is determined by:

* Vendor organization membership
* Fixed assigned role
* Defined role permissions
* Approved role-specific settings
* Store activation status
* Resource ownership or assignment
* Backend authorization
* Applicable recent-authentication requirements

**Frontend visibility does not replace backend authorization.**

A hidden sidebar item must also be protected at the route, API, service, and resource-authorization levels.

---

# Role Definitions and Work Scope

## 1. Store Manager

The **Store Manager** is the highest operational employee role below the Vendor Owner.

The Store Manager oversees normal day-to-day store operations and may manage:

* Orders
* Customer inquiries
* Quotations
* Fulfillment coordination
* Products and inventory
* Vehicle configurations
* Operational E-Invoices
* Disputes and appeals
* Store operations
* Operational notifications
* Store performance information

The Store Manager does not become a co-owner and cannot perform protected Owner-only functions.

A Store Manager may manage Team Accounts only when the Vendor Owner explicitly enables the **Allow this Store Manager to manage staff accounts** setting.

---

## 2. Store Staff

**Store Staff** is the all-round operational role intended primarily for small and medium-sized hardware stores where one employee may perform both customer-service and inventory responsibilities.

Instead of requiring the Vendor Owner to assign multiple roles to the same employee, Store Staff combines the normal work scope of:

* Customer Service Staff
* Inventory Staff

Store Staff may therefore:

* Monitor incoming orders
* Review available stock before accepting or processing an order
* Accept permitted orders
* Respond to Buyer inquiries
* Handle customer conversations
* Prepare and manage quotations
* Handle sales transactions assigned to them
* Manage products
* Manage product variants
* Update inventory quantities
* Perform permitted price changes
* Maintain applicable product information
* Handle permitted product compliance submissions and responses
* Handle disputes when dispute access is enabled by the Vendor Owner

Store Staff does **not** automatically receive Fulfillment Staff privileges, financial access, Team Account administration, or Owner-level permissions.

---

## 3. Customer Service Staff

The **Customer Service Staff** role focuses on Buyer-facing sales and customer communication.

Customer Service Staff may:

* Monitor incoming orders
* View relevant available stock needed to determine whether an order can be accepted
* Accept or process permitted orders
* Respond to Buyer inquiries
* Manage customer conversations
* Prepare quotations
* Handle sales they are responsible for or explicitly assigned to
* Access applicable E-Invoice information for assigned sales
* Receive relevant operational notifications
* Handle disputes and appeals when enabled by the Vendor Owner

Customer Service Staff may **view stock information** needed for sales decisions but must not directly perform inventory administration unless assigned the Store Staff role instead.

### Customer Service Dispute Setting

Dispute access for Customer Service Staff and Store Staff is **enabled by default**.

The Vendor Owner may disable:

**Allow staff to handle disputes and appeals**

If disabled:

* Customer Service Staff cannot access Disputes & Appeals
* Store Staff cannot access Disputes & Appeals
* New disputes are handled by the Vendor Owner and, where permitted, the Store Manager

Existing staff activity remains preserved in the audit history.

---

## 4. Inventory Staff

The **Inventory Staff** role focuses on products, inventory, stock accuracy, variants, pricing, and applicable product compliance work.

Inventory Staff may:

* Create or update permitted products
* Manage product variants
* Update stock quantities
* Review stock allocations
* Perform permitted price changes
* Maintain product information
* Upload applicable product documents
* Handle applicable PS/ICC-related product submissions
* Update compliance documents associated with their assigned product responsibilities
* Respond to applicable product compliance review requirements
* Receive inventory-related notifications

Inventory Staff may view limited order information where necessary to understand stock allocation or reservation, but they must not accept customer orders, manage customer quotations, handle normal customer conversations, manage disputes, or perform fulfillment milestones solely because they can view the related inventory requirements.

---

## 5. Fulfillment Staff

The **Fulfillment Staff** role handles the physical preparation and delivery stage of accepted orders.

Fulfillment Staff may:

* View orders assigned to them
* Process assigned fulfillment activities
* Update fulfillment milestones
* Prepare orders for pickup
* Process orders for Vendor Delivery
* View the selected delivery vehicle relevant to an assigned delivery
* Upload delivery evidence or proof
* Record applicable fulfillment completion information
* Receive fulfillment-related notifications
* Communicate directly with the Buyer through the dedicated fulfillment conversation

Fulfillment Staff must not modify general product inventory administration, pricing, Vendor financial settings, Team Accounts, Store Profile information, or vehicle configurations unless such capabilities are introduced through a future approved role policy.

---

# Vendor Portal Sidebar Access Matrix

The Vendor Portal sidebar contains the following sections:

* Dashboard
* Orders
* Fulfillment
* Messages
* E-Invoices
* Notifications
* Disputes & Appeals
* My Products
* Vehicles
* Wallet
* Store Performance
* Earnings
* Team Accounts
* Team Tracking
* Store Profile

Access must follow the matrix below.

| **Sidebar Section**    | **Vendor Owner**         | **Store Manager**                                   | **Store Staff**                        | **Customer Service Staff**   | **Inventory Staff**                         | **Fulfillment Staff**                             |
| ---------------------- | ------------------------ | --------------------------------------------------- | -------------------------------------- | ---------------------------- | ------------------------------------------- | ------------------------------------------------- |
| **Dashboard**          | Full                     | Operational                                         | Operational                            | Role-specific                | Role-specific                               | Role-specific                                     |
| **Orders**             | Full                     | Full operational                                    | Sales/order management                 | Sales/order management       | Limited stock-related view                  | Assigned orders only                              |
| **Fulfillment**        | Full                     | Full operational                                    | View relevant order fulfillment status | View relevant order status   | No direct fulfillment control               | Assigned fulfillment management                   |
| **Messages**           | All conversations        | Operational conversations                           | Customer/sales conversations           | Customer/sales conversations | No normal customer-chat access              | Fulfillment threads only                          |
| **E-Invoices**         | Full                     | Operational                                         | Assigned/permitted sales               | Assigned/permitted sales     | No                                          | View only where required for assigned fulfillment |
| **Notifications**      | All Vendor notifications | Relevant operational notifications                  | Relevant notifications                 | Relevant notifications       | Relevant inventory/compliance notifications | Relevant fulfillment notifications                |
| **Disputes & Appeals** | Full                     | Operational                                         | Conditional                            | Conditional                  | No                                          | No direct dispute management                      |
| **My Products**        | Full                     | Full operational                                    | Product/inventory management           | Stock view only              | Product/inventory management                | Assigned-order product view only                  |
| **Vehicles**           | Full                     | Manage                                              | No configuration access                | No                           | No                                          | Assigned vehicle information only                 |
| **Wallet**             | Full                     | No protected financial access                       | No                                     | No                           | No                                          | No                                                |
| **Store Performance**  | Full                     | View operational analytics                          | No                                     | No                           | No                                          | No                                                |
| **Earnings**           | Full                     | No                                                  | No                                     | No                           | No                                          | No                                                |
| **Team Accounts**      | Full                     | Conditional delegation                              | No                                     | No                           | No                                          | No                                                |
| **Team Tracking**      | Full                     | Limited when staff-management delegation is enabled | No                                     | No                           | No                                          | No                                                |
| **Store Profile**      | Full                     | View operational store information                  | Limited view                           | Limited view                 | Limited view                                | Limited view                                      |

---

# Sidebar Visibility Rules

The Vendor Portal must dynamically show or hide sidebar sections according to the signed-in user's role and applicable permissions.

A user must not see a normal navigational entry for a section they have no permission to access.

For example:

* Inventory Staff should primarily see **Dashboard, relevant Orders, Notifications, My Products, and Store Profile**
* Customer Service Staff should primarily see **Dashboard, Orders, Messages, E-Invoices, Notifications, applicable Disputes & Appeals, and Store Profile**
* Fulfillment Staff should primarily see **Dashboard, assigned Orders, Fulfillment, fulfillment Messages, Notifications, assigned vehicle information where required, and Store Profile**
* Store Staff should see the combined operational sections required for sales, customer service, and inventory work
* Store Manager should see most operational sections but not protected Owner financial or ownership functions
* Vendor Owner sees the complete Vendor Portal

The Dashboard itself must also be **role-aware**. Employees must not receive Owner-only statistics, financial information, compliance information, or administrative controls simply because they can access the Dashboard page.

---

# Financial Access Rules

The following sidebar modules are considered financially sensitive:

* Wallet
* Earnings

By default, these modules are **Vendor Owner only**.

Employees, including Store Managers, must not:

* Access or modify bank account information
* Access or modify payout credentials
* Change settlement information
* Initiate protected withdrawal or payout operations
* Replace financial account ownership information

A future approved Owner-level policy may introduce carefully scoped financial permissions, but such permissions must not be assumed by the current role model.

Operational E-Invoice access does not automatically grant access to Wallet, Earnings, payout credentials, or other protected financial information.

---

# Store Profile Access

The **Vendor Owner** has full Store Profile access.

Employees may view only the Store Profile information necessary to perform their responsibilities.

Store Manager may view operational store information but must not modify protected ownership, legal, payout, or business-verification information unless specifically permitted by an approved future policy.

Other employee roles receive only the minimum Store Profile visibility required to identify the organization they work for and perform their assigned responsibilities.

---

# Attribution Rule

Each employee's access and activity attribution are determined by the role assigned by the Vendor Owner.

The system records actions performed by each employee and attributes them to the individual account that actually performed the action.

Audit information may include:

* Employee responsible
* Employee role at the time of the action
* Action performed
* Affected record
* Previous value, where applicable
* New value, where applicable
* Date and time
* Current status
* Related order, product, conversation, dispute, or fulfillment record

The Vendor Owner retains overall oversight and can monitor employee-attributed activities.

Employees must not receive attribution for actions performed by another employee.

Changing an employee's role later must not rewrite historical attribution. Historical records preserve the employee and role context applicable when the action occurred.

---

# Message Attribution

For **Messages**, attribution is based on the employee who actively handles the conversation.

When a Buyer sends a normal product, quotation, or order inquiry to the Vendor, the conversation may initially be routed to an available:

1. Store Staff
2. Customer Service Staff
3. Store Manager
4. Vendor Owner

depending on the Vendor's available Team Accounts and applicable assignment rules.

When an authorized employee responds to or takes ownership of the conversation, the system records that employee as the **Message Handler**.

Any:

* Reply
* Quotation
* Attachment
* Order-related action
* Assignment
* Transfer
* Conversation closure

is attributed to the employee who actually performed the action.

If another authorized employee takes over the conversation, the system records the new employee as the current handler while retaining the complete previous handling history.

The transfer must never erase the previous employee's activity.

---

# Fulfillment Message Thread

Fulfillment Staff do not receive unrestricted access to normal customer-service conversations.

When an applicable order reaches a fulfillment stage such as:

* **Ready for Pickup**, or
* **Out for Delivery**

MateryalPH creates or enables an **order-specific fulfillment message thread** associated with that order.

Authorized Fulfillment Staff assigned to the order may use this thread to communicate with the Buyer regarding matters such as:

* Pickup coordination
* Delivery arrival
* Delivery location clarification
* Alternative drop-off coordination
* Access restrictions
* Unloading coordination
* Delivery delays
* Delivery proof
* Other fulfillment-related communication

The fulfillment conversation remains associated with the Order Details and must not provide Fulfillment Staff with access to unrelated Buyer conversations.

---

# Store Manager Delegation

When the Vendor Owner creates or edits a Store Manager, the system displays an off-by-default setting:

**Allow this Store Manager to manage staff accounts**

If disabled, Team Account administration remains Owner-only.

If enabled, the Store Manager may manage only permitted non-manager roles:

* Store Staff
* Customer Service Staff
* Inventory Staff
* Fulfillment Staff

The delegated Store Manager may:

* Send staff invitations
* View invitation status
* Resend permitted invitations
* Edit permitted non-manager staff information
* Change a permitted non-manager employee from one non-manager role to another
* Activate or deactivate permitted non-manager Team Accounts

All delegated staff-management actions must notify or otherwise remain visible to the Vendor Owner and must be recorded in the audit trail.

A delegated Store Manager must **not**:

* Create another Store Manager
* Modify another Store Manager
* Deactivate another Store Manager
* Grant Store Manager delegation
* Change their own role
* Increase their own permissions
* Change the Vendor Owner
* Transfer ownership
* Modify protected payout credentials
* Delete or alter audit records
* Perform Owner-only functions

---

# Restricted Actions

Regardless of employee role, Team Account employees must never be allowed to:

1. Change or transfer the Vendor Owner
2. Access or modify bank or payout credentials unless explicitly supported by a future approved Owner-level policy
3. Access data belonging to another Vendor organization
4. Delete, rewrite, or tamper with Vendor activity or audit logs
5. Delete their own Team Account in a way that bypasses organization administration or audit retention
6. Grant permissions they do not possess
7. Create another Vendor organization under the same employee Team Account
8. Change protected Vendor ownership information
9. Bypass Store Activation, account-state, or role-based restrictions
10. Access a resource merely by manually entering a hidden URL or API endpoint
11. Modify historical records in a manner that destroys required attribution
12. Elevate their own role or permissions

The **Vendor Owner remains the highest-level account within the Vendor organization**.

---

# Staff Invitation and First Login

After the Vendor Owner or an authorized delegated Store Manager creates a Team Account invitation, MateryalPH sends an individual invitation link to the employee's email address.

The employee uses the invitation to establish their individual login identity.

After successful sign-in, a Team Account **does not repeat Vendor Onboarding**.

Vendor Onboarding belongs to the Vendor organization rather than the individual employee account.

The employee is directed to the Vendor Dashboard according to:

* Assigned role
* Applicable role-specific settings
* Vendor organization
* Store activation status
* Resource assignment
* Backend authorization

---

# Staff Access Before Store Activation

If a Team Account has been activated while the Vendor organization is still awaiting Store Activation, the employee may sign in, but the existence of the Team Account must **not** provide full marketplace access.

The Vendor Portal remains in the appropriate **Limited-Access state**.

The employee sees only functions permitted by both:

1. The Vendor organization's current onboarding and activation state
2. The employee's assigned role and applicable permissions
3. The employee's own Account Profile

The dashboard displays a notice such as:

> **This store is not yet active for marketplace participation. Required onboarding and verification must be completed before marketplace features become available.**

Staff without authorization to modify onboarding or verification requirements must not be able to alter those requirements.

Role access never overrides Store Activation requirements.

---

# Staff Access After Store Activation

Once the Vendor organization is activated, employees gain access to the applicable marketplace sections according to their assigned role.

Store Activation does **not** grant every Team Account full Vendor Portal access.

The system must continue enforcing:

* Organization isolation
* Role-based access control
* Resource-level authorization
* Assignment restrictions
* Role-specific settings
* Store-status requirements
* Audit attribution
* Protected Owner-only functions

The Vendor Owner retains the highest organization authority at all times.

**S5 Store Operation.** The Vendor sets the normal weekly public schedule for Monday through Sunday. Every day must explicitly be Open or Closed. An Open day requires Opening Time and Closing Time in Philippine local time; Closing Time must be later on the same day. A Closed day has no times. Overnight periods are not supported. Copying hours to selected days is a convenience only; every day remains independently editable. The saved schedule is structured Store Setup data, appears on the public Store Profile after activation, and is required before setup completion. Later changes are attributed to the acting Vendor Owner in the audit log and update the current public schedule without approving verification, changing Xendit, changing fulfillment, or activating the store. The date-override data model is distinct from the weekly schedule; an explicitly configured date entry takes precedence for that date. No holiday entries are created automatically.

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
| `vendor_tax_profiles` / `vendor_tax_profile_versions` | Single organization-level legal-tax source | `taxpayer_key`, `tin_encrypted`, `tin_hash`, `vat_status_declared`, `vat_status_verified`, `declaration_claim`, `declaration_year`, `effective_from/to`, `representative_version_id` |
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
| `PATCH /vendor/onboarding/verification/draft` | Accepts business type, legal identity, representative details, combined `tin` (9-digit taxpayer number plus 3 to 5 digit branch code), VAT declaration, declaration claim and year, address, classification. `409` on stale `lock_version` |
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

**Structure and navigation.** Four verification steps and six setup steps render. Only the selected step is visible and keyboard reachable. Focus transfers to the step heading. Switching steps preserves native values and automatically saves partial progress with version checks. Finish Later saves automatically before returning to the dashboard. The review step lists unsaved edits and private saved progress; submission automatically persists the current package without a manual save prerequisite. Completion indicators come from the server.

**Business Type.** Each of the five values renders only its applicable identity, evidence and tax fields. Changing type recalculates requirements before save, stops counting superseded evidence, and reopens affected approved requirements for review.

**Legal identity.** Individual name fields and the Owner prefill behave correctly; the prefill creates no verified fact. Company name required for the four non-individual types. OPC can carry both incorporator identity and corporate name.

**Representative and authority.** Officer already shown in accepted records can satisfy the requirement from existing evidence; an employee or accountant cannot and is forced to upload. Sole proprietor path yields `NOT_APPLICABLE` with a reason. Final attestation without an approved scope is refused. Replacing the representative preserves the prior record, reopens review and leaves previously executed agreements bound to the old record. A decision with a stale `lock_version` is rejected.

**TIN.** Combined 12–14 digits or hyphenated 9-digit TIN plus 3–5 digit branch suffix accepted; missing suffix, letters and malformed formatting rejected. Separate office and branch request fields are prohibited. Stored values are encrypted and masked on read.

**Store Email.** Exactly one named `store_email` input exists in the DOM. Initial read-only state, change, confirm, re-change. Verified badge only when the displayed normalized address matches the server-confirmed address. A pending replacement never inherits verification. Editing after requesting a code clears the challenge. Request failure and confirmation failure are recoverable. Draft payloads carry the right value. Input and action widths and heights stay stable between `Change` and `Send Code`.

**Store Phone.** No OTP path exists. Owner prefill works.

**Tax.** Declared VAT does not set verified VAT. COR upload does not approve the Tax Profile. A COR with no expiry accepts Expiration: Not Applicable and rejects an invented date. Sworn Declaration YES requires claim + taxable year + PDF and grants no relief. Declaration NO records standard treatment. Missing optional declaration alone does not block activation; a missing mandatory BIR registration does.

**Address.** Manual-only completion succeeds with no map interaction. Map pin resolves and displays latitude and longitude. Incomplete geocode requires manual completion. A stale resolve response is ignored. Provider failure degrades to manual entry. Coordinates and structured address are stored separately. A critical address change creates a version and reopens review.

**Classification.** Multi-niche selection persists. Other Category accepts multiple custom labels without creating taxonomy entries. Prohibited rental phrasing is rejected case-insensitively and after whitespace/punctuation normalization. Selecting Tools and Equipment does not permit rental inventory.

**Privacy and submission.** Submission without acknowledgment is refused. Acknowledgment records user, organization, notice version, timestamp, activity and source, and is stored separately from commercial agreements. Missing Privacy Notice blocks submission with an operational message. Each missing requirement is named exactly. Successful submission sets `PENDING_VERIFICATION` and shows the confirmation page with Proceed to Store Setup.

**Admin.** Sectioned case view. Approve / Return / Reject with required reasons. Verified metadata recorded by the Admin only. `expiration_date < issue_date` rejected. OCR never auto-approves. Correction preserves prior file, metadata, decision, remarks and relationship. Unrelated approved requirements are not reset. Stale decisions rejected.

**Authorization.** Cross-Vendor document access returns a safe `403`/`404`. Unauthorized staff cannot read private evidence. A hidden button never authorizes anything. Activation bypass attempts fail at the backend gate.

**Accessibility and responsiveness.** Browser checks at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px: no horizontal page or stepper overflow, ≥14px step labels, all step buttons within the navigation bounds, one equal-height field row at ≥1024px, matching contact-input geometry, reduced-motion keyboard navigation, and every status conveyed by text or icon in addition to color.


### Checklist presentation and private evidence preview

Store Verification, the Limited Dashboard and the Admin review case share this checklist order:

1. Business information, with distinct sections for business details, registered legal identity, registered business address, supplier classification, Tax Profile, applicable Authority to Act, and privacy acknowledgment.
2. Government ID — Registered legal identity (Sole Proprietorship).
3. Government ID — Authorized Representative, when applicable.
4. Sworn Declaration, when applicable.
5. BIR Certificate of Registration (BIR Form 2303).
6. Business registration.
7. LGU permit evidence.

Each Government ID is one checklist item containing its required front and back; a passport uses its identity page. Non-applicable items and optional certification do not appear in this checklist. Required underlying evidence, version checks, separate Admin decisions and Authority to Act scopes remain enforced. A grouped item is complete only when every applicable underlying requirement is approved/completed. Correction and rejection states remain visible. Store Setup uses the same bordered checklist panel with its existing setup requirements.

In the Admin review case, **Business Information** is one selectable decision for the applicable informational requirements: business type, business details, registered legal identity, registered business address, supplier classification, tax profile, and privacy acknowledgment. The selected panel presents their submitted values together. Its single decision updates those underlying requirement states atomically with version guards. Authority to Act keeps its separate scoped decision. Government ID front and back form one ID review decision, with both current files and the related identity values visible together. BIR COR, business registration, LGU permit, and other documentary requirements keep independent decisions and verified metadata. The selected panel shows submitted information, inline private evidence previews where applicable, relevant verification details, and the Admin decision. Group approval does not bypass tax verification, evidence validation, or the activation gate.

Submitted and saved private files open in an authenticated portal preview panel. The portal fetches the short-lived signed URL with its isolated HttpOnly cookie context, validates the response, and displays only supported PDF/JPEG/PNG content. Closing/unmounting the preview revokes its temporary browser object URL. Signature, ownership, role and clean-scan checks remain server-side; no document becomes public.
