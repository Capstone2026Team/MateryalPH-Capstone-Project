# Vendor Onboarding — Store Verification and Store Setup

For a newly created Vendor Owner account, once the Vendor successfully logs in and completes the required account-registration and account-verification requirements, the system prompts the Vendor Owner to complete the **Vendor Onboarding** process.

Vendor Onboarding prepares the Vendor organization for marketplace participation and consists of two primary sections:

1. **Store Verification**
2. **Store Setup**

The two sections serve different purposes.

**Store Verification** establishes the Vendor's legal, business, tax, regulatory, contact, classification, and registered-location information and submits the applicable requirements for Admin review.

**Store Setup** configures how the Vendor will operate within MateryalPH, including the public store profile, procurement capability, fulfillment configuration, delivery configuration where applicable, payment configuration, and other operational settings.

The Vendor may save progress and return later.

The system must maintain separate progress and review states for Store Verification and Store Setup.

The Vendor does not need to wait for the Admin to finish Store Verification before beginning Store Setup. However, the Vendor's store cannot be activated for marketplace participation until all applicable mandatory activation requirements have been successfully satisfied.

---

# 1. Store Verification

**Store Verification** is the first primary section of Vendor Onboarding.

Store Verification is the process through which the Vendor provides the required legal-business information, contact information, registered business location, supplier classification, tax information, registration documents, permits, and other applicable compliance evidence required to establish and verify the business.

The system must **not display wording such as “Verify Your Identity” in a way that implies automatic business verification**.

Submission of information or documents does not mean the business has already been verified.

Store Verification is completed through **manual Admin review**, supported by system validation and applicable document-verification tools.

The Vendor Portal must clearly communicate the difference between:

* Information entered by the Vendor
* Information submitted for review
* Information pending Admin verification
* Information requiring correction
* Information approved by the Admin

The system must not automatically change Vendor-submitted business information to **Verified** merely because a required field or document was uploaded.

---

## Store Verification Requirement Model

Every Store Verification requirement has two separate properties:

### Requirement Level

A requirement may be:

* **Required**
* **Optional**
* **Conditionally Required**

A conditionally required item becomes mandatory only when a related business type, capability, tax condition, or other configuration makes the requirement applicable.

### Requirement Status

A requirement may have one of the following statuses:

* **Not Started**
* **In Progress**
* **Submitted**
* **Pending Verification**
* **Approved**
* **Changes Required**
* **Rejected**
* **Expired**
* **Not Applicable**

**Required** and **Optional** must not be treated as progress statuses.

For an Admin-reviewed requirement to satisfy activation, its final successful status must normally be **Approved**.

For requirements that do not require Admin verification, the applicable successful status may be **Completed** within the Store Setup checklist.

---

## Business Type

The Vendor selects the legal structure of the business.

The available Business Types are:

1. **Sole Proprietorship**
2. **Partnership**
3. **Corporation**
4. **One Person Corporation (OPC)**
5. **Cooperative**

The system stores each legal structure as a distinct business classification.

A **One Person Corporation** may be treated internally as a corporate subtype for applicable company-registration, tax, and integration rules, while still being presented to the Vendor as its own selectable Business Type.

The selected Business Type determines:

* Which legal-name fields are required
* Which registration authority applies
* Which business registration document must be submitted
* Which supporting identity information is required
* Which applicable tax and verification rules apply

Changing the Business Type after legal-business information has already been submitted must re-evaluate the applicable requirements.

If the change affects previously verified business information, the system must reopen the affected verification requirements for Admin review.

---

# Registered Legal Identity

The legal identity fields displayed by the system depend on the selected Business Type.

---

## Individual Registered Name

**Applies to:** Sole Proprietorship and other cases where an individual taxpayer or registered proprietor must be identified.

The **Individual Registered Name** records the person's complete legal name exactly as it appears on the applicable government-issued identification and business-registration records.

The form contains:

* **Surname**
* **First Name**
* **Middle Name**
* **Suffix** — optional, where applicable

The interface provides:

**☐ Same as Vendor Owner's full legal name**

If selected, the system automatically pre-fills the fields using the Vendor Owner's existing verified or registered account information.

The Vendor must still review the information and confirm that it matches the supporting legal records.

Display helper text such as:

**“Individual Registered Name is your complete legal name as shown on the applicable government-issued identification and registration records.”**

---

## Government-Issued Identification

Where identification of an individual proprietor, incorporator, authorized representative, or other legally relevant person is required, the Vendor provides the applicable government-issued identification.

The system may require:

* **ID Type**
* **ID Number**, where applicable
* **Upload Front Image**
* **Upload Back Image**, when the selected ID contains relevant information on both sides

The identity document must correspond to the individual identified in the applicable legal-identity section.

The system validates required fields and files before submission.

Government-issued identification must be treated as **private verification information**.

It must not be displayed:

* On the public Store Profile
* In Buyer search results
* In public Vendor listings
* To other Vendors
* To Vendor staff who do not have the required permission

---

## Company Registered Name

**Applies to:** Partnership, Corporation, One Person Corporation, and Cooperative where an officially registered organization name is required.

The **Company Registered Name** is the official legal name of the organization as recorded by the applicable registration authority.

The form contains:

* **Company Registered Name**

Display helper text such as:

**“Company Registered Name is the official legal name of the organization as recorded by the applicable government registration authority.”**

The entered value should be consistent with the applicable registration documents submitted by the Vendor.

For an OPC, the organization may therefore have both an applicable incorporator/Owner identity and a registered corporate name where required by the selected verification flow.

---

# Business Information

The following Business Information applies to the Vendor according to the selected legal structure.

---

## Business Name / Trade Name

The **Business Name / Trade Name** refers to the name under which the Vendor publicly operates or conducts business.

---

### Business or Store Name

The Business or Store Name entered during account creation is displayed here by default.

The Vendor may review or change the Store Name during onboarding before final Store Verification submission.

This name represents the Vendor's public-facing marketplace identity and may later appear in:

* The Vendor storefront
* Buyer search results
* Product listings
* Quotations
* Orders
* Messages
* Marketplace recommendations
* Other Buyer-facing interfaces

