# MateryalPH: sections and features explained

Prepared: 22 October 2026. Language: simple English.

This guide explains registration, login, and the sections of the Admin portal, Vendor portal, and Buyer mobile application. The section names follow the current navigation shown in the application. Each explanation can also be read aloud during a presentation; **How to use** identifies the screen actions to demonstrate.

Available pages and actions depend on the user's role, account status, store readiness, and the record being opened. This guide describes the approved workflows and inspected application screens; it does not certify a deployed environment or a successful live transaction.

MateryalPH is an academic prototype. Payment and financial demonstrations use **DEMO — No real funds or BIR filing**. Xendit operations use TEST mode, and cash-payment demonstrations represent simulated handovers.

## Contents

1. [What each application does](#1-what-each-application-does)
2. [Registration, login, and account recovery](#2-registration-login-and-account-recovery)
3. [Admin portal](#3-admin-portal)
4. [Vendor portal](#4-vendor-portal)
5. [Buyer mobile application](#5-buyer-mobile-application)
6. [How the three applications work together](#6-how-the-three-applications-work-together)
7. [Common terms](#7-common-terms)
8. [References and scope](#8-references-and-scope)

## 1. What each application does

MateryalPH connects people buying construction materials with eligible suppliers and provides a separate administration portal for platform oversight.

| Application | Intended users | Main purpose |
| --- | --- | --- |
| Admin web portal | Super Admin and authorized Admin staff | Review businesses and product evidence, handle cases, provide support, monitor the marketplace, and maintain accountable platform operations. |
| Vendor web portal | Vendor Owner and invited employees | Set up a store, manage materials and inventory, respond to Buyers, prepare quotations, process orders, and fulfill purchases. |
| Buyer mobile application | Contractors, independent builders, and DIY or homeowner Buyers | Find suppliers, compare materials, plan project purchases, communicate with stores, and manage orders. |

The applications share the same order and case records. For example, a Buyer submits a purchase request, the Vendor responds to it, and an authorized Admin can inspect the relevant history when support or formal review is required.

## 2. Registration, login, and account recovery

### 2.1 Admin account creation

Admin accounts are invitation-only. An existing Buyer or Vendor cannot change their account into an Admin account.

**How it works:**

1. An authorized system operator establishes the initial Super Admin through the protected setup process.
2. An authorized Super Admin invites later Admin staff and assigns their permitted role.
3. The invited person opens the invitation, completes account setup, and sets their password.
4. The person completes required email verification, authenticator enrollment, and policy acceptance before receiving activated access.

An invitation gives access to the assigned responsibilities. It does not give every employee unrestricted platform control.

### 2.2 Admin login

The Admin signs in with their invited email and password, then completes mandatory authenticator-app verification. The authenticator produces a time-based code, commonly called TOTP.

**Main features:**

- Individual accounts and permission-based access.
- Authenticator enrollment, verification, and recovery procedures.
- Password recovery and session management.
- Additional identity confirmation for sensitive administrative actions.

**How to use:** Open the Admin sign-in page → enter account details → complete the required security check → open Dashboard. The Account settings workspace provides personal security and session controls.

### 2.3 Vendor Owner registration

A new business begins by creating a Vendor Owner account. This creates access to onboarding; marketplace participation requires further verification and setup.

**How it works:**

1. Open the Vendor website and select registration.
2. Register with email and password or Google.
3. Provide the Owner's name, contact number, and other required account information. Email registration also requires password confirmation.
4. Review and accept the required Vendor Terms of Service and Vendor Code of Conduct.
5. For email registration, verify the email using the emailed code. A valid Google-verified email satisfies email ownership verification without a duplicate email code.
6. Continue from Welcome to Store Verification and Store Setup.

The public store name and detailed business information are supplied during onboarding. Registration alone does not make the store approved, activated, or visible to Buyers.

### 2.4 Vendor login and employee access

Owners and invited employees use the same Vendor sign-in page. They can use email/password or an appropriately linked Google identity. The portal identifies their store membership and role after authentication.

**Main features:**

- Role-specific Dashboard and navigation.
- Authenticator verification for privileged Owner and Store Manager access.
- Email verification and additional checks when required.
- Separate employee invitations, so staff do not share the Owner's login.

**How to use:** Sign in → complete any required verification → open the role-aware Dashboard. Invited staff accept their own invitation and join the existing store; they do not repeat business onboarding.

### 2.5 Buyer registration

Buyer registration creates an individual account for purchasing construction materials through the mobile application.

**How it works:**

1. Open the Buyer app and select Sign Up.
2. Choose email/password or Google registration.
3. Complete the required name, email, mobile number, Buyer type, and any other required fields shown for that type. Email registration also requires a password and confirmation.
4. Review the Terms of Service and Privacy Notice, then record the required acceptance and acknowledgment.
5. Verify the emailed code for email registration. Google registration uses the verified Google email and asks for any missing account information.
6. Complete or skip optional work-profile onboarding.
7. Choose the location used to discover suppliers.

Optional work information can describe the Buyer's company, industry, or material interests. Skipping optional onboarding does not remove the required account details.

### 2.6 Buyer login and location setup

An existing Buyer signs in using email/password or their linked Google account. Additional verification can appear for account security, recovery, or an unfamiliar device. Routine login on a recognized device does not require an email code every time.

The Buyer then uses a current location, a searched or manually selected address, a map pin, or a saved location. GPS permission is optional; manual location selection remains available.

**How to use:** Sign In → complete any requested verification → choose a location when needed → use Map, Explore, Projects, Messages, or Profile.

### 2.7 Password recovery, verification, and logout

All three applications provide controlled account-recovery processes. The user requests recovery, follows the eligible emailed instructions, and completes any required security verification. A successful password reset revokes existing sessions.

Email verification codes are temporary and single-use. Mobile numbers are contact fields; MateryalPH does not use SMS OTP. Admin authenticator requirements and privileged Vendor checks remain applicable during recovery.

Account settings provide the relevant password, two-factor authentication, and session controls. Logout ends the current authenticated session. In the current capstone, one email cannot create multiple MateryalPH account types.

## 3. Admin portal

The Admin portal supports platform operations and formal review. Access to a page does not automatically permit every decision, export, or financial action within it.

### 3.1 Overview

#### Dashboard

Dashboard is the Admin's starting point for understanding platform activity and finding work that needs attention.

**Main features:**

- Summaries of Vendor and Buyer activity, order activity, pending verification, disputes, and other authorized queues.
- Tabs for operational, compliance, dispute, finance, and platform-health information.
- Links from relevant summaries to the underlying work queues.
- Charts and advisory planning insights when enough data is available.

**How to use:** Open Dashboard → choose the relevant tab or period → inspect a summary → follow its link to the records requiring action. Financial and operational information follows the Admin's permissions.

### 3.2 User Management

#### Vendor Users

Vendor Users is a searchable directory for understanding a store and its account history during authorized support or review.

**Main features:**

- Store search and status or join-date filters.
- Read-only Vendor Details with store information, Owner information, verification and activation status, and permitted activity history.
- Store and product reviews, basic listings, and public stock labels.

**How to use:** User Management → Vendor Users → search or filter → open a store. Verification decisions and sanctions are handled in their dedicated sections. Directory access requires its own permission and is audited; exact inventory remains private.

#### Buyer Users

Buyer Users helps authorized staff locate a Buyer account and understand its relevant marketplace activity.

**Main features:**

- Search and account-status, Buyer-type, or join-date filters.
- Read-only profile, relevant order and quotation activity, reviews, and usage history.
- Enforcement history when the reviewer also has the required enforcement permission.

**How to use:** Buyer Users → find the account → open Buyer Details → review the information relevant to the concern. The directory protects exact coordinates, site instructions, payment details, and private documents. Profile access is audited.

### 3.3 Marketplace

#### Marketplace Analytics

Marketplace Analytics explains where platform supply and demand are concentrated and how marketplace activity changes over time.

**Main features:**

- Philippines geographic map with region, province or independent-city, and city or municipality drilldown.
- Equivalent table, geographic navigation, dates, and other applicable filters.
- Vendor presence, Buyer activity, order volume, gross and net marketplace value, fulfillment, response performance, and material demand.
- Materials Analytics for comparable public listed-price history within the selected geographic area.

**How to use:** Open Marketplace Analytics → choose the area and reporting period → inspect the metrics or table → open Materials Analytics when researching listed prices.

Visible, online Admin analytics automatically refetch every 30 seconds. Geographic facts are rebuilt every minute while the scheduler runs; historical material prices are captured daily. Read the displayed timestamps. Small-group privacy controls apply, and detailed price-source inspection requires a separate permission.

### 3.4 Compliance & Quality

#### Vendor Verification

Vendor Verification is the review workspace for a business's submitted identity, registration, tax, and other applicable evidence.

**Main features:**

- Queues for pending review, corrections, rejection, approval, and expiry.
- Requirement-by-requirement evidence and review history.
- Approval, return-for-correction, or rejection with the required explanation.
- Separate Store Verification, Store Setup, activation, and discoverability information.

**How to use:** Open the queue → select a Vendor → examine each applicable requirement → record the permitted review decision. Uploading a document does not automatically approve it. Setup completion and review approval remain separate from activation.

#### Product Compliance Queue

Product Compliance Queue handles manual review of regulated-product evidence, including applicable PS Mark or ICC Sticker information.

**Main features:**

- Listing details alongside marking images, entered information, and available reference matches.
- Approval, correction requests, rejection, and decision history.
- Dated reference-register maintenance where the Admin has the required permission.

**How to use:** Open a submission → compare the product and supporting evidence → record the appropriate decision. The outcome affects the relevant listing's eligibility. The platform records an evidence review; it does not issue a government certification.

#### Disputes & Appeals

Disputes & Appeals brings the original complaint, both parties' responses, and the relevant transaction history into a formal case.

**Main features:**

- Original complaint, requested remedy, evidence, deadlines, and timeline.
- Clarification requests and reasoned decisions.
- Linked replacement, refund, or other permitted remedy progress.
- Appeal review against the original decision, with a different reviewer where required.

**How to use:** Open the case → review the complaint and evidence → request clarification if needed → record an authorized decision → monitor the remedy. A decision and a completed refund have separate progress.

#### Enforcement

Enforcement handles reviewed account warnings, restrictions, suspension, reactivation, and other permitted sanctions.

**Main features:**

- Account flags and relevant incident evidence.
- Action scope, reasons, restoration conditions, and history.
- Permission and identity checks for sensitive decisions.

**How to use:** Open the flagged record → assess the evidence and existing obligations → choose a permitted action → record the required reason. Reports and indicators support review; they do not independently authorize an automatic ban.

#### Score & Badge Monitoring

Score & Badge Monitoring helps administrators understand published reputation measures and investigate possible calculation or source-data problems.

**Main features:**

- Published Vendor scores, components, sample information, and badge eligibility.
- Supporting records and calculation history.
- Traceable correction events where the authorized process permits them.

**How to use:** Select a Vendor → examine the score and supporting metrics → investigate the underlying records. Scores and performance badges follow the approved rules; the page does not provide arbitrary manual awards.

#### Review Moderation

Review Moderation handles reported reviews through a documented assessment of the content and complaint.

**Main features:**

- Report reasons, review text, and permitted supporting media.
- Relevant evidence and previous moderation history.
- Recorded moderation outcome and explanation.

**How to use:** Open a reported review → examine the report and evidence → record the permitted decision. A user report begins review; it is separate from the final moderation outcome.

### 3.5 Finance

#### Transaction

The sidebar label **Platform Finance** opens the platform's finance module. It connects platform earnings, commission billing, Buyer payment and refund records, and reconciliation work.

**Main features:**

- **Overview:** platform earnings and platform-held funds, kept apart from marketplace payments (gross merchandise value, Buyer payments, refunds to Buyers and net Vendor collections), with trend charts, a payment-method breakdown and tasks requiring attention.
- **Commission Management:** rate policies, Vendor statements, charges, credits, and billing status.
- **Payments and Refunds:** authoritative transaction records and their source orders.
- **Reconciliation:** mismatches, exceptions, and supporting evidence.
- Supporting withholding, tax, adjustment, and report views under separate permissions.

**How to use:** Transaction → select the appropriate finance view → open a statement or transaction → inspect its basis and history. Publishing an authorized rate change preserves the original rate on historical orders. Sensitive finance preparation and approval use separate named users where required.

The approved baseline commission is 2%, paid by the Vendor, billed monthly, and earned on completed materials after discounts and excluding materials VAT. Buyer processing fees, withholding, and commission remain distinct. Tax reports and certificate previews are demonstrations; production withholding responsibility remains unconfirmed.

#### Orders & Refunds

Orders & Refunds gives authorized staff a cross-party view for investigating an order and its related financial events.

**Main features:**

- Order lists and the commercial and fulfillment timeline.
- Payment, cancellation, refund, and related case records.
- Separate Cancellation Refund and Dispute-Conclusion Refund history.

**How to use:** Find the order → inspect its timeline → open the linked payment, refund, or case. Payment success follows verified provider evidence or authoritative reconciliation; opening an Admin record does not itself settle a transaction.

#### Invoice Request Log

Invoice Request Log monitors Buyer requests for Vendor-issued invoice copies or corrections.

**Main features:**

- Request, order, and responsible Vendor references.
- Response and invoice-copy status.
- Request history for follow-up and oversight.

**How to use:** Open the log → locate the request → inspect its linked order and response. The Vendor supplies the actual invoice through its own registered process; the platform records the copy and request workflow.

### 3.6 Platform

#### Platform Settings

Platform Settings manages the approved operational defaults that authorized administrators may change.

**Main features:**

- Current settings, validation, and version history.
- Proposed changes with a required reason.
- Recent identity verification for protected changes.

**How to use:** Select a setting → review its current value and allowed scope → prepare and confirm the authorized change. Previous versions remain traceable. The page manages approved non-secret settings and does not expose provider credentials.

#### Support Requests

Support Requests is the Admin workspace for concerns submitted by Buyers, Vendors, and guests.

**Main features:**

- Searchable ticket queue and status filters.
- Ticket conversation and permitted attachments.
- Eligible handler assignment, responses, and status history.

**How to use:** Open a ticket → read the concern → assign or respond as permitted → update its status. The requester follows the same ticket from their application. Formal disputes and financial decisions continue through their own authorized processes.

#### Integration & Job Health

Integration & Job Health helps administrators identify problems with connected services and background processing.

**Main features:**

- Relevant provider health and failed or pending background work.
- Analytics aggregation and snapshot freshness information.
- Safe diagnostic messages and authorized retry actions for supported failures.

**How to use:** Open the affected service or job → inspect its status and diagnostic information → retry when permitted. Healthy status describes the observed service state; it does not establish live payment or regulatory approval.

### 3.7 Tracking

#### Audit Log

Audit Log provides a traceable history of significant actions across the platform.

**Main features:**

- Search and filters for actor, action, resource, and date.
- Timestamp, result, reason, and available correlation or change references.
- Controlled access and export permissions.

**How to use:** Apply filters → open the relevant event → follow its affected record. Audit history is append-only; corrections create further events and preserve the original attribution.

### 3.8 Admin account settings and notifications

Account settings is reached from the portal header. It contains the Admin's personal profile, security, sessions, and agreements. Authorized Super Admin controls provide later Admin invitations and account management.

The notification bell opens relevant updates and links to records the current Admin may access. Notification delivery-failure information has its own permitted view.

## 4. Vendor portal

The Vendor portal manages one store's operations. Owners and employees receive different pages and actions. Protected Finance and Earnings remain Owner-only; competitor Materials Analytics is available to the Owner and Store Manager.

### 4.1 Before full access: onboarding and activation

Vendor onboarding has two independent workstreams.

| Workstream | Purpose | Typical information |
| --- | --- | --- |
| Store Verification | Establish business identity and applicable evidence for manual Admin review. | Legal business type and name, representative authority where applicable, contacts, address, registration, tax information, and required documents. |
| Store Setup | Configure how the store appears and operates. | Public profile, procurement capability, hours, fulfillment, conditional delivery setup, and payment readiness. |

**How to use:** Welcome → Store Verification → save or submit applicable requirements → Store Setup → review the activation checklist → request activation when the server reports readiness.

The Owner can save drafts, continue setup while verification is pending, or finish later through the Limited Dashboard. Saved progress does not imply Admin approval.

Store Activation requires the applicable approvals, completed setup, required Xendit onboarding, current agreements including Commission Terms, and no blocking hold. Self-Pickup Only does not require a vehicle or Fulfillment Staff. Vendor Delivery or Both requires eligible staff, a registered eligible vehicle, and delivery settings.

Marketplace Discoverability is checked separately. An activated store needs eligible listings, current available inventory, applicable product compliance, and serviceability before appearing in Buyer discovery.

### 4.2 Overview

#### Dashboard

Dashboard summarizes the store's activity and the tasks the signed-in user should handle next.

**Main features:**

- Limited-access onboarding progress and activation blockers when the store is not ready.
- Role-appropriate order, quotation, inventory, compliance, and case alerts.
- Performance, sales, traffic, and quality tabs where authorized.
- Trends and advisory insights when enough data exists.

**How to use:** Open Dashboard → review action items → follow the relevant order or workspace. Employee views retain the information needed for their work; Owner financial information remains protected.

### 4.3 Store Operations

#### Orders

Orders is the main workspace for handling Buyer purchase requests and their accepted commercial terms.

**Main features:**

- Separate views for new requests, Buyer responses, pending payment, confirmed work, and closed records.
- Materials, quantities, prices, fulfillment details, and response deadlines.
- Authorized confirmation, decline, or proposed revision.
- Processing, assignment, fulfillment, and timeline information.

**How to use:** Open a request → review its materials and delivery or pickup terms → confirm or propose a permitted revision → wait for any required Buyer approval and payment conditions → process fulfillment.

Commercial changes requiring acceptance return to the Buyer. Any Non-Recoverable Preparation Cost must be explained and accepted through its permitted workflow; it is a disclosed part of the order value.

#### Messages

Messages brings store sales conversations and related Project inquiries together so staff can respond with the correct purchasing context.

**Main features:**

- Buyer conversations with public sender identity and role.
- Product reference cards and related Work Package inquiries.
- Quotation drafts, publication where authorized, version history, and response deadlines.
- Related requirements and commercial changes for review.

**How to use:** Open the Buyer conversation → inspect the product or Project context → discuss requirements → prepare and publish a quotation when authorized. The Buyer chooses an available payment method before accepting the latest quotation. Published versions remain in history.

#### E-Invoices

E-Invoices organizes copies of the Vendor's issued invoices and requests from Buyers who need a copy or correction.

**Main features:**

- Buyer requests and orders without an uploaded copy.
- Existing uploaded invoice copies.
- Differences between invoice information and the recorded order.

**How to use:** Open a request or eligible order → supply the permitted invoice copy → review any differences or correction request. The Vendor remains responsible for issuing the underlying invoice through its registered process. Demo files must remain clearly identified as samples.

#### Disputes & Appeals

Disputes & Appeals lets the Vendor participate in formal transaction complaints and follow the resulting decisions.

**Main features:**

- Original complaint, requested remedy, evidence, and deadlines.
- Authorized responses and proposed resolutions.
- Decision, remedy, refund, and permitted appeal history.

**How to use:** Open the case → read the original concern → submit the permitted response and evidence → follow the decision and remedy. Staff access depends on role and the applicable store permission; assigned Fulfillment Staff receive only the relevant restricted information.

#### Ratings & Reviews

Ratings & Reviews separates feedback about the store, purchased products, and the Vendor's feedback about Buyers.

**Main features:**

- Store ratings and reviews.
- Product reviews and permitted review media.
- Eligible Buyer-rating records and review reports.

**How to use:** Select the relevant review area → inspect the feedback → rate an eligible Buyer or report a review when permitted. Reports go through Admin moderation, and all ratings remain subject to transaction eligibility rules.

#### Fulfillment: assigned staff workspace

Fulfillment is an additional role-specific page for Fulfillment Staff. It may be absent from the Owner's sidebar shown in the screenshot.

**Main features:**

- Assigned orders, relevant materials, destination, vehicle, and instructions.
- Order-specific Fulfillment Messages.
- Route directions, permitted milestone updates, receiver details, and proof submission.

**How to use:** Sign in as assigned Fulfillment Staff → open Fulfillment → inspect the assignment → coordinate the handover → submit the required proof. The Buyer has a separate receipt-confirmation step. Directions are estimates; the system does not provide live delivery GPS tracking.

### 4.4 Store Management

#### My Products

My Products manages the store's catalog and inventory through its Listings and Inventory views.

**Main features:**

- Product classification, descriptions, specifications, variants, units, prices, volume pricing, and photos.
- Draft, publication, and eligibility information.
- Applicable PS/ICC evidence with supported photo/OCR, QR, entry, and manual-review paths.
- Variant stock, adjustments, reservations, history, and stock-confirmation information.
- Optional auto-accept allotments and safeguards for eligible Item-Based orders.

**How to use:** My Products → Listings → add or edit a product → complete applicable information and evidence → review its publication status. Use Inventory to maintain quantities and inspect stock history.

Available-to-sell stock equals quantity on hand minus hard reservations. Stock is reserved at the required acceptance stage, and quantity on hand drops at fulfillment. Auto-accept begins disabled, is Item-Based only, and is unavailable when NRPC applies; a failed safeguard sends the complete Vendor order for manual review.

#### Vehicles

Vehicles records the store's delivery resources so eligible transport arrangements can be assessed and confirmed.

**Main features:**

- Registered vehicle details, image, capacity, dimensions, availability, and rates.
- Eligibility information used in delivery planning.
- Connections to the accepted vehicle arrangement in delivery orders.

**How to use:** Register or maintain a vehicle → review the suggested arrangement in Order Details → let the Owner or Store Manager confirm the vehicle and assign eligible staff. Dispatch requires the accepted vehicle to remain eligible. Fulfillment Staff use their assignment view rather than managing commercial vehicle choices.

#### Finance

Finance is the Owner's protected workspace for payment readiness, transaction records, tax references, and commission obligations.

**Main features:**

- Finance overview, Xendit readiness, and configured online channels.
- Transaction history with linked payment and refund information.
- Vendor Tax Profile reference, withholding and gross-remittance information.
- Commission monitoring, original order rates, monthly statements, charges, credits, and outstanding amounts.
- Eligible commission-statement payment and payment-history views.
- Explicit review and acceptance of current Commission Terms.

**How to use:** Finance → choose the overview, history, or commission area → inspect the linked order or statement. The Owner reviews and explicitly accepts current terms through the Finance dialog when required.

The approved baseline commission is 2% of completed materials after discounts and excluding materials VAT, billed monthly to the Vendor. Records retain their applicable rate version. Finance does not provide a marketplace wallet, withdrawal balance, escrow, or automatic commission deduction.

### 4.5 Analytics

#### Store Performance

Store Performance helps the Vendor understand product demand and identify listings that may need pricing, content, or inventory attention.

**Main features:**

- Product views, confirmed orders, and view-to-order conversion.
- Most-viewed, top-selling, and top-performing product comparisons.
- Product-level trends and related review information.
- Forecasts, purchasing patterns, product groupings, and suggestions when the dataset supports them.

**How to use:** Select a period → inspect the rankings and charts → open a product for more detail → decide what needs attention. Suggestions are advisory and do not change products automatically. Peso-based measures follow financial permissions.

#### Materials Analytics

Materials Analytics helps the Owner or Store Manager research public listed prices for comparable construction materials in a selected area.

**Main features:**

- Location, radius, category, comparable specification, and date controls.
- Recorded daily averages, current eligible offers, and sample information.
- Variant-level price details and trend graphs or tables.

**How to use:** Select the area and material → choose a comparable variant → inspect the history and current offers. Listed-price history supports planning; it is separate from completed sales, negotiated quotations, and private inventory. Sparse data and missing observations are identified.

#### Earnings

Earnings provides the Owner's store-level financial reporting view.

**Main features:**

- Commercial sales, online collections, physical collections, and estimated remittance cash, each with its own calculation.
- Refunds, provider charges, simulated withholding, commission, and unpaid-statement references.
- Date filters, daily or monthly trends, accessible chart tables, and prior-period comparisons when applicable.
- Top-selling product information and an authorized Earnings export.

**How to use:** Open Earnings → choose the available period and filters → read the totals with their definitions → inspect the supporting records where available. Reported earnings are financial measures; they do not represent an internal withdrawable wallet balance.

### 4.6 Vendor Team Accounts

#### Team Accounts

Team Accounts gives employees their own identities and fixed responsibilities within the store.

**Main features:**

- Individual invitations and membership status.
- Store Manager, Store Staff, Customer Service Staff, Inventory Staff, and Fulfillment Staff roles.
- Permitted membership changes, suspension, reactivation, and Owner delegation controls.
- Historical attribution of each person's actions.

**How to use:** An authorized Owner or delegated Manager opens Team Accounts → selects the permitted role → sends an invitation → manages the resulting membership. Manager staff-management delegation has a limited scope; it does not grant ownership or protected Finance access.

Staff are optional for Self-Pickup Only. Offering Vendor Delivery requires an eligible active Fulfillment Staff member as part of delivery readiness.

#### Team Tracking

Team Tracking shows attributable employee activity and available performance information for operational oversight.

**Main features:**

- Activity records for relevant store actions.
- Staff filters and available performance summaries.
- Links between work and the individual employee responsible.

**How to use:** Open Team Tracking → select a person or period → inspect the recorded activity. Manager access requires the relevant delegation and is limited to non-manager staff. This section tracks work records; it is separate from delivery directions.

### 4.7 Store Profile

#### Store Profile

Store Profile maintains the store's public presentation and its permitted business and operational configuration.

**Main features:**

- **Store Information:** public store identity and presentation.
- **Business Information:** applicable submitted legal and verification information.
- **Store Location:** the registered or configured store location.
- **Vacation Mode:** permitted temporary operational availability settings.
- **Operating Hours:** the store's working schedule.
- **Fulfillment Configuration:** procurement capability, pickup or delivery, and conditional delivery requirements.

**How to use:** Open Store Profile → choose the relevant tab → edit the information allowed for the current role → save or submit for review as required. Public store information and private business evidence have different visibility; an edit does not automatically approve changed legal information.

### 4.8 Vendor account, notifications, and support

Account settings concerns the signed-in person: profile, password, authenticator, device sessions, and agreements. Store Profile concerns the business.

The notification bell links to relevant updates. Support provides Contact Us and the Vendor's own support tickets, where they can read replies and continue the same conversation. Guests have a separate email-based process for accessing their own requests.

## 5. Buyer mobile application

The Buyer app has five primary tabs: **Map**, **Explore**, **Projects**, **Messages**, and **Profile**. Supporting screens such as Cart, Product Details, and Orders are reached from these destinations or their shortcuts.

### 5.1 Map

Map helps the Buyer locate nearby suppliers around the selected delivery location or project area.

**Main features:**

- Current, searched, manually selected, or saved location.
- Radius choices of 5, 10, 20, 30, 40, and 50 kilometers.
- Supplier markers and a synchronized supplier list.
- Applicable supplier-type, category, favorite, and supplier-tier filters.
- Supplier previews, store access, and supported route previews.

**How to use:** Select a location → choose a radius → inspect a marker or list entry → open the relevant supplier information. Increasing the search radius requires the Buyer's choice.

There are two supplier types:

| Supplier type | Meaning | Available interaction |
| --- | --- | --- |
| Tier 2 Verified Vendor | An eligible participant in the MateryalPH marketplace. | View the store and eligible products, message, and purchase through the permitted workflows. |
| Tier 1 Directory Supplier | An attributed Google directory reference. | View limited place information; platform ordering, messaging, reviews, and MateryalPH scores are unavailable. |

A Google rating is directory information. VPS is a MateryalPH performance measure for eligible marketplace Vendors. Route previews show estimates and do not track a delivery vehicle in real time.

### 5.2 Explore

Explore is the catalog for finding and comparing materials offered by eligible Verified Vendors within the selected location and radius.

**Main features:**

- Material categories, search, filters, and sorting.
- Nearby Verified Vendor and available-product counts.
- Product cards, recently viewed products, and Favorite Suppliers.
- Product Details, Vendor Store, Materials Analytics, and Cart access.

**How to use:** Select a category or search for a material → compare eligible results → open a product → review its specifications, options, and fulfillment choices. Catalog browsing begins with distance; text search begins with Best Deal. Ranking uses the applicable Buyer preferences and eligibility rules.

#### Product Details

Product Details helps the Buyer confirm exactly which material they intend to buy.

**Main features:** Product photos, description, specifications, unit, variants, price, public availability, applicable compliance information, quantity selection, and supported pickup or delivery.

**How to use:** Choose the required variant and quantity → inspect the fulfillment option → add to Cart or message the Vendor. Public availability uses labels and does not expose exact internal inventory.

#### Vendor Store

Vendor Store helps the Buyer assess a marketplace supplier before purchasing.

**Main features:** Products and Store Profile views, store information, operating hours, fulfillment options, eligible ratings and badges, Favorite Supplier controls, and messaging.

**How to use:** Open the store from Map or a product → browse products → inspect the profile → save it as a favorite or start a conversation. Private verification files and staff contact details are protected.

#### Materials Analytics and Material Price Details

Materials Analytics shows recorded public listed prices for materials with comparable units and specifications. Material Price Details expands a material into its variants, history, and current eligible offers.

**Main features:** Category and date filters, daily averages, 7/30/90-day or custom periods, graphs and tables, sample information, comparable variants, and current offers that link to Product Details.

**How to use:** Explore → View Materials Analytics → select a material and variant → inspect the recorded history → open a current offer if interested. Historical observations and current offers have separate timestamps. Limited Local Data, missing observations, and materials that are Not Yet Comparable are identified.

#### Cart and checkout

Cart organizes selected products by Vendor. Checkout reviews the purchase request and its applicable terms before submission.

**Main features:** Quantity review, Vendor grouping, location and fulfillment review, available cost breakdown, and order submission.

**How to use:** Add products → open Cart → review each Vendor group → complete checkout → follow confirmation and payment steps. One checkout can create a separate child order for each Vendor. Cart placement does not reserve stock; the server checks inventory and commercial terms at the required acceptance stage.

### 5.3 Projects

Projects helps a Buyer plan and monitor construction procurement across a defined site, budget, and set of material requirements.

**Main features:**

- Project name, site, timeline, and overall budget.
- Work Packages containing material lines, quantities, units, and specifications.
- Vendor comparison and supported procurement arrangements.
- Related requests, quotations, orders, budget usage, and progress.

**How to use:** Create a project → define its site and budget → add Work Packages → activate a prepared package for comparison → review an arrangement → explicitly submit the purchase requests.

#### Project overview and sites

Overview brings together the project plan, budget, and procurement progress. Sites stores the construction locations used by Work Packages and supplier comparison.

**How to use:** Open a project → review Overview → add or select the site → open the related Work Package. Comparisons use the relevant project site rather than assuming every purchase belongs at the profile address.

#### Work Packages

A Work Package groups the materials needed for a defined scope, such as foundation work or roofing.

**Main features:** Material requirements, specifications, units, quantities, budget allocation, fulfillment details, optional planning estimates, and lifecycle progress.

**How to use:** Add the material lines → allocate a budget → save a draft → activate when ready to compare. Allocations must fit the Project budget. Saving and activation are separate actions; a system estimate remains a planning value.

#### Vendor comparison and procurement arrangements

Comparison helps the Buyer review eligible ways to fulfill the package using a complete single Vendor or a supported group of Vendors.

**Main features:** Material coverage, specification choices, projected materials and delivery costs, location, performance factors, and Best Match explanations. Where alternatives exist, the system can present up to three distinct supplier-group options alongside complete single-Vendor options.

**How to use:** Open Find vendors → inspect the map or list → resolve required specification choices → review an arrangement and checklist → explicitly submit. Selecting an arrangement first saves a draft. Each participating Vendor retains its own quotation, order, payment, and fulfillment responsibilities.

Ready-mixed concrete follows the supported mixer-delivery arrangement. A failed supplier allocation can be replaced through the permitted flow while other member orders remain intact.

#### Budget and progress monitoring

The budget view distinguishes allocated funds, pending spend, actual spend, and paid amounts awaiting refund, helping the Buyer understand remaining funds.

**How to use:** Open Project Overview → inspect the budget summary → review each package and related order. A warning appears at 90% utilization. Checkout that would exceed the budget requires an explicit override with a written reason. Package completion depends on fulfilled requirements or recorded explicit waivers.

### 5.4 Messages

Messages organizes Buyer conversations by Vendor Store and keeps purchasing discussions connected to their product or Project requirements.

**Main features:**

- Store conversations and public sender identity or role.
- Product references and related Project inquiries.
- Formal quotation review, version history, counter-offers where permitted, and deadlines.
- Explicit payment-method selection before accepting the latest quotation.

**How to use:** Open a store conversation → discuss the materials → open the relevant Project inquiry when applicable → inspect the latest quotation → choose an available payment method → accept or respond through the permitted action.

An ordinary chat message can clarify requirements. A formal quotation records commercial terms; a published revision creates a new version and only the latest eligible version can be accepted. An order's Fulfillment Messages is a separate coordination thread reached from Order Details.

### 5.5 Profile

Profile collects purchasing records, account tools, preferences, and support. The following entries are supporting screens under Profile, rather than additional primary tabs.

#### My purchases

| Entry | Explanation | How to use |
| --- | --- | --- |
| Orders | Tracks Item-Based and Project-Based purchases, pending actions, fulfillment, and history. | Open Orders → select Item or Project and the relevant status → open Order Details. |
| Cart | Returns to products selected for a possible purchase. | Review Vendor groups and quantities, then continue to checkout. |
| Cancellations & Refunds | Shows eligible cancellation actions or outcomes and linked refund progress. | Open the relevant order or record → review eligibility and the recorded result. |
| Disputes | Records eligible transaction complaints, evidence, responses, requested remedies, decisions, and permitted appeals. | Open the eligible order or case → provide the required information → follow deadlines and updates. |
| My Reviews | Manages eligible reviews connected to completed purchasing experiences. | Open an eligible record → provide the permitted store or product feedback → review its status. |

#### Order Details, payment, and fulfillment

Order Details shows the accepted materials, amounts, payment information, fulfillment date, timeline, authorized assignment information, and available proof.

**How to use:** Open an order → inspect its current stage → complete the available next action. Depending on eligibility and store support, methods include Online Payment through Xendit TEST, Cash on Delivery for delivery, and In-Store Payment for pickup. Available methods and the point of selection follow the specific checkout or quotation flow.

For delivery or pickup, follow the recorded readiness and handover milestones. Use Fulfillment Messages for coordination and the available receipt-confirmation or issue-reporting action after handover.

Buyer cancellation is unavailable once an order is Ready for Pickup or Out for Delivery. Applicable dispute and statutory remedies remain available. Order, payment, fulfillment, refund, and dispute states are tracked separately. Online payment success depends on verified provider events or authoritative reconciliation.

Invoice-copy requests and permitted correction requests are reached through the relevant order flow. The Vendor provides its issued invoice copy.

#### Account

| Entry | Explanation | How to use |
| --- | --- | --- |
| Account Setting | Personal information, account security, and account actions. | Open it to edit permitted details or use its security and session tools. |
| Favorite Suppliers | Saved marketplace stores for later discovery and purchasing. | Open a saved store, message it when eligible, or remove it from favorites. |
| Saved Locations | Reusable delivery addresses and project-related places. | Add or manage a location, then select it for the relevant procurement flow. |
| About your work | Optional company, role, industry, and purchasing-interest information. | Update the optional work profile without creating a Buyer team account. |
| Ranking Preferences | Separate Item-Based and Project-Based ranking preferences. | Choose the procurement type, adjust the importance of its factors, and save or reset as offered. |
| Notification Settings | Preferences for supported notification delivery. | Review the available channels and save the desired settings. |

Inside Account Setting, the Buyer can find Edit Account Details, Two-Factor Authentication (2FA), Password Manager, Sessions / Devices, and Delete Account. Sensitive changes require the applicable verification. Account deletion follows eligibility and retention rules.

Item-Based and Project-Based preference sliders express each factor's importance independently. Recommendations remain subject to the relevant server-side eligibility and ranking rules.

#### Support

| Entry | Explanation | How to use |
| --- | --- | --- |
| Help Center | Guidance and access to Contact Us and My Support Requests. | Submit a concern, keep the ticket reference, and follow replies in the same ticket. |
| Terms & Agreements | Applicable policy information and recorded agreement versions. | Open and review the available terms and agreement information. |

The notification bell opens the inbox of relevant account, order, conversation, and case updates. Selecting an update opens the permitted related record. Notification Settings controls delivery preferences; the inbox shows received updates. Logout ends the current session.

## 6. How the three applications work together

The following example connects the sections without treating every purchase as a dispute.

1. **Vendor preparation:** An Owner registers, completes verification and setup, receives the required approvals, and requests activation. Eligible listings and inventory then allow the store to appear in Buyer discovery.
2. **Buyer discovery:** A Buyer registers or signs in, chooses a site, and finds materials through Map or Explore.
3. **Purchase planning:** The Buyer adds items to Cart or prepares a Project Work Package and reviews an eligible arrangement.
4. **Commercial confirmation:** The Vendor reviews the request or publishes a quotation. The Buyer reviews required changes and accepts the applicable terms and payment method.
5. **Payment and fulfillment:** The relevant payment conditions are satisfied through the permitted TEST/demo flow. The Vendor processes the order and coordinates pickup or delivery with assigned staff where needed.
6. **After handover:** The Buyer confirms receipt or reports an eligible issue. Eligible review and invoice-copy actions become part of the relevant follow-up flow.
7. **Support and oversight:** Admins handle applicable verification, support, formal disputes, moderation, or reconciliation. Significant actions retain their authorized history.

**Example explanation for a presentation:**

"MateryalPH connects three responsibilities. The Buyer finds and purchases construction materials. The Vendor supplies the materials and manages fulfillment. The Admin reviews compliance, handles platform concerns, and monitors accountable operations. Their applications share the relevant records, while each role receives only its permitted actions and information."

## 7. Common terms

| Term | Simple explanation |
| --- | --- |
| Item-Based Procurement | Purchasing selected catalog items, with a separate order for each participating Vendor. |
| Project-Based Procurement | Organizing construction purchases through Projects, budgets, material requirements, and Work Packages. |
| Work Package | A defined set of material requirements and budget within a Project. |
| Procurement arrangement | A selected complete single-Vendor or supported multi-Vendor way to supply a Work Package. |
| Quotation | A versioned formal proposal containing commercial and fulfillment terms. |
| Store Verification | Admin review of applicable business information and evidence. |
| Store Setup | Configuration of the store's public and operational information. |
| Store Activation | Server-confirmed readiness to participate under the applicable requirements. |
| Marketplace Discoverability | Separate eligibility for the store and listings to appear in Buyer discovery. |
| VPS | Vendor Performance Score: the platform's applicable published Vendor performance measure. |
| PS / ICC | Product-marking or certification evidence considered under the applicable regulated-product workflow. |
| NRPC | Non-Recoverable Preparation Cost: a disclosed, manually handled portion of the existing order value when permitted. |
| GMV | Gross merchandise value: a measure of confirmed marketplace order value; net GMV accounts for applicable cancellations and refunds. |
| Reconciliation | Checking transaction records against authoritative evidence and investigating differences. |
| TOTP | A time-based verification code produced by an authenticator app. |
| Audit Log | Append-only records identifying significant actions, their actors, results, and timing. |

## 8. References and scope

This guide follows the approved workflows first, then the technical design, UI/UX planner, and inspected application navigation. The existing [demonstration script](MateryalPH_Demo_Script.md) provides a longer spoken walkthrough and presentation route.

**Authoritative product references:**

- [Product context](../../PRODUCT.md) and [design context](../../DESIGN.md).
- [Admin workflow](../workflows/MateryalPH_Final_Admin_Workflow.md).
- [Vendor workflow](../workflows/MateryalPH_Final_Vendor_Workflow.md).
- [Buyer workflow](../workflows/MateryalPH_Final_Buyer_Workflow.md).
- [System workflow](../workflows/MateryalPH_Final_System_Workflow.md).
- [Technical system design](../architecture/MateryalPH_Technical_System_Design.md).
- [UI/UX implementation planner](../design/MateryalPH_UI_UX_Implementation_Planner.md).

**Inspected navigation and contract references:**

- [Admin routes and account entry](../../apps/admin-web/src/App.tsx).
- [Admin sidebar](../../apps/admin-web/src/pages/PhaseThreeAdminPages.tsx).
- [Vendor routes and registration](../../apps/vendor-web/src/App.tsx).
- [Vendor sidebar, onboarding, and store settings](../../apps/vendor-web/src/pages/PhaseThreeVendorPages.tsx).
- [Buyer primary navigation](../../apps/buyer-mobile/lib/screens/buyer_home_screen.dart).
- [Buyer Profile entries](../../apps/buyer-mobile/lib/screens/buyer_profile_screen.dart).
- [API contract](../../packages/api-contract/openapi.yaml).

Use the actual displayed status, rate version, deadline, metric definition, and readiness message when demonstrating a record. Business deadlines display in Asia/Manila. This guide does not add a wallet, escrow, live delivery GPS, Buyer organization accounts, Vendor multi-branch management, or procurement beyond 50 kilometers.