Where the Vendor does not use a separate trade name, the system may allow the applicable registered taxpayer or legal-business name to be used.

The Store Name must not automatically replace the separate legal-business name fields.

Public Store Name and Legal Business Name must remain separate data fields.

---

## Date of Establishment

The Vendor provides the date when the business was established or officially registered.

The system validates that the date:

* Is valid
* Is not in the future
* Is consistent with the applicable registration evidence where review requires comparison

The Vendor-entered date remains subject to Admin verification where it is treated as a verified business fact.

---

## Store Email

The **Store Email** is the primary email address used for store-related communication, business notifications, marketplace notices, and Vendor administration.

The form contains:

* **Store Email**

The Store Email must be verified before it becomes active.

If the Vendor Owner registered using a verified Google identity, the verified Google email may be pre-filled as the Store Email.

If that email has already been verified through the approved Google authentication process, the system does not require duplicate email ownership verification merely to use the same address.

The interface provides:

**☐ Use a different Store Email**

If selected, the Vendor enters another email address.

The new Store Email must undergo email OTP verification before it replaces the currently verified Store Email.

The flow is:

1. Vendor enters the new Store Email.
2. System validates the email format.
3. System sends a short-lived OTP to the new email address.
4. Vendor enters the OTP.
5. System validates the OTP.
6. If verification succeeds, the new email becomes the Store Email.
7. If verification fails or expires, the existing verified Store Email remains unchanged.

Display helper text such as:

**“This email will be used for store-related communication. A different email address must be verified before it can replace the existing Store Email.”**

---

## Store Phone Number

The Vendor provides the primary phone number used for store-related communication.

The interface includes:

**☐ Same as Vendor Owner phone number**

If selected, the system automatically pre-fills the Store Phone Number using the Vendor Owner's registered phone number.

The Vendor may later change the Store Phone Number through the applicable secure account or Store Profile process.

The phone number is a contact field and must not be treated as SMS-verified unless an approved SMS-verification feature is separately implemented.

---

# Primary Business Contact

The **Primary Business Contact** identifies the principal person responsible for administrative and business communication with MateryalPH.

By default, the Vendor Owner's information is displayed as the initial Primary Business Contact.

The Vendor Owner may add **multiple business contacts**.

Each contact contains:

1. Contact person's full name
2. Position or title
3. Professional or personal email address
4. Mobile number or telephone number

For each business contact, the system records applicable authorization flags such as:

* Authorized for business-verification communication
* Authorized for account-administration communication
* Authorized for general administrative communication

The system must clearly identify one contact as the **Primary Business Contact**.

Only one contact may hold the Primary Business Contact designation at a time.

Additional contacts may coexist without becoming the primary contact.

Changing the Primary Business Contact must create an audit event.

A contact being designated as an authorized representative does not automatically give that person a Vendor Portal user account or staff permissions.

A separate Vendor Team Account invitation is required for system access.

---

# Registered Business Address

The Vendor provides the business's registered or principal operating address applicable to the marketplace account.

The Vendor may provide the address through:

* **Manual Address Entry**
* **Interactive Map Selection**

The interactive map uses the approved Google Maps integration configured for the MateryalPH environment.

Google API keys and other provider credentials must remain in protected environment or server configuration and must not be committed to the repository or exposed unnecessarily to the client.

---

## Manual Address Entry

The Vendor enters the applicable structured address information, including:

* Street, building, unit, or establishment information
* Barangay
* City or municipality
* Province or applicable independent city classification
* Postal code

The system should use structured address fields where practical rather than storing the entire address as one unvalidated text string.

---

## Interactive Map Selection

If the Vendor chooses the interactive map, the Vendor may place or move a pin to identify the store or registered business location.

After the Vendor selects the location, the system attempts to resolve the pin into structured address information.

The interface displays, where available:

* Street or building information
* Barangay
* City or municipality
* Province or applicable administrative area
* Postal code
* Latitude
* Longitude

When the Vendor selects the location using the map, the corresponding **Latitude and Longitude must be displayed** in the designated location fields.

The Vendor must be able to review the resolved address before saving it.

The system must not silently accept an incomplete or incorrectly resolved address.

Where geocoding cannot confidently provide a required address field, the Vendor may be required to complete the missing information manually.

---

## Location Validation

The system validates the business location before it becomes operational.

If required location information is missing or invalid, the system prompts the Vendor to correct or complete it.

The verified store location may later be used for:

1. Vendor discovery
2. Location-based search
3. Distance calculations
4. Delivery-coverage evaluation
5. Delivery-fee calculation
6. Supplier recommendation
7. Vendor Materials Analytics scope
8. Geographic marketplace reporting

The geolocation coordinates must be stored separately from the human-readable address.

Coordinates are used for geospatial computation, while the structured address supports presentation, administrative classification, verification, and reporting.

A critical change to a previously approved registered business address must create a new version or review event rather than silently overwriting the previously verified value.

---

# Supplier Type / Classification

The Vendor identifies the type of supplier represented by the business.

Available **Supplier Types** include:

1. **Wholesaler / Distributor**
2. **Retail Hardware Store**
3. **Specialized Supplier**

The Vendor selects the Supplier Type that best represents the business.

The Vendor also selects one or more applicable **Supplier Niches** representing the categories of construction materials or supported products offered.

Multiple niches may be selected.

Each niche should contain a short description to help the Vendor understand the intended scope.

Available canonical niches may include:

* Construction Materials
* Electrical Supplies
* Plumbing and Sanitary
* Tools and Equipment
* Finishing Materials
* Fasteners and Hardware
* Cement and Concrete
* Roofing Materials
* Formworks and Scaffolding
* Wood and Lumber
* Landscaping and Exterior
* Steel and Reinforcement
* Tools and Accessories
* Masonry
* Insulation and Waterproofing
* Aggregates
* Drainage and Septic Materials
* Construction Chemicals
* Flooring Materials
* Wall and Ceiling Materials
* HVAC Materials
* Sanitary Fixtures
* Fire Protection Materials
* Paints and Finishes
* Adhesives and Sealants
* Doors, Windows, and Glass

Duplicate or substantially equivalent taxonomy labels must be consolidated into one canonical category where appropriate.

For example, the system should avoid maintaining both:

* Fasteners and Hardware
* Hardware and Fasteners

as separate canonical categories when they represent the same marketplace classification.

---

## Other Category

The Vendor may select:

**Others — Specify Category**

When selected, the system displays a text field where the Vendor may describe another relevant construction-material niche.

The text entered under **Others** is stored as a **Vendor-provided custom classification label**.

It must not automatically create a new canonical MateryalPH taxonomy category.

The Vendor may still complete onboarding without separate Admin approval solely because an Other label was provided, provided the label does not violate a prohibited-category rule.

For marketplace search, matching, analytics, and canonical categorization, the system should continue using approved MateryalPH taxonomy categories.

A custom label may later be reviewed or mapped to an approved canonical category through an administrative taxonomy-management process.

---

## Rental Category Restriction

MateryalPH currently does not support construction-vehicle or equipment-rental services as marketplace inventory.

The system therefore prevents supplier-category entries that clearly represent unsupported rental services.

Examples include:

* Construction Vehicle Rental
* Vehicle Rental
* Construction Equipment Rental
* Equipment Rental
* Rental

Validation should be case-insensitive and may normalize whitespace, punctuation, and equivalent prohibited wording.

If the Vendor attempts to submit a prohibited rental category, display a message such as:

**“Vehicle and equipment rental services are not currently supported by MateryalPH. The marketplace currently supports construction materials, supplies, tools, equipment offered as supported products, and other approved procurement categories.”**

Construction vehicles must not be interpreted as supported rental inventory merely because the Vendor selects **Tools and Equipment**.

A Vendor may select multiple valid supplier niches when the business operates across several categories.

---

# Business and Compliance Verification

The Vendor submits the legal registration, business permit, tax-registration information, and other applicable regulatory evidence required for Admin verification.

The required primary registration evidence depends on the selected Business Type.

| Business Type          | Required Primary Registration Evidence    |
| ---------------------- | ----------------------------------------- |
| Sole Proprietorship    | Applicable DTI Business Name Registration |
| Partnership            | Applicable SEC Registration               |
| Corporation            | Applicable SEC Registration               |
| One Person Corporation | Applicable SEC Registration               |
| Cooperative            | Applicable CDA Registration               |

The system should show only the requirements applicable to the selected Business Type.

Changing the Business Type must recalculate the applicable document requirements.

---

## Additional Business and Regulatory Requirements

The Vendor also provides the applicable required evidence, including:

* LGU-issued Business Permit
* BIR Certificate of Registration
* Taxpayer Identification Number
* VAT or Non-VAT registration information
* Applicable regulatory evidence
* Other requirements made mandatory by the Vendor's business type, location, or marketplace activity

Additional certifications may be uploaded where applicable.

Examples include:

* ISO certifications
* Industry-specific licenses
* Relevant professional or regulatory certifications
* Other applicable business credentials

Optional certifications do not block activation unless a specific marketplace function, regulated product, law, or selected Vendor capability makes the certification mandatory.

The system may limit the quantity, size, and type of optional supporting documents to prevent unnecessary collection of unrelated information.

---

# Tax Information

Tax information is collected as part of **Store Verification**.

The Vendor should not be required to enter the same legal tax information again during Payment Configuration.

Payment Configuration later references the approved or effective Vendor Tax Profile generated from this information.

Tax information submitted by the Vendor remains subject to Admin review.

---

## Taxpayer Identification Number

The Vendor provides the applicable **Taxpayer Identification Number (TIN)** registered to the business or taxpayer.

The form should support the applicable BIR TIN and branch-code structure required by the configured tax profile.

Display guidance such as:

**“Enter the TIN and applicable branch code exactly as shown on the relevant BIR registration records.”**

The system must:

* Require the TIN where applicable
* Validate the expected structure
* Reject clearly malformed values
* Store the TIN as private business-tax information
* Associate it with the Vendor Tax Profile
* Mark Vendor-submitted tax identity information as pending verification until reviewed
* Prevent public exposure of the full TIN

The full TIN must not appear on:

* Public Store Profiles
* Buyer search
* Vendor maps
* Public product listings
* Public analytics
* Other Vendors' interfaces

Authorized interfaces may display masked values where appropriate.

---

## VAT Registration Status

The Vendor declares the applicable VAT registration status.

Available options include:

* **VAT Registered**
* **Non-VAT Registered**

The system distinguishes:

* **Declared VAT Status** — entered by the Vendor
* **Verified VAT Status** — confirmed through Admin review

The Admin verifies the declared status against the submitted BIR registration evidence.

If the declaration is inconsistent with the supporting documentation, the requirement may be marked:

**Changes Required**

The Vendor must then correct the information or provide suitable replacement evidence.

---

## BIR Certificate of Registration

The Vendor uploads the applicable **BIR Certificate of Registration (COR)**.

Supported file formats may include:

* JPG
* JPEG
* PNG
* PDF

The system enforces the approved:

* Maximum upload size
* MIME/content validation
* File-type rules
* Malware/safety scanning where implemented
* Private-storage controls

The BIR COR may be used by the Admin to review applicable information including:

* Registered taxpayer or legal-business name
* TIN
* Branch information
* Registration status
* VAT or Non-VAT status
* Other relevant tax-registration information shown on the document

Uploading the BIR COR does not automatically verify the Vendor's tax profile.

The requirement remains under the applicable submitted or review status until approved by an authorized Admin.

A BIR COR must not be assigned an invented annual expiration date if the document itself does not establish one.

Where no expiration applies, the Admin may record:

**Expiration: Not Applicable**

---

# Sworn Declaration and Withholding Evidence

The system asks:

**Submit applicable Sworn Declaration or withholding-supporting declaration?**

Options:

* **Yes**
* **No**

Display explanatory text stating that a declaration may affect the applicable withholding treatment only when the Vendor qualifies under the relevant configured tax rules and provides valid supporting evidence.

Selecting **Yes** must not automatically grant:

* Tax exemption
* Withholding exemption
* Reduced withholding
* Threshold relief
* Any other tax treatment

The declaration remains subject to review.

Where applicable, the declaration record may include:

* Declaration year
* Declaration type
* Applicable threshold position
* BIR-received or applicable declaration document
* Receipt, reference, or receiving information where available
* Prior-year position where required
* Scope of applicable outside-platform remittances where required by the configured finance rules
* Submission date
* Effective period
* Verification status
* Admin remarks

The Vendor Owner is the account responsible for formally attesting applicable Vendor tax declarations.

A Store Manager may be permitted to prepare a draft correction where the permission model allows it, but must not replace the Owner's required attestation.

If the Vendor selects **No**, the system records that no applicable declaration was submitted for the relevant period.

Failure to submit an optional relief declaration must not automatically prevent an otherwise properly registered Vendor from marketplace activation where the approved finance rules allow the standard withholding treatment to apply.

A missing **mandatory BIR registration requirement**, however, remains an activation blocker.

The underlying withholding treatment must follow the authoritative FIN contracts and approved Vendor Tax Profile rather than a simple Yes/No value.

---

# Vendor Tax Profile

The submitted tax information is used to create or update the Vendor's tax profile.

The profile may maintain:

* Taxpayer identity
* Legal entity classification
* TIN and branch information
* VAT or Non-VAT classification
* Applicable fiscal or tax period
* Supporting evidence
* Declaration evidence
* Effective period
* Environment
* Evidence origin
* Verification decision
* Withholding assignment or scenario
* Version history

Tax-profile corrections must create a new version or audited change rather than rewriting prior financial history.

A later correction to Vendor tax information must not retroactively modify:

* Previously accepted prices
* Previously completed payments
* Existing immutable financial snapshots
* Prior posted financial records

unless an approved adjustment process explicitly creates the corresponding correction record.

---

# Document Metadata and Verification

For each uploaded business or compliance document, the system stores the document and applicable metadata.

Metadata may include:

* Document type
* Document number
* Upload date and time
* Uploading user
* Organization
* File reference
* Submission status
* Verification status
* Admin reviewer
* Admin remarks
* Verified issue date
* Verified expiration date
* Replacement or superseded-document reference
* Audit reference

The Vendor may enter supporting metadata during submission.

Vendor-entered metadata is not automatically treated as officially verified.

---

## Issue Date and Expiration Date

The **official verified Issue Date and Expiration Date** are recorded by the authorized Admin based on the uploaded evidence.

For documents with an applicable validity period, the Admin records:

* **Issue Date**
* **Expiration Date**

The system must prevent:

**Expiration Date < Issue Date**

For documents that do not expire, the Admin may select:

**Expiration Date: Not Applicable**

The system must distinguish:

* No expiration applies
* Expiration has not yet been verified
* Expiration exists and has been verified
* Document has expired

A previously approved document may remain effective while a replacement is being reviewed when permitted by the applicable compliance rule.

However, an expired or materially invalid document may create an immediate restriction where required.

---

# Submission Validation

Before Store Verification may be submitted, the system validates the applicable required information.

Validation includes:

* Business Type
* Required legal-name information
* Required identity evidence
* Business or Store Name
* Date of Establishment
* Verified Store Email
* Required Store Phone Number
* Required business contacts
* Registered business address
* Supplier Type
* Supplier niches
* Required registration evidence
* Required LGU documentation
* Required BIR registration information
* Required Tax Profile fields
* Applicable declarations
* Supported file types
* Maximum file sizes
* Required document numbers
* Required acknowledgments
* Other applicable conditional requirements

If a required item is missing, the system prevents submission and identifies the exact requirement that must be completed.

Submission does **not** mean the Vendor is verified.

After successful submission, Store Verification changes to:

**Pending Verification**

---

# Privacy Notice

Before the Vendor submits personal, legal-business, identification, tax, or compliance information, the system presents the applicable **Privacy Notice**.

The Privacy Notice explains, in clear language:

* Categories of information collected
* Purpose of collection
* Applicable processing activities
* Authorized recipients or processors
* Retention basis
* Data-subject rights
* Privacy-request process
* Other required privacy information

The Vendor must acknowledge the applicable Privacy Notice before completing submission.

The system records:

* Vendor/User identifier
* Organization
* Privacy Notice version
* Date and time
* Applicable processing activity
* Source or interface
* Acknowledgment record

Privacy Notice acknowledgment is stored separately from:

* Terms of Service
* Vendor Code of Conduct
* Commission Agreement
* Payment agreements
* Other commercial agreements

Acknowledging the Privacy Notice must not automatically mean the Vendor accepted unrelated commercial terms or optional processing activities.

---

# Store Verification Submission Confirmation

After successful submission, the system displays a confirmation page.

Display a message such as:

**“Business information and documentation successfully submitted. Your Store Verification is awaiting Admin review.”**

The page provides:

**Proceed to Store Setup**

The Vendor may begin Store Setup immediately.

The Vendor is **not required to wait for Admin approval** before configuring Store Setup.

However, the store cannot be activated until all mandatory Store Verification items have reached their required successful final status.

---

# Pending Verification

The Admin reviews the Vendor's submitted information and documents through the Admin Portal.

The Admin checks the information for:

* Completeness
* Consistency
* Document validity
* Registration details
* Applicable dates
* Tax information
* Applicable supporting evidence
* Other relevant verification requirements

For each Admin-reviewed requirement, the Admin may select:

### Approve

The submitted information or document satisfies the applicable requirement.

Status:

**Approved**

### Return for Correction

The submission requires correction, replacement, clarification, or additional information.

Status:

**Changes Required**

The Admin must provide a reason or clear correction instruction.

### Reject

The submission does not satisfy the applicable requirement and cannot be accepted in its current form.

Status:

**Rejected**

The Admin must provide a reason.

---

## Admin Verification Information

The Admin may record:

* Verified document number
* Issue date
* Expiration date
* Not Applicable expiration status
* Verification remarks
* Review evidence or source
* Verification decision
* Reviewer
* Review timestamp

Every verification decision is recorded in the audit trail.

---

# Correction and Resubmission

When an item is marked **Changes Required**, the Vendor may correct the applicable information or upload replacement evidence.

The resubmitted requirement moves through the appropriate status sequence, such as:

**Changes Required → Submitted → Pending Verification → Approved**

The old evidence must not be silently destroyed.

The system should preserve the applicable version or audit history.

---

# Expiration and Reverification

If an approved document later expires, the system may change its status to:

**Expired**

The Vendor must upload an applicable replacement.

A critical change to previously approved legal-business information may reopen the requirement for Admin review.

Examples may include:

* Legal Business Name
* Company Registered Name
* Business Type
* Registered business address
* TIN or branch information
* VAT classification
* Required registration document
* Other critical compliance evidence

Changing a public Store Profile image or ordinary marketing text does not automatically require full business reverification unless another policy makes it necessary.

---

# 2. Store Setup

**Store Setup** is the second primary section of Vendor Onboarding.

Store Setup configures the operational capabilities required for marketplace participation.

The Vendor may begin Store Setup after Store Verification has been submitted, even while Admin review remains pending.

Store Setup includes:

1. Business Store Profile Setup
2. Fulfillment Configuration
3. Delivery Configuration, when applicable
4. Payment Configuration
5. Other required operational configuration
6. Optional Vendor Team setup under the applicable conditions

---

# Business Store Profile Setup

The **Business Store Profile** controls how the Vendor's store will appear to Buyers after marketplace activation.

The Store Profile may include:

* Profile picture or business logo
* Business or Store Name
* Store Banner
* Store Description
* Promotional images
* Optional promotional video
* Approved public business contact information
* Public operating information

The Store Name is pre-filled using the applicable Store Name from Business Information.

The Vendor may modify the permitted public-facing information.

Legal-business fields remain separate and cannot be changed through the public Store Profile editor.

The Store Profile may be completed before Store Verification is approved.

However, while the store remains inactive, the profile is treated as a **draft marketplace profile** and must not be presented as an active verified Vendor storefront.

Media must be validated for:

* Supported file type
* Maximum file size
* Safety
* Appropriate content
* Accessibility metadata where applicable
* Other configured media requirements

Private information must never appear on the public Store Profile, including:

* Government ID
* TIN
* Business verification documents
* Private tax records
* Payout credentials
* Authentication information
* Private employee information

---

# Fulfillment Configuration

## Bulk Order Capability

The Vendor declares whether the business can accommodate bulk orders associated with Project-Based Procurement.

| Declared Capability                 | Procurement Eligibility                            |
| ----------------------------------- | -------------------------------------------------- |
| Yes — Can accommodate bulk orders   | Item-Based Procurement + Project-Based Procurement |
| No — Cannot accommodate bulk orders | Item-Based Procurement only                        |

The selected capability determines marketplace procurement eligibility.

Bulk Order Capability does not create a separate competitive RFQ bidding queue.

A Vendor may later change this capability through the applicable authorized Store Configuration interface.

A capability change affects future marketplace eligibility and must not rewrite already accepted orders or quotations.

---

# Services Capability

The Vendor selects the fulfillment methods supported by the store.

Available options:

* **Self-Pickup**
* **Vendor Delivery**
* **Both**

If **Self-Pickup only** is selected:

* Delivery Configuration is not required for onboarding.

If **Vendor Delivery** or **Both** is selected:

* Delivery Configuration becomes **Conditionally Required**.

Payment-method configuration remains separate from fulfillment capability.

For example:

* COD may be available for eligible Vendor Delivery orders.
* In-Store Payment may be available for eligible Self-Pickup orders.
* Online-payment onboarding through Xendit remains mandatory under the current MateryalPH design.

---

# Delivery Configuration

If Vendor Delivery is enabled, the Vendor configures the delivery fleet used by the store.

The Vendor may add multiple vehicle configurations.

After activation, authorized users may add, update, deactivate, or remove vehicle configurations for future orders.

Existing accepted orders retain their applicable delivery snapshot and are not silently modified when the Vendor later changes vehicle configuration.

Supported vehicle categories include:

* Motorcycle
* Pickup
* Van
* Truck
* Custom Vehicle Type

Truck types may include:

* Open Truck
* Flatbed Truck
* Wing Van

A Custom Vehicle Type may be configured where applicable.

Vendors should configure only vehicles that the store actually operates or legitimately controls for its Vendor Delivery service.

Unconfigured vehicles must not appear as available fulfillment options.

---

## Vehicle Configuration Fields

For each configured vehicle type, the Vendor provides:

| Field                          | Description                                   |
| ------------------------------ | --------------------------------------------- |
| Vehicle Image                  | Operational image shown where relevant        |
| Number of Vehicles             | Positive integer representing usable vehicles |
| Capacity per Vehicle (kg)      | Maximum cargo payload                         |
| Cargo Length (m)               | Usable cargo-space length                     |
| Cargo Width (m)                | Usable cargo-space width                      |
| Cargo Height (m)               | Usable cargo-space height                     |
| Heavy Vehicle Classification   | Used for site-accessibility rules             |
| Base Fee (₱)                   | Fixed amount applied per applicable trip      |
| Per-Kilometer Rate (₱/km)      | Distance-based delivery amount                |
| Maximum Delivery Distance (km) | Maximum supported service distance            |

The system validates:

* Positive quantities
* Valid numeric ranges
* Non-negative rates
* Required dimensions where applicable
* Required distance limit
* Other configured constraints

The system may provide an initial heavy-vehicle classification based on the vehicle type while permitting authorized correction when the Vendor's actual vehicle differs.

---

## Delivery Recommendation

The configured vehicle information is used by MateryalPH to recommend an appropriate delivery vehicle for an order.

The system recommendation may consider:

* Order weight
* Cargo dimensions
* Vendor vehicle capacity
* Distance
* Vehicle availability
* Site-access restrictions
* Other approved delivery constraints

The system does **not automatically dispatch a vehicle**.

The Vendor confirms or changes the recommended vehicle before finalizing the applicable delivery arrangement.

Where multiple vehicles or trips are needed, the Vendor confirms the applicable arrangement before the Buyer pays the finalized delivery charge.

Editing a vehicle configuration later must not modify an existing accepted order's delivery snapshot.

---

# Payment Configuration — Using Xendit Activation

Every Vendor must complete the required **Xendit xenPlatform sub-account onboarding** before Store Activation.

This applies to all supported Vendor business types.

A Vendor cannot be activated until the required Xendit integration has reached the configured successful onboarding and connection state.

---

## Xendit Account Creation

The Payment Configuration screen provides:

**Create Xendit Account**

When the Vendor Owner selects this action, MateryalPH initiates the server-side process for creating or connecting the applicable Vendor sub-account under the MateryalPH platform account.

All privileged Xendit API operations are performed through the MateryalPH backend.

The Vendor web application must never receive or expose MateryalPH's Xendit secret API key.

The implementation must follow the supported Xendit account-management contract used by the deployed environment.

---

## Xendit Integration Data

MateryalPH stores only the information required to manage and reconcile the Vendor's connection.

This may include:

* Xendit account identifier
* Connection status
* Onboarding status
* Enabled capabilities
* Account configuration
* Payment references
* Reconciliation references
* Environment
* Evidence origin
* Synchronization timestamps

Sensitive Xendit credentials must not be stored in ordinary Vendor records.

---

# Mandatory Payment Onboarding

Xendit onboarding is mandatory for every Vendor participating in MateryalPH marketplace transactions.

Completing the visible Payment Configuration form alone is not sufficient.

The backend must verify the required Xendit connection and onboarding status.

If the Xendit integration is:

* Incomplete
* Unsuccessful
* Awaiting required information
* Unavailable
* Not in the required capability state

then Payment Configuration remains incomplete.

The Vendor's store cannot yet be activated.

---

# Tax Profile Within Payment Configuration

Tax registration information must **not be collected a second time here**.

The Payment Configuration page uses the Vendor Tax Profile already created through Store Verification.

The screen may display an authorized summary such as:

* Tax Profile Status
* VAT/Non-VAT classification
* Declaration status
* Withholding arrangement status
* Applicable evidence status
* Required next action

Sensitive details such as the full TIN should remain masked or restricted.

If tax information requires correction, the Vendor is directed back to the applicable Store Verification/Tax Profile correction process.

---

# Tax Profile and Withholding Arrangement

Payment-provider configuration and tax/withholding configuration remain logically separate.

The Payment Configuration interface may contain distinct areas for:

* Xendit Connection
* Tax Profile Summary
* Withholding Arrangement
* Commission Terms
* Online Payment Channels
* Physical Payments
* Refund Capability

The payment provider connection must not itself be treated as proof of a Philippine withholding-tax event.

The current capstone environment may use approved demonstration scenarios defined by the authoritative finance contracts.

Where the production withholding responsibility has not been legally and operationally confirmed, the internal production state remains:

**Production assignment unconfirmed**

The capstone may use the approved demonstration configuration, including the applicable demo withholding scenario, without representing that configuration as a real production determination.

Payment, tax, remittance, and reconciliation records retain:

* Environment
* Evidence origin
* Applicable rule or scenario
* Relevant references

This prevents demonstration evidence from being mistaken for production tax evidence.

---

# Commission Terms

The Vendor Owner must accept the applicable MateryalPH commission agreement.

Under the approved current model, MateryalPH applies the configured **2% Vendor-paid commission** according to the FIN contracts.

The agreement must identify the applicable:

* Commission rate
* Materials-value calculation base
* Discount treatment
* VAT treatment
* Billing schedule
* Cancellation credits
* Partial-refund adjustments
* Statement due-date rule
* Dispute process

Commission acceptance is stored as a **versioned agreement**.

Changing the current commission terms must not retroactively modify an already accepted order.

---

# Online Payment Channels

Available online-payment channels are determined by the actual capabilities enabled in the configured Xendit environment.

The system must not assume that every possible provider channel is available.

For each enabled channel, MateryalPH maintains the applicable information concerning:

* Transaction limits
* Payment expiration
* Settlement behavior
* Refund capability
* Provider status

A payment channel that cannot support the required refund workflow must not be enabled for a transaction requiring unsupported automatic-refund behavior unless an approved alternative refund process exists.

---

# Payment Purposes

Different payment purposes must use separate transaction references.

Examples include:

* Full Order Payment
* NRPC Assurance Payment
* Order Balance Payment
* Platform Fee Payment

The system must not treat these as interchangeable transaction types.

An NRPC assurance payment is credited toward the applicable order balance exactly once and must not become an additional Buyer charge.

---

# Physical Payments

The Vendor may configure supported physical payment methods where applicable.

Examples include:

* Cash on Delivery
* In-Store Payment

Physical payments are collected directly by the Vendor.

The system records the physical-payment event without generating or imitating an online Xendit payment-success event.

A physical-payment record may contain:

* Amount
* Date and time
* Payment method
* Recording user
* Source
* Evidence
* Buyer acknowledgment where applicable
* Outstanding balance after collection

Partial collection leaves the remaining amount outstanding.

Corrections must create auditable correction events rather than silently rewriting the original record.

The outstanding balance must never become negative.

---

# Refund Capability

Payment Configuration identifies the refund capability of each enabled payment method.

The system distinguishes:

* Automatic eligible paid-order cancellation refund
* Dispute-conclusion refund
* Technical compensation
* Physical-payment reimbursement process

Cancellation refund and dispute refund remain separate processes.

Physical cash already collected by the Vendor cannot be represented as though MateryalPH automatically reversed it through Xendit.

---

# Payment Configuration Completion

Payment Configuration is considered **Completed** only when all applicable mandatory payment requirements have been successfully satisfied.

This includes:

* Required Xendit sub-account created or connected
* Required onboarding state confirmed
* Required payment capabilities confirmed
* Required Commission Terms accepted
* Required payment settings completed
* Required Tax Profile state compatible with activation
* No applicable blocking payment requirement remains unresolved

Until Payment Configuration is complete, the store remains:

**Not Active for Marketplace Participation**

---

# Vendor Team Account Management

Vendor Team setup is **optional** and does not block Store Activation.

To avoid unnecessary complexity during initial onboarding, Team Account invitations become available after the Vendor Owner has completed and submitted the required **Store Setup configuration**, even if Store Verification is still pending Admin review.

The Owner may also create Team Accounts after Store Activation.

A Vendor Team Account belongs to an individual employee and is connected to the existing Vendor organization.

Creating a Team Account does not create another store.

Each employee receives their own individual account.

The Owner's credentials must never be shared.

---

## Team Invitation Information

Each invitation records:

* Employee full name
* Email address
* Contact number where required
* Vendor organization
* Exactly one fixed role
* Invitation expiration
* Inviting user
* Invitation status
* Creation date
* Acceptance date where applicable

The employee receives an invitation through the provided email address.

---

# Staff Roles

Available Vendor Team roles are:

1. **Store Manager**
2. **Store Staff**
3. **Customer Service Staff**
4. **Inventory Staff**
5. **Fulfillment Staff**

Each Team Account has exactly one fixed Vendor role at a time.

Roles must not be stacked or combined arbitrarily.

Access is determined by:

* Organization membership
* Fixed role
* Delegated permission flags
* Store status
* Resource authorization
* Applicable recent-authentication requirements

Frontend visibility does not replace backend authorization.

---

# Store Manager Delegation

When the Owner creates or edits a Store Manager, the system displays an off-by-default setting:

**Allow this Store Manager to manage staff accounts**

If enabled, the Store Manager may manage only permitted non-manager roles:

* Store Staff
* Customer Service Staff
* Inventory Staff
* Fulfillment Staff

A delegated Store Manager must not:

* Create another Store Manager
* Edit another Store Manager's privileged access
* Deactivate another Store Manager
* Change the Vendor Owner
* Transfer ownership
* Grant delegation
* Change their own role
* Increase their own permissions
* Modify protected payout credentials
* Delete or alter audit records
* Perform Owner-only functions

The Owner is notified of delegated staff-management actions.

All invitation and membership changes are audit-logged.

---

# Staff Invitation and First Login

After the Owner creates the Team Account invitation, the system sends an individual invitation link to the employee's email.

The employee uses the invitation to create or connect their individual login identity.

After successful sign-in, a Team Account **does not repeat Vendor Onboarding**.

Onboarding belongs to the Vendor organization and is managed by the Vendor Owner or another specifically authorized user.

The staff member is directed to the Vendor Dashboard according to:

* Role
* Permissions
* Delegation
* Store activation status

---

# Staff Access Before Store Activation

If the Team Account has been activated while the Vendor organization is still awaiting marketplace activation, the employee may sign in but must not receive full marketplace access merely because the staff account exists.

The Vendor Dashboard remains in the appropriate **limited-access state**.

The employee only sees the functions allowed by both:

1. The organization's current onboarding/activation state
2. The employee's assigned role and permissions

The dashboard displays a message such as:

**“This store is not yet active for marketplace participation. Required onboarding and verification must be completed before marketplace features become available.”**

Staff who do not have permission to modify onboarding requirements must not be allowed to alter those requirements.

---

# Staff Access After Store Activation

Once the store is activated, staff gain access to the applicable marketplace sections based on their role and permissions.

Store Activation does not give every Team Account full access.

Role-based and organization-based access control remains enforced.

The Vendor Owner retains the highest organization authority.

---

# Completion of Store Setup

When all mandatory Store Setup requirements are successfully completed, the Store Setup checklist changes to:

**Completed**

Completing Store Setup does not automatically activate the Vendor if Store Verification remains unresolved.

If Store Verification is still:

* Pending Verification
* Changes Required
* Rejected
* Expired
* Incomplete

the Vendor remains in the limited Dashboard state.

---

# Vendor Onboarding Checklists

The Vendor Dashboard contains two primary onboarding checklists:

1. **Store Verification Checklist**
2. **Store Setup Checklist**

Each item displays:

### Requirement Level

* Required
* Optional
* Conditionally Required

### Progress / Review Status

As applicable:

* Not Started
* In Progress
* Submitted
* Pending Verification
* Approved
* Completed
* Changes Required
* Rejected
* Expired
* Not Applicable

The interface should not merge these two concepts into one label.

For example:

**BIR Certificate of Registration**
Requirement: **Required**
Status: **Pending Verification**

or:

**Promotional Video**
Requirement: **Optional**
Status: **Not Started**

---

# Finish Later

The Vendor may select:

**Finish Later**

at any permitted point in onboarding.

The system saves the current progress and redirects the Vendor to the Vendor Dashboard.

---

# Limited-Access Vendor Dashboard

While onboarding is incomplete or Store Activation has not yet occurred, the Vendor Dashboard operates in a **limited-access state**.

The Owner may access the limited functions necessary to continue setup and manage the account.

At minimum, the Navigation Sidebar may expose:

* **Store Profile**
* **Store Account Settings**

The Dashboard itself provides dedicated actions for:

* Continue Store Verification
* Continue Store Setup
* Review Pending Verification
* Correct Changes Required
* Review onboarding progress

Optional Team Account access may become available after Store Setup submission according to the rule defined above.

Other marketplace operational modules remain locked until Store Activation.

---

## Limited Dashboard Main Panel

The Dashboard displays:

* Store Verification Checklist
* Store Setup Checklist
* Overall onboarding progress
* Pending Verification requirements
* Changes Required items
* Rejected or Expired blockers
* Dedicated Continue buttons
* Current activation state

Display a message such as:

**“Store not yet active for marketplace participation. Complete all required onboarding requirements to activate your store.”**

If a required Store Verification item is pending Admin review, the Dashboard should clearly indicate that the Vendor may continue other permitted setup activities while waiting.

---

# Store Activation

Store Activation is the transition that allows the Vendor organization to begin using the full marketplace operational functions permitted by its account roles.

The Vendor becomes eligible for Store Activation when all applicable mandatory activation requirements have a successful final state.

These include:

1. Vendor Owner account is active.
2. Required email verification has been completed.
3. Required agreements have been accepted.
4. Store Verification has been submitted.
5. All mandatory Admin-reviewed Store Verification requirements are **Approved**.
6. No mandatory Store Verification item remains Pending Verification.
7. No mandatory item remains Changes Required.
8. No mandatory item remains Rejected.
9. No mandatory blocking document remains Expired.
10. Required Business Information is complete.
11. Applicable DTI, SEC, CDA, LGU, BIR, TIN, and other required regulatory evidence is approved.
12. Required Tax Profile information is in the applicable successful state.
13. Business Store Profile Setup is complete.
14. Supplier Type and required supplier classification are complete.
15. Bulk Order Capability has been recorded.
16. Fulfillment method is configured.
17. Delivery Configuration is complete when Vendor Delivery is enabled.
18. Xendit onboarding has reached the required successful connection state.
19. Required payment capabilities and configuration are complete.
20. Required Commission Terms have been accepted.
21. No Vendor suspension, activation hold, unresolved mandatory onboarding blocker, or other activation restriction exists.

**Vendor Team Accounts are optional and do not block activation.**

---

# Product Listing and Store Activation

A Vendor is **not required to already have an Active product listing in order to activate the store account**.

This avoids a circular workflow in which Product Management is locked until activation while activation itself requires a product.

After Store Activation, authorized Vendor users gain access to:

* Product Management
* Listings
* Inventory
* Compliance submissions
* Marketplace inquiries
* Quotations
* Orders
* Fulfillment
* Transactions
* Analytics
* Other authorized Vendor functions

The Vendor may then create and publish product listings according to the applicable listing and compliance rules.

---

# Store Activation vs. Marketplace Discoverability

**Store Activation** and **Marketplace Discoverability** are separate concepts.

### Store Activation

Means the Vendor organization has completed the mandatory onboarding requirements and may use the permitted Vendor marketplace functions.

### Marketplace Discoverability

Means the Vendor is eligible to appear to Buyers in marketplace search, product discovery, recommendations, analytics counts, and other supplier-discovery surfaces.

An activated Vendor with no publishable products may therefore have:

**Store Status: Active**

while still having:

**Marketplace Discoverability: No Active Listings**

The store becomes discoverable as an offering Vendor when the applicable marketplace requirements are satisfied, including:

* Store remains active
* At least one eligible publishable product listing exists
* Required product compliance is satisfied
* Applicable inventory is available
* No marketplace restriction blocks discovery

For regulated products, the applicable PS/ICC or other required compliance rule must be successfully satisfied before that listing becomes publishable.

Store Activation must therefore not be confused with automatic publication of every product.

---

# Activation Event and Audit

Store Activation must be recorded as an auditable system event.

The activation record contains, where applicable:

* Vendor organization
* Activation result
* Date and time
* Actor or system process
* Checklist result
* Applicable rule version
* Relevant verification references
* Reason
* Previous marketplace state
* New marketplace state

The system must not silently activate a Vendor by frontend behavior alone.

Activation eligibility must be evaluated by the backend.

---

# Access After Store Activation

After Store Activation, the Vendor gains access to the appropriate Navigation Sidebar sections according to role and permission.

The Vendor Owner may access the full authorized Vendor organization functions.

Team Accounts receive only the sections permitted by their fixed role.

Store Activation does not override role-based access control.

Examples of post-activation marketplace functionality include:

* Product and listing management
* Inventory management
* Buyer inquiries
* Messaging
* Quotations
* Item-Based Procurement
* Project-Based Procurement where eligible
* Orders
* Delivery and fulfillment
* Transaction records
* Compliance management
* Vendor Team Accounts
* Analytics
* Store configuration
* Other authorized marketplace functions

---

# Changes After Activation

An activated Vendor may later update permitted Store Setup information.

Ordinary operational changes may apply to future marketplace activity after validation.

Examples include:

* Store banner
* Store description
* Operating information
* Vehicle configuration
* Delivery rates
* Future fulfillment settings
* Staff accounts

Existing accepted orders, quotations, payment records, delivery snapshots, and other immutable commercial records must not be silently modified by later configuration changes.

Changes to critical verified information may require reverification.

Examples include:

* Legal Business Name
* Company Registered Name
* Business Type
* Registered business address
* TIN
* VAT classification
* Mandatory business-registration evidence
* Mandatory compliance evidence
* Protected payment or payout configuration

The system creates a new review or version rather than overwriting the verified historical record.

Depending on the severity and applicable rule, the Vendor may remain active while the replacement is reviewed, or the affected marketplace capability may be restricted until the new information is approved.

---

# Final Vendor Onboarding Flow

The final onboarding flow is:

**Vendor Account Creation**
→ **Email / Account Verification**
→ **Required Agreements**
→ **Vendor Portal Account Active**
→ **Vendor Onboarding**

Within Vendor Onboarding:

**Store Verification**
→ Business Type
→ Legal Identity
→ Business Information
→ Business Contacts
→ Registered Business Address
→ Supplier Classification
→ Business and Compliance Documents
→ Tax Information
→ Privacy Notice
→ Submit
→ Pending Admin Verification

At the same time, after Store Verification submission:

**Proceed to Store Setup**
→ Business Store Profile
→ Bulk Order Capability
→ Fulfillment Configuration
→ Conditional Delivery Configuration
→ Xendit Payment Configuration
→ Tax Profile Summary / Withholding Configuration
→ Commission Agreement
→ Other Mandatory Store Setup Requirements
→ Store Setup Completed

If the Vendor chooses **Finish Later**:

→ Save Progress
→ Limited Vendor Dashboard
→ Resume Store Verification or Store Setup

If Store Setup is complete but Store Verification remains pending:

→ Limited Vendor Dashboard
→ Wait for Admin Review
→ Correct requirements when necessary

If Admin returns a requirement:

→ Changes Required
→ Vendor Corrects / Replaces
→ Resubmit
→ Pending Verification
→ Admin Decision

When:

**All mandatory Store Verification requirements are Approved**
+
**All mandatory Store Setup requirements are Completed**
+
**No blocking restriction remains**

then:

→ **Store Activation**

After Store Activation:

→ Full role-appropriate Vendor Dashboard
→ Product and Inventory Setup
→ Publish Eligible Listings
→ Marketplace Discoverability when at least one eligible listing exists
→ Marketplace Participation
