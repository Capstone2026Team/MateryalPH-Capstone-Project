**Buyer Flow**

---

### Mobile Application (Flutter/Dart)

MateryalPH provides a dedicated **mobile application** for Buyers. The Buyer application is separate from the Vendor and Admin web portals and supports account management, geolocation-based supplier discovery, Item-Based Procurement, Project-Based Procurement, orders, payments, delivery milestones, messages, ratings, disputes, and settings.

The System Workflow is the authoritative source for shared security, state, scoring, payment, privacy, accessibility, audit, and integration rules. This Buyer Workflow defines how those rules are presented to and used by the Buyer.

**Approved capstone operating basis — 5 September 2026.** MateryalPH is an academic prototype, not an asserted BIR-registered operating business. All Xendit integrations use TEST credentials and test accounts. Every payment screen, financial report, certificate preview and billing statement carries **DEMO — No real funds or BIR filing**. A successful test webhook demonstrates provider integration; it does not prove real collection, statutory withholding, remittance to the BIR, or government approval. Physical-payment demonstrations record simulated cash handover to the Vendor. Seeded identities and tax documents are conspicuously fictional and must never be submitted to regulators or used to represent a real business as verified.

The approved commercial design uses a **2% Vendor-paid commission on completed materials value after discounts and excluding materials VAT**, billed monthly for Online, COD and In-Store orders. The fee is distinct from Buyer-paid processor charges and Vendor withholding. No subscription or listing charge applies. The System Workflow's controls `FIN-01` through `FIN-12` are authoritative for calculation and implementation; the other workflows apply them within their existing screens. The production withholding entity is **UNCONFIRMED**. Test scenarios may simulate either responsibility path, but no Admin toggle can establish a real legal allocation or enable live money movement.

The term **Buyer** includes an SME contractor, independent builder, or DIY builder. Existing Buyers use **Sign In**. New Buyers use **Sign Up**. Vendor and Admin accounts use their respective web portals and cannot be created from the Buyer application.

---

**Buyer Sign-in and Sign-up**

**Buyer Sign-in**

The Buyer may sign in using email and password or a linked Google account. All requests use HTTPS and are validated by the Laravel backend. The application applies input validation, rate limiting, account-status checks, and risk-based bot protection. Authentication responses do not reveal whether an email belongs to an account.

For email/password sign-in, the backend verifies the securely hashed password, verified email status, account status, and applicable security controls. For Google sign-in, the backend validates the Google ID token, including signature, issuer, audience, expiration, nonce, and `email_verified`. The Google `sub` value is used as the external identity identifier. MateryalPH never requests or stores a Google password.

A routine login from a recognized device does not require an email OTP after every attempt. Email OTP is used for email ownership verification, account recovery, a new or suspicious device, and sensitive account changes. This avoids representing email as strong multifactor authentication while retaining a no-SMS capstone design. The Buyer may later enroll a stronger authenticator if offered.

**Buyer Sign-up**

The Buyer may register through:

- **Sign Up with Email and Password.** The Buyer provides full name, email address, mobile number, password and confirmation, Buyer type, Terms of Service acceptance, and Privacy Notice acknowledgment. The system sends a six-digit, short-lived, single-use OTP to the registered email. The account remains restricted until the OTP is verified.
- **Sign Up with Google.** The Buyer authenticates through Google. A valid verified Google email satisfies email ownership verification, so no additional email OTP is sent. The Buyer completes any missing required fields, including mobile number, Buyer type, Terms acceptance, and Privacy Notice acknowledgment.

The mobile number is a contact and delivery-coordination field only. MateryalPH does not send SMS OTP or routine SMS notifications. Philippine numbers are normalized to E.164 format and are not displayed publicly. The same email address cannot be used to create multiple MateryalPH account types in the current capstone; an existing account produces a safe instruction to use the appropriate application.

The system records the accepted Terms version, Privacy Notice version, user, timestamp, and source. Commercial Terms acceptance remains separate from privacy acknowledgment or consent.

**Forgot Password and Account Recovery**

The Buyer submits an email address and receives a generic response. If eligible, the system sends a time-limited, single-use recovery link or OTP. A successful reset invalidates existing sessions and refresh tokens, records a security event, and sends a confirmation notice. Repeated requests and failed codes are rate-limited. Changing the primary email requires reauthentication, verification of the new email, notice to the previous email, and session revocation.

---

**Buyer Onboarding**

After registration, the Buyer may complete or skip optional profile onboarding. Required account information remains complete even when onboarding is skipped.

Optional onboarding may collect:

- Business or company name.
- Position or role.
- Business address.
- Contractor or industry classification.
- Preferred material categories.
- Saved delivery addresses or project sites.
- First Procurement Project.

The contractor or industry classification uses a controlled list: General Contractor, Subcontractor or Trade, Independent Builder, DIY or Homeowner, or Other with a short required description (approved by the project owner on 2026-09-28). Company fields are optional for independent and DIY builders. A Buyer may save multiple addresses and project sites. Every order must identify the location used for discovery, pickup reference, or delivery. GPS permission is optional; denial never blocks address entry, map-pin placement, catalog browsing, or procurement.

Buyer organization team accounts are outside the current capstone scope. Every action is attributed to the individual Buyer account that performed it.

---

**Buyer Mobile Pages**

The bottom navigation contains five primary destinations: **Map**, **Explore**, **Projects**, **Messages**, and **Profile**. Map is the default authenticated destination. Each destination preserves the selected location and current procurement context when the Buyer temporarily moves to another tab. A protected deep link returns the signed-in Buyer to the requested record after authorization.

Every page implements `loading`, `content`, `empty`, `recoverable error`, `offline`, and `permission denied` states where applicable. Retry never duplicates an order, quotation acceptance, payment, cancellation, or dispute. Financial and destructive actions require a review screen and explicit confirmation. User-entered drafts are retained locally only when appropriate and are synchronized securely after connectivity returns; payment and inventory decisions always require an online server response.

**Map Home**

- **Design.** The top app bar contains the active Location Selector and labeled Search, Notifications, and Cart actions. Radius chips show `5`, `10`, `20`, `30`, `40`, and `50 km`; five kilometers is the default. A tune icon opens filters. The map filter set is Verified Vendors and Directory Suppliers toggles, Favorite Suppliers only, Supplier Type and Material Category; Favorite, Supplier Type and Material Category apply to Verified Vendors only and therefore hide Directory Suppliers while active. There is no Open Now, rating or review-count map filter, so saved hours never remove a supplier and Google ratings are never mixed with VPS (approved by the project owner on 2026-09-28). The map shows the selected boundary, Buyer or project pin, clustered Vendor markers, map-layer control, recenter control, and a legend for Verified Vendors, Directory Suppliers, and Favorite Suppliers. The weather widget is removed. The map-layer control chooses the basemap (Map or Satellite) and opens the legend. A draggable **Vendors Near You** sheet and equivalent full list expose the same results.
- **Flow.** Without a location, a separate full-screen location page (outside Map Home and its navigation) offers Use Current Location or Select It Manually; a current location shows its street address in the Location Selector. Opening the page loads the last permitted location and radius, then requests eligible Tier 1 and Tier 2 results. Selecting a marker isolates it: every other marker is hidden until the selection is closed, while the list keeps all results. The selected supplier's summary sheet opens the Vendor Store Profile or the limited Tier 1 details. Radius expansion occurs only after Buyer confirmation. Pull-to-refresh reruns the search without changing saved preferences.
- **Logic.** GPS is optional. If unavailable, the page uses a manually selected location. Ranking and exact-radius filtering occur on the backend. Map and list results share one result identifier so selection remains synchronized. Failed map tiles do not block the list, search, or procurement functions.

**Explore Materials Catalog**

- **Design.** Explore shows the active-location indicator, search field, the MAT-01 dashboard above the category list with **Nearby Verified Vendors**, **Available Products** and **View Materials Analytics**, categories, recently viewed products, Favorite Suppliers, recommended eligible listings, filters, sorting, notifications, and Cart. Categories use the controlled platform taxonomy: Cement and Concrete; Roofing Materials; Formwork and Scaffolding; Wood and Lumber; Landscaping and Exterior; Steel and Reinforcement; Tools and Accessories; Masonry; Insulation and Waterproofing; Aggregates; Hardware and Fasteners; Electrical Materials; Drainage and Septic Materials; Plumbing Materials; Construction Chemicals; Wall and Ceiling Materials; Sanitary Fixtures; Paints and Finishes; Doors, Windows, and Glass; Flooring Materials; HVAC Materials; Fire Protection Materials; Adhesives and Sealants; and Other.
- **Flow.** Selecting a category applies it to active Tier 2 listings inside the chosen radius. Search opens Search Results; a listing opens Product Details; the tune shortcut opens Item-Based ranking preferences. Reset restores current platform defaults.
- **Logic.** Catalog browsing defaults to distance, while text search defaults to SRS Best Deal. Only active and serviceable Tier 2 listings are purchasable. Stale or unavailable listings remain excluded even if a cached card is visible.

**Materials Analytics within Explore**

- **Design.** Show the inherited location/radius, category/search controls, daily-update timestamp, 7/30/90-day and custom-date filters, and a categorized list of comparable material variants. Each row shows material/specification, PHP per canonical unit, daily average, comparison dates and percentage/direction when eligible, current offering-Vendor count and View Details. Never display a blended average across incompatible variants. Dashboard counts use current MAT-02 eligibility and explicitly count Vendor listings, not variants; history has its own as-of timestamp.
- **Flow.** View Materials Analytics opens the list without changing the selected radius. Category/search narrows the analytics rows; changing dates reloads recorded averages and graph periods. A confirmed radius change reloads both current and historical scope. Selecting a material opens Material Price Details; Back restores list filters and scroll. Project-origin navigation explicitly labels the Project site.
- **Logic.** Apply MAT-01–MAT-07 exclusively to public Tier 2 listed prices. Live current counts and daily historical averages may differ in time and must be labeled. Unmapped products show Not Yet Comparable. One-Vendor averages show Limited Local Data; percentage trends require at least two Vendors at each exact endpoint. Missing observations remain gaps. Filters cannot introduce Tier 1 or negotiated/completed-sale prices. TEST fixtures show DEMO — Simulated Marketplace Data.

**Material Price Details within Materials Analytics**

- **Design.** Present canonical material name, description, brand/model and technical specifications, unit, equivalent-variant selector, average as-of date, current seller count, price-change summary and daily line graph with an accessible table. Under each variant show its own average and the current eligible offers with store name, public price/availability, distance and View Product. Material information is a taxonomy summary; Vendor-specific images or claims remain attributed to the selected listing. Historical dates do not turn current offer cards into historical quotations.
- **Flow.** Selecting a comparable variant updates its graph, average and offer list. Selecting a Vendor offer opens the existing Product Details for that listing/variant, where the Buyer may message, select fulfillment or add to Cart. If the offer has become unavailable, show the updated state and return to remaining eligible offers. Historical-only materials retain the graph with No Current Offers and no purchase shortcut.
- **Logic.** Follow MAT-03 normalization, MAT-04 exact-date percentage calculation and MAT-05 Buyer serialization. Averages include applicable materials VAT and exclude delivery/processing/commission/CWT. Planning estimates are advisory materials-only amounts; actual order quantities, price, VAT, delivery, processing and stock are revalidated under FIN-02. Do not change a Project budget or accept an order from a graph value.

Both new page flows inherit the existing loading/error/offline/permission, focus, text scaling, reduced-motion and security requirements. The chart has labeled dates and units, a textual change direction, keyboard/screen-reader-accessible data and no fabricated line across a missing day.

**Search Results**

- **Design.** The page provides editable query text, result count, selected location and radius, sort control, filter chips, active-filter summary, list/grid selection, and accessible result cards. Each card shows product, normalized unit price, public stock status, Vendor, distance, rating eligibility, fulfillment methods, badges, and data-freshness time.
- **Flow.** A query is normalized for aliases and typographical similarity. Filters may include category, brand, variant, compliance status, availability, fulfillment method, Favorite Supplier, price range, and radius. Changing radius or weights requests a new ranked result set; Back restores the prior query and scroll position.
- **Logic.** Cursor pagination prevents duplicate cards. Results are deduplicated by listing and variant: each listing appears as one card showing its best eligible variant under the active sort, with the count of other options; SRS and Best Price come from that variant (approved by the project owner on 2026-09-29). Empty results offer filter removal or confirmed radius expansion. The page never represents Tier 1 directory records as purchasable inventory.

**Product Details**

- **Design.** Product media, display name, brand, manufacturer, origin, description, technical attributes, unit, variants, unit price, public availability, compliance evidence, product rating, Vendor card, distance, route estimate, fulfillment methods, and Add to Cart are arranged in labeled sections. Message Vendor and Favorite are secondary actions.
- **Flow.** The Buyer selects a variant, compatible unit, quantity, and fulfillment preference. Site Delivery requests a preliminary vehicle/trip suggestion; Self-Pickup shows the Vendor location and preliminary readiness information. Message Vendor starts an Item-Based conversation with a locked product reference. Add to Cart records the current listing version without reserving stock.
- **Logic.** Quantity must be positive, compatible with pack rules, and within public ordering limits. Price, compliance, serviceability, and active status are revalidated on Add to Cart and checkout. A PS/ICC badge describes MateryalPH evidence status and is not presented as a new government certification.

**Select Location**

- **Design.** Tabs provide Saved Locations, Search Address, and Drop Pin. Drop Pin is a full-height map under a fixed centre pin; the map owns drag gestures and tabs change by tapping only. Latitude and longitude are never displayed or typed (approved by the project owner on 2026-09-28). The confirmation panel shows the formatted address, PSGC region/province/city-or-municipality where resolved, label, contact, and optional site instructions.
- **Flow.** The Buyer may grant current-location permission, search an address, move the pin, or select a saved location. The page validates serviceability and asks whether the choice applies to browsing only, a project, or an order. Save requires a descriptive label when retained for future use.
- **Logic.** Location permission denial never blocks manual entry. Coordinates are validated against Philippine bounds and geocoded server-side. Sensitive site instructions are shown only to the relevant Vendor after an order or authorized inquiry requires them.

**Shopping Cart**

- **Design.** Cart lines are grouped by Vendor, with variant, unit, quantity editor, price snapshot, fulfillment choice, preliminary delivery estimate, subtotal, availability warning, and remove/save-for-later actions. The parent summary clearly states that checkout creates separate Vendor child orders.
- **Flow.** Quantity changes trigger price and availability revalidation. The Buyer resolves invalid or expired lines before proceeding. Checkout may continue for eligible Vendor groups while leaving blocked groups in the cart, but the app requires the Buyer to confirm the split.
- **Logic.** Cart placement and quantity editing do not reserve stock. Totals are advisory until Vendor confirmation or eligible auto-accept. Retry uses idempotency and cannot create duplicate child orders.

**Checkout**

- **Design.** Checkout is a review sequence for delivery/pickup details, contact, Vendor-group totals, payment method, NRPC where proposed, Terms, and final submission. Each child order shows Materials Subtotal after discounts, included VAT where applicable, Delivery Fee, NRPC included within the order value, Payment Processing Fee, Amount Due Now, Remaining Physical-Payment Balance where applicable, and Total. The breakdown states whether prices include VAT or the Vendor is non-VAT and never adds VAT twice. Vendor commission and CWT are not Buyer checkout charges.
- **Flow.** A normal cart submits Vendor confirmation requests. An accepted quotation enters checkout from its latest version. The Buyer explicitly accepts every revision and NRPC Terms before payment. Online payments open the authorized Xendit action and return to a pending-status page; redirects never independently mark payment successful.
- **Logic.** The backend revalidates quotation version, inventory reservation, address, fulfillment method, payment channel, fee, and expiry. Online payment and an NRPC assurance payment must be completed within the 24-hour Pending Payment window, with exact Asia/Manila time and countdown displayed. Each checkout session lasts 45 minutes; a failed or abandoned session leaves the order Pending Payment and the Buyer can pay again for the same amount until the deadline. An expired checkout attempt keeps the order reservation until the order deadline and offers a safe retry against the same commercial snapshot.

The shared FIN-02 breakdown is authoritative: full Online payment is `M + D + F`; direct COD/In-Store is `M + D`; an NRPC physical-payment order pays `N + F` online and leaves `M + D − N` payable directly to the Vendor. NRPC is counted once; its processor charge is not credited as material principal. A tax/profile change affecting the payable amount requires a fresh Vendor-approved snapshot and Buyer acceptance. Withholding is assessed separately at remittance and cannot change an accepted Buyer total. All demo payment controls state **TEST — no real charge**.

**Projects**

- **Design.** Project cards show name, location, schedule, status, overall budget, committed spend, actual spend, remaining balance, work-package progress, and alerts. Create Project, filters, archive, and procurement-report actions are available according to state.
- **Flow.** Selecting a project opens its overview and Work Packages. Creation collects required project fields, validates budget and dates, and allows optional site details. A project with procurement history may be completed or archived but not physically deleted.
- **Logic.** Totals are calculated from linked work packages and orders rather than client-side estimates. An archived project is read-only except for permitted reports, disputes, invoices, and privacy actions.

**Work Packages**

- **Design.** The project header is followed by phase cards containing budget, materials count, sourcing progress, selected Vendor, quotation status, order status, and missing items. Create, Edit Draft, Activate Scan, View Results, Link Item Order, Complete, and Cancel are state-aware actions.
- **Flow.** The Buyer creates material lines and activates the package. Activation starts Vendor scanning. A Work Package is one record: the Buyer edits it directly until an order exists, and an edit invalidates prior estimates and expires open quotation requests. There is no Buyer-facing version number or version history.
- **Logic.** Material lines require normalized units and positive quantities. One Project-Based Vendor may ultimately be accepted for each Work Package. Missing lines may be linked to separate Item-Based orders without changing that rule.

**Vendor Comparison**

- **Design.** System-compiled Vendor results may be displayed as sortable cards or a comparison table. Each result shows FMS, fulfillment percentage, missing lines, item subtotal, estimated delivery, projected total, budget label, distance, ETA, performance, badges, payment methods, and estimate expiry. Each Vendor card provides Message Vendor and Select Vendor actions; the tune shortcut opens FMS preferences.
- **Flow.** The Buyer may open an inquiry with any Vendor in the result list before selecting one. Each inquiry receives the locked Work Package and Vendor-editable duplicate. Published quotations appear beside the system estimate with version, deadline, change-summary, and current decision actions. When the Buyer selects without a quotation, an optional informational Note may accompany the package request and does not require a response.
- **Logic.** System estimates and Vendor quotations remain separately labeled. Accepting one Vendor quotation or confirming one direct selection atomically assigns the Work Package and expires other active quotations for that package. Message histories remain accessible. An expired system estimate must be refreshed before direct selection.

**Project Quotation Inquiry**

- **Design.** The conversation includes a pinned locked-original tab, Vendor-proposal tab, version selector, change-summary panel, itemized total, fulfillment details, NRPC disclosure, exact deadline, countdown, and Accept, Reject, or Counter-Offer actions. The store and staff identities are displayed together.
- **Flow.** The Vendor edits its duplicate and publishes a version. The Buyer views the plain-language differences from the original, opens line-level detail when needed, and decides only on the latest version. A counter-offer records requested changes and returns the quotation to the Vendor. Acceptance proceeds to atomic inventory validation and checkout.
- **Logic.** Older versions are read-only and cannot be accepted. If inventory is insufficient at acceptance, no payment begins and the Vendor must republish. Project inquiries use the shared Order-from-Chat engine with `PROJECT_BASED` context.

**Orders and Milestone Tracking**

- **Design.** Orders are grouped by Active, Awaiting Action, Completed, Cancelled, and Disputed, with filters for project, Vendor, procurement type, fulfillment, payment, and date. Cards show Order ID, Vendor, amount, current order/payment/refund states, next action, expected date, and any countdown.
- **Flow.** Selecting a card opens Order Details. The page deep-links to payment, revision approval, NRPC acceptance, cancellation, proof, dispute, rating, or invoice tasks. Push or in-app notification selection opens the same authorized order.
- **Logic.** Order, payment, refund, fulfillment, and dispute states are displayed independently. The app never infers payment success from a redirect or hides a pending refund behind a cancelled order label.

**Order Details**

- **Design.** The page contains order summary, immutable line snapshots, Vendor and handler identity, Project/Work Package reference, quotation version, change summary, fulfillment, address, payment breakdown, NRPC amount and reason, payment/refund timeline, evidence, messages, Purchase Order, invoice request, and event history.
- **Flow.** Available actions are calculated from server state. The Buyer may pay, approve a revision, accept NRPC, message the Vendor, request a permitted cancellation, view proof, confirm receipt, report an issue, rate, or request an invoice.
- **Logic.** NRPC is identified as part of—not an addition to—the agreed order value. For COD or In-Store Payment, Amount Paid Online and Remaining Balance are shown separately. Records from older quotation or order versions remain read-only.

Order Details additionally displays the original included VAT/discount allocations, online principal paid, processor fees paid, physical amount recorded, remaining obligation and each refund allocation. It never represents a Vendor-entered cash receipt as Xendit verification. A cash record may be acknowledged or disputed by the Buyer, with the original recorder/time retained. Internal Vendor fee bills and private tax certificates are not exposed to the Buyer.

**Review**

- **Design.** Verified-purchase Vendor and product rating forms are separate. The page shows eligibility, submission deadline, rating criteria, optional comment, media rules, and the privacy-safe public identity that will appear.
- **Flow.** The Buyer rates the Vendor and applicable products, previews the submission, and confirms. A successful Confirm Receipt that returns `COMPLETED` opens Review automatically; rating remains optional and Back returns to Order Details. Each Product Review supports choosing or capturing JPG/PNG photos (up to 10 MB) and MP4/MOV videos (up to 100 MB), with up to three attachments combined. Preview/removal and retry preserve pending attachments; ratings already saved are not submitted again. A submitted review may be corrected within 24 hours. Report Review is available for content concerns.
- **Logic.** Only eligible completed lines may be reviewed once. Reviews remain hidden until both sides submit or the 14-day window ends. An active dispute may delay publication without deleting the draft.

**Cancellation Request**

- **Design.** The page shows the current state, whether cancellation is available, reason selector, explanation, financial-impact preview, NRPC evidence status where applicable, refund estimate, and confirmation. Unavailable cancellation is replaced by Report a Problem or Dispute guidance.
- **Flow.** Before Vendor confirmation, the Buyer may withdraw the request. From `CONFIRMED` through `PROCESSING`, the Buyer submits a valid reason. The system or authorized reviewer finalizes the result. Cancellation is unavailable at `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`, although statutory remedies and dispute reporting remain available.
- **Logic.** A finalized paid cancellation automatically initiates the cancellation refund. Vendor-caused cancellation returns all Buyer-paid order amounts and forfeits NRPC. Eligible Buyer cancellation during `PROCESSING` may retain the accepted, substantiated NRPC. The preview is recalculated server-side before confirmation.

The refund preview uses original paid amounts and earlier refunds. It does not deduct Vendor CWT or platform commission. An approved refund creates a separate timeline for each original online payment and any required Vendor cash reimbursement. A balance never collected is shown as **No longer due**, not **Refunded**. A pending tax correction does not turn into a smaller Buyer entitlement.

**Return or Refund Request**

- **Design.** This structured form collects issue type, affected lines, requested remedy, requested amount where partial, description, evidence, and preferred contact channel. It displays eligibility, submission deadline, privacy warning, and the original masked payment method for a possible refund; it never asks for a different card, e-wallet, or bank destination.
- **Flow.** Submission creates a Case ID and `DISPUTE_OPEN`. The Vendor response, mutual-resolution, Admin review, and appeal stages follow the dispute timeline. If the final conclusion awards a refund, the system initiates the separate dispute-conclusion refund.
- **Logic.** Filing does not immediately create `REFUND_PENDING`. Refund destination remains the original payment source when supported. Duplicate submissions for the same issue are linked or rejected safely.

**Proof of Delivery**

- **Design.** The Buyer sees Vendor-uploaded photo, milestone time, receiver name, optional signature, vehicle/trip reference, and a map/address summary without exposing unnecessary staff or receiver data. Confirm Receipt and Report a Problem are prominent actions.
- **Flow.** After `DELIVERED` or `PICKED_UP`, the Buyer reviews proof and confirms or reports an issue. A reminder precedes two-day automatic confirmation. Reporting an issue pauses automatic completion.
- **Logic.** Media access uses expiring authorization. The Buyer cannot edit Vendor evidence; any Buyer response becomes a separate event. Missing required evidence prevents the Vendor from completing the relevant milestone.

**Messages**

- **Design.** The inbox groups conversations by Vendor and context, with unread count, pinned context, current quotation/order status, and search. The thread header shows store logo and name plus the assigned staff member's avatar, name, and role. Context cards distinguish Product, Work Package, Quotation, and Order.
- **Flow.** The Buyer may send text and permitted attachments, open a product inquiry, start a quotation inquiry, view quotation versions, counter, accept, or follow an order-linked conversation. Staff reassignment is announced in the thread.
- **Logic.** Ordinary messages cannot alter commercial records. Attachments are validated and scanned. Send retries use client-generated identifiers to avoid duplicates. Private staff contact and authentication data are never displayed.

**Favorite Suppliers**

- **Design.** Favorite Vendor cards show current serviceability, distance, categories, rating, badges, last order, and active listing count. Filters support project, phase, category, and availability.
- **Flow.** The Buyer can open a store, message, remove the Favorite, or use Favorites First where offered. Removal asks for confirmation only when it also changes an active personal filter.
- **Logic.** Favorite status is personal and does not change SRS or FMS unless the Buyer explicitly selects the Favorites preference. Vendors outside the radius remain visible as saved but are not shown as eligible.

**Notifications**

- **Design.** Notifications are grouped by Orders, Quotations, Payments and Refunds, Projects, Messages, Disputes, Security, and System. Each entry includes exact time, status, short action, read state, and deep link. Filters and Mark All as Read are available.
- **Flow.** Selecting a notification opens the authorized record. Expiry-sensitive entries show the same server deadline as the related page. Notification preferences control optional channels but cannot disable mandatory security, payment, refund, or legal notices.
- **Logic.** Read state synchronizes across devices. Expired links open the current record state rather than a stale action. **Owner-approved notification display — 2026-10-14:** message notifications identify the public sender and store and show a short message preview; other notifications show the actual event title and summary. Minimize previews, exclude private contacts and attachment details, and respect the phone's lock-screen visibility settings. Recipient/resource authorization, channel preferences and protected tap resolution remain required.

**Disputes**

- **Design.** Case cards show Case ID, order, issue, requested remedy, current stage, responsible party, exact response deadline, refund state, and appeal availability. Case Detail contains the chronology, evidence, messages, decision, and linked refund timeline.
- **Flow.** The Buyer may respond to clarification, accept a proposed resolution, add permitted evidence, or appeal once with new relevant evidence. A refund awarded at conclusion is displayed as a separate linked process.
- **Logic.** Case events are append-only. The Buyer cannot change the original complaint after the Vendor responds but may submit labeled supplemental evidence. Deadline calculations use Asia/Manila time.

**Order-specific fulfillment thread.** From submission until the order closes, My Orders cards and Order Details provide **Fulfillment Messages** for order and pickup/delivery coordination (approved 2026-10-10). This is separate from the normal sales/quotation conversation. Assigned Fulfillment Staff may clarify arrival, route access, alternative drop-off, unloading, delays and evidence; they do not gain access to all Buyer inquiries. Owner and Store Manager retain authorized oversight.

Each message shows the store and actual employee's public name, role and avatar. A handler transfer keeps earlier attribution visible and removes a former employee's future access. Private employee contacts, IDs and business-verification evidence remain hidden. A fulfillment message proposing a new fee or endpoint is only a communication; it cannot revise accepted commercial terms or mark payment successful. An order state transition, payment confirmation or commercial amendment must still use its formal authorized action. An unavailable realtime channel falls back to the existing REST message synchronization without duplicating the thread or losing saved messages.

**Vendor Store Profile**

- **Design.** The storefront displays verified business identity, address/service area, categories, active listings, fulfillment and payment methods, eligible badges, rating summary, compliance indicators, business hours, Favorite, Message, and Report actions.
- **Flow.** The Buyer may browse eligible products, start a general inquiry, save the Vendor, open directions, or report inaccurate information. Purchasing always begins from a Tier 2 listing, accepted quotation, or formal order request.
- **Logic.** Private business documents, payout data, internal stock, and staff contact information remain hidden. Suspended or inactive stores show an appropriate restriction and block new transactions while preserving existing-order access.

**Store Profile data from the new Vendor onboarding.** Use the active store's saved Public Store Name, Logo, Banner, description, approved public contacts, structured store address, Supplier Type/niches, procurement capability, supported fulfillment methods and saved Store Operation schedule. Public Store Name is synchronized across the Vendor's profile and Business Information; it does not replace the separately reviewed legal identity. Present only the allowlisted public legal/business fields. Government ID front/back, full TIN, authority documents, representative private contacts, BIR COR, sworn declarations, provider account identifiers, credentials and internal review remarks are never returned to Buyer browsing APIs.

**Store Hours.** Display Monday–Sunday with opening/closing times and explicit Closed days, using Asia/Manila. Where configured, a date-specific Open/Closed entry overrides only that date. Group days only when their schedules match. An optional Open Now/Closed Today/next-opening label is derived from the saved schedule and server time; it is informational, not proof of staff attendance, immediate response or stock. Never infer holiday closures. If schedule data cannot be loaded, show Hours Unavailable with retry rather than inventing Open/Closed. A cached view shows its freshness and refreshes on resume.

**Store Profile layout (Buyer request, 2026-10-16).** The header carries Back plus icon actions: show the store on the Map (returns to Map Home with that store selected, as if its marker were tapped; a store outside the current Map results shows a notice instead), Message, and search the store's products. It also shows the straight-line distance from the Buyer's current location. The page has two tabs, **Products** (opens first) and **Store Profile**; there is no Shop Front tab (removed at Buyer request, 2026-10-17). Products offers the Best Deal, Top Selling (sort `TOP_SELLING`: quantity on `COMPLETED` orders in each listing's sale unit, the same figure as the card's "sold" count), Top Rated and Price sorts. **Store Profile** adds a Store rating card: the published VCS, or "New Vendor — Building Track Record" below its sample gate (no combined number is invented), the averages of visible verified Service Quality and Delivery/Processing Speed ratings, MQS and VPS when published, and active badges. Tapping the approved public phone number offers Call or Send SMS through the device; nothing is sent by MateryalPH.

Public hours do not alter accepted fulfillment dates, payment windows, quotation expiry or dispute deadlines. A Buyer may continue permitted browsing and messaging outside hours; the existing order rules still determine whether a request is accepted. A Vendor schedule edit cannot rewrite an accepted pickup/delivery commitment.

**Verification, activation and discovery.** Uploading onboarding documents, completing profile media, setting hours or connecting a TEST account does not independently create a verified public store. The backend first applies the Vendor's approval and activation gates. A store can be active with zero eligible listings; it is then excluded from offering-Vendor discovery and the Explore vendor/product counts until it has eligible available listings. A store's Closed-hours indicator is separate from activation and inventory eligibility and does not by itself remove it from Materials Analytics. A later listing, inventory or compliance restriction is reflected when the Buyer opens an old card; do not permit checkout from stale discovery data. Existing-order history and support remain accessible under the order's permissions.

An active store's bulk-capability Yes supports both Item-Based and Project-Based eligibility; No supports Item-Based only. Changing the capability affects future matching, never an already accepted Work Package order. Tier 1 Directory Suppliers retain their attributed provider details and do not inherit Tier 2 onboarding, checkout, staff messaging or analytics inventory.

**Invoice Request**

- **Design.** Orders with invoice records show Vendor, Order ID, invoice date, amount, included VAT/category where applicable, existing invoice files, copy/correction request status, necessary billing details, and secure download actions. Invoice access is not restricted to completed orders when an invoice has already been issued. Optional business TIN details are collected only for the invoice purpose and are not required for ordinary browsing.
- **Flow.** The Buyer supplies needed invoice details before issuance where available, views the Vendor-issued document once uploaded, or requests a copy/correction. Vendor issuance follows its legal timing and does not depend on the Buyer first requesting an invoice. The demo supplies labeled sample documents; production documents originate from the Vendor's registered process.
- **Logic.** MateryalPH generates only the request and records. It does not label its Purchase Order or payment confirmation as the Vendor's tax invoice. Access remains limited to the Buyer, Vendor, and authorized Admin roles.

**Profile and Settings**

- **Design.** Sections cover personal profile, Buyer type, saved locations, security, signed-in devices, notifications, ranking preferences, privacy requests, agreements, help, and account deletion. Sensitive values are masked until recent authentication.
- **Flow.** Profile edits are validated and audited where material. Email change requires reauthentication and verification; password change revokes other sessions. Privacy requests create trackable cases. Account deletion shows retained-record exceptions before confirmation.
- **Logic.** Ranking preferences have separate Item-Based and Project-Based records. Location and notification permissions may be revoked without disabling manual alternatives. Financial, dispute, tax, fraud-prevention, and security records are retained only under the approved schedule or legal hold.

**Buyer two-factor authentication and account deletion (implemented 2026-10-13)**

- **Optional authenticator 2FA.** A Buyer may enroll an authenticator-app TOTP (RFC 6238, 6 digits, 30 seconds) from Account Setting after recent authentication. Setup offers a one-tap link to an installed authenticator, a QR code for another device and a copyable setup key; a current code confirms it, other devices are signed out and 8 single-use recovery codes are shown once. Once on, every Buyer sign-in — password or Google — returns a short-lived challenge instead of tokens and is completed with an authenticator or recovery code (a recovery code signs out other devices and replaces all codes). Turning 2FA off needs recent authentication plus a current authenticator or recovery code. Buyer recent authentication stays password or current-email OTP; enrolling does not make the Buyer a privileged account. Email OTP is still not labeled strong MFA.
- **Account deletion.** The Buyer sees what happens, the retained-record categories and any blockers, types `DELETE`, and confirms with recent authentication. Deletion is refused while an order is not closed, a dispute is active or a refund is `REFUND_PENDING`. Otherwise one transaction sets the account to the final `DELETED` status (distinct from enforcement statuses and never restored by a sanction lift), revokes every session, push device and authenticator, opens an `IN_APP` `DELETION` privacy request for minimization, emails a security notice with the reference, and audits the change. Orders, payments, disputes, reviews and audit records are retained, never deleted. The email address stays reserved until the privacy request minimizes the account.

All pages target WCAG 2.2 Level AA. Controls have accessible names, logical reading and focus order, sufficient contrast, scalable text, and appropriately sized touch targets. Statuses use text and iconography in addition to color. Map actions have list alternatives; charts have summaries or tables; countdowns expose exact times to assistive technologies; validation identifies the field and correction; modal focus is trapped and restored; and motion respects reduced-motion preferences.

---

**Hybrid Procurement Approach**

- **Item-Based Procurement Module**

Item-Based Procurement allows the Buyer to search for a specific material or browse a structured catalog. Only active Tier 2 Vendor inventory within the selected radius can be added to the cart. Catalog browsing defaults to distance; a product search defaults to **Best Deal**, calculated using the Search Relevance Score defined in the System Workflow. The Buyer may instead sort by distance, price, or product rating. A sliders/tune shortcut opens the Buyer's Item-Based ranking preferences and provides **Reset to Default**.

Each result shows the product name, comparable unit price, product rating, units sold, public availability status, Vendor distance, eligible badges, delivery methods, data-freshness timestamp, and price insight when sufficient comparable data exists. Filters include radius, category, variant, brand, availability, fulfillment method, Favorite Supplier, and compliance status.

The Product Details page includes the material description, technical attributes, brand, manufacturer, country of manufacture, unit, variants, product guide where available, Vendor profile, Vendor rating, product rating, public availability, expected fulfillment information, location, route and ETA, product media, and applicable PS/ICC compliance evidence. A compliance badge means that MateryalPH matched or reviewed the submitted evidence; it is not presented as a new government-issued certification.

The Buyer may open a real-time conversation with the Vendor. The selected product is attached as a structured reference. Ordinary chat may clarify stock, specifications, substitution, delivery, or price but does not change a commercial record. The Buyer may also request an Item-Based Order-from-Chat quotation. Only a published, versioned quotation accepted by the Buyer can establish the itemized commercial terms.

The Buyer selects the variant, unit, and quantity and chooses Self-Pickup or Site Delivery where supported. For Site Delivery, the system recommends a suitable Vendor vehicle using product weight, cargo dimensions, distance, vehicle capacity, service coverage, and access restrictions. The initial fee is an estimate until the Vendor confirms the vehicle and any required trips.

The cart may contain items from multiple Vendors. Cart placement does not reserve stock. At submission, the system creates one parent checkout and one child order request per Vendor. Each line receives a price snapshot so later listing-price changes do not modify the pending request.

The canonical Item-Based sequence is:

`Buyer submits order request → Vendor manually or automatically accepts, revises, or rejects → Buyer approves any revision and NRPC, when applicable → Buyer selects payment → Payment is verified or physical-payment method is recorded → Vendor processes → Delivery or pickup → Buyer confirmation → Completed`

An eligible order without NRPC may use Vendor-configured auto-accept. The backend atomically verifies every SKU allotment, available stock, unit or peso limit, Vendor state, fulfillment method, and complete child order. If all checks succeed, the order is accepted and inventory is hard-reserved; otherwise the whole Vendor child order goes to manual review. Project-Based orders and any order with NRPC always require manual Vendor review.

The Vendor has 24 hours to respond. A confirmed quantity is reserved. A rejection releases no stock and does not receive an automatic major penalty; repeated inaccurate availability affects the applicable operational metric. If only part of an order is available, the Vendor proposes revised quantities and totals. The Buyer must explicitly accept before payment. If the Buyer rejects or does not accept before expiry, the reservation is released.

For Site Delivery, the Vendor confirms the suggested vehicle, number of trips, final delivery fee, access feasibility, and expected fulfillment date before payment. For Self-Pickup, the Vendor confirms the expected ready-for-pickup date.

At checkout, available payment methods are determined per child order:

- **Online Payment:** available for either fulfillment method and processed through the applicable Vendor's Xendit sub-account.
- **Cash on Delivery:** available only for Site Delivery when enabled by the Vendor.
- **In-Store Payment:** available only for Self-Pickup when enabled by the Vendor.

Online checkout displays Materials Subtotal, Delivery Fee, any NRPC designated within the order value, Payment Processing Fee, and Total. The Buyer pays the disclosed processing fee. It is not labeled “Xendit deduction.” The payment is not treated as successful until the backend receives a verified Xendit event. MateryalPH does not operate a wallet or claim to hold the payment in escrow. An auto-accepted online order and any NRPC assurance payment are cancelled automatically after 24 hours without a verified payment; the exact expiry and countdown remain visible.

The system generates a Purchase Order and itemized order record only after Vendor confirmation and Buyer acceptance of the final amount. MateryalPH may generate a payment confirmation, but the Vendor remains responsible for the BIR-compliant invoice.

- **Project-Based Procurement Module**

Project-Based Procurement allows the Buyer to plan materials under construction projects and work packages. It uses active Tier 2 Vendor listings to compile time-limited estimates. From the compiled result list, the Buyer may independently message any displayed Vendor and request a versioned quotation through the shared Order-from-Chat engine. This is not a broadcast RFQ queue: Vendors receive an inquiry only when the Buyer opens their conversation. One Work Package may ultimately be assigned to only one Vendor. Any missing material is sourced through Item-Based Procurement and linked to the same Work Package.

## 1. Project Setup

The Buyer creates a Procurement Project and provides:

- **Project name** — the Buyer's project identifier.
- **Project-site location** — selected from saved locations, manual address, or map pin and used for discovery and distance.
- **Project timeline** — planned start and end dates.
- **Overall project budget** — the financial planning ceiling across work packages.

A new project is `ACTIVE`. The Buyer may update or delete it while no work package has a selected or confirmed Vendor. Once procurement records exist, the project may be completed or archived but not physically deleted. Project statuses are `ACTIVE`, `COMPLETED`, and `ARCHIVED`.

## 2. Work Package Management

A work package represents a phase or trade scope and contains:

- Phase name and description.
- Allocated phase budget.
- Required material lines with name, technical specification, optional preferred brand, normalized unit, and quantity.
- Site Delivery or Self-Pickup preference.
- Online Payment, COD, or In-Store Payment preference, subject to Vendor support.
- Required site contact and essential accessibility information for Site Delivery, including heavy-vehicle restriction and entrance instructions where applicable.

### Work Package Lifecycle

**Deleting a Work Package (2026-10-16).** The Buyer may delete any Work Package in an Active Project until an order, a tagged purchase for a missing line or a selected Vendor is tied to it; from then on the delete action is not offered and the server returns `WORK_PACKAGE_HAS_ORDER`. A Draft with no locked history is removed. Any other package is cancelled and hidden from the Buyer instead of removed: active quotation requests expire, current estimates are invalidated, its budget returns to the unallocated Project budget, and saved originals, version-deletion history and quotations stay on record. A Project that still holds such a retained package cannot be physically deleted; it can be archived.

| **Status** | **Description** |
| --- | --- |
| `DRAFT` | Editable; Vendor scanning has not started |
| `ACTIVE` | Original materials and terms are locked; system estimates and requested Vendor quotations may be compared |
| `QUOTATION_INQUIRY` | At least one selected Vendor is preparing or has published a quotation; the locked original remains unchanged |
| `VENDOR_SELECTED` | Buyer selected one Vendor; confirmation is pending |
| `AWAITING_PAYMENT` | Vendor confirmed availability, fulfillment date, and final delivery details |
| `IN_PROGRESS` | Payment was verified or physical-payment method recorded; order is being fulfilled |
| `COMPLETED` | Linked order is completed and missing-item records are fulfilled or explicitly waived by the Buyer |
| `CANCELLED` | Work package was closed according to the cancellation rules |

A Work Package can be edited, cancelled, reactivated or deleted in place until an order, tagged purchase or selected Vendor is tied to it. After that, a correction requires cancelling the order first so the prior evidence remains auditable.

**Owner decision — 2026-10-16: no Work Package versioning for the Buyer.** This replaces the 2026-10-15 version-history actions. Edit changes the existing package directly (same package, no copy, no new list entry); a Draft is overwritten, while an Active, quoted or Cancelled package keeps its earlier saved contents only as an internal audit record, because estimates, Vendor quotations and the database's immutability protection refer to the exact content they were based on. Editing a compared or quoted package returns it to Active, invalidates its estimates and expires open quotation requests; a Cancelled package stays Cancelled. The Work Package screen offers Edit and Delete (and Reactivate for a Cancelled package); it has no separate Cancel action, so a package never becomes uneditable by the Buyer's own choice. Reactivate returns a Cancelled package to Active in place after re-checking the Project budget. Delete follows the rule above. Edit, Reactivate and Delete are refused with WORK_PACKAGE_HAS_ORDER once an order, tagged purchase or selected Vendor exists. Completed and archived Projects remain read-only. Ownership, package lock versions, idempotency, audit and outbox rules apply on the server.

## 3. Automated Vendor Scanning and Estimate Generation

Activation scans active Tier 2 inventory within the fixed 50-km Project-Based radius of the locked Project site (owner decision 2026-10-17; no other radius exists for a Work Package). The system compares normalized material specifications, quantities, availability, delivery coverage, project-site access, and Vendor capability. It creates a system-compiled estimate using current listing-price snapshots and an estimated delivery fee.

The system aims for a complete one-Vendor package. Incomplete matches may be displayed with exact missing lines and a fulfillment percentage. Missing items are never silently substituted and must be acquired through linked Item-Based orders.

**Fulfillment and missing items (owner request 2026-10-17).** One server-side result decides how much of the Work Package a quotation covers; the Vendor card, the quotation's Order summary and its Missing items list all read it. Per Work Package line: the quantity this Vendor supplies, the quantity covered by separate purchases tagged to the line (cart or open order) **whose product satisfies the line's brand and every stated specification**, any quantity bought as a similar product (listed and priced but not closing the requirement), and the quantity still to source. A line is *fulfilled* when nothing remains, *partial* when some is covered, and *unfulfilled* otherwise; a Vendor holding 6 of 10 is partial with 4 to source, never wholly missing. The card shows "fulfilled/total" with the partial count, the quotation shows the same figure, and totals add the separate purchases to the Vendor's. Complete-package-first is unchanged: ranking, the Complete match filter and the package-deal wording depend only on what the Vendor supplies itself, and a package is never split across Vendors automatically. Fulfillment is derived on every read, so adding, removing or changing a separate purchase updates it with no stored status to drift. The FMS Material Match component is the average, over the Work Package lines, of the share of each line the Vendor itself supplies (quantities in different units are never added together).

For each line the Vendor cannot fully supply, the system lists Item-Based offers within 50 km for the same material and unit, sized to the quantity still to source. They rank by: stated specification and brand match, whether the store covers the whole quantity, whether it can serve the package's fulfillment method (Site Delivery eligibility, pick-up, mixer-only concrete), total price for the quantity, then distance. The Buyer may Add an offer (a store holding only part can be added for what it can confirm; the rest stays open) or open it first. Adding creates a tagged cart line only — it never confirms an order or starts payment — and the same product is never stacked twice, never exceeds the line's quantity and never joins the Project order. When nothing suits, the page names the line, the quantity and 50 km, and says why (out of stock, cannot serve this delivery or pick-up). A failed request is shown as a connection or server problem with a retry, never as "no matching products".

### Vendor Discovery Fallback Logic

**Owner decision — 2026-10-17: Project-Based search uses 50 km only.** The 5, 10, 20, 30 and 40 km options are removed from Work Package vendor selection. The radius is not a Buyer choice, is not stored per Work Package, and is applied by the server to the scan, the alternatives for missing items and the purchases tagged to them; a client-sent value cannot narrow or widen it (other values are refused with a validation error). A package or estimate saved earlier with a smaller radius is treated as 50 km and rescanned when its Find vendors screen opens. Item-Based discovery keeps its own radius options.

If fewer than three eligible Tier 2 Vendors are found, the application says so for the 50-km radius and does not widen it. Favorite Suppliers within 50 km may be highlighted. Tier 1 Suppliers may be shown only as off-platform contact references; they cannot receive the work package through MateryalPH.

### Estimate Validity

Each system-compiled estimate remains valid for 48 hours. Expiration invalidates its price and availability snapshot. The Buyer must refresh the scan before direct selection. A system estimate is never rewritten by chat or a Vendor quotation and remains labeled as a system-compiled baseline.

## 4. Vendor Comparison and Selection

The comparison shows:

- Fulfillment Match Score.
- Fulfillment percentage and missing lines.
- Item subtotal, estimated delivery fee, and projected total.
- Vendor-confirmed or preliminary lead-time information.
- Distance and ETA.
- Payment and fulfillment methods.
- Vendor badges and performance indicators.
- **Under Budget**, **Within Budget**, or **Over Budget** label.

The tune shortcut opens Project-Based ranking preferences. The Buyer may reset weights to platform defaults. Personalized weighting is clearly indicated.

The Buyer may message each Vendor in the compiled result list. The system auto-attaches two Work Package records to each inquiry: the Buyer's locked, read-only original and a Vendor-editable duplicate. The Vendor uses the duplicate to propose product matches, substitutions, quantity or specification changes, unit prices, delivery terms, payment method, expected fulfillment date, and NRPC. Each published version shows an exact expiry and a plain change summary comparing every modified field with the original.

The Buyer may accept the current version, reject it, or send a counter-offer. The default Buyer-response deadline is 24 hours and the Vendor may select 1–72 hours. Editing a published quotation creates a new version, invalidates the prior version, resets the displayed deadline, and requires a new Buyer review. Rejection, counter-offer, withdrawal, or expiry releases the quotation's soft holds. Acceptance performs an atomic stock check before creating hard reservations and proceeding to checkout.

If the Buyer selects a Vendor directly from the system estimate instead, the Buyer may leave an optional **Note**. The Note is informational, becomes part of the package request, and does not require Vendor action. Direct selection creates a package order request; it is not a completed award until the Vendor manually confirms availability, fulfillment date, vehicle or trip requirement, final total, and any NRPC.

Accepting one Vendor quotation or completing one direct Vendor selection assigns the Work Package to that Vendor and expires other active quotations for the package. Their conversation histories remain available. The selected Vendor is the only Project-Based Vendor for that Work Package.

## 5. Checkout and Payment Processing

### Delivery Fee Calculation

**Destination and access information shared by both procurement modes.** During Site Delivery, ask whether the Buyer knows of a Heavy-Vehicle Restriction. A Yes answer requires an alternative drop-off address/pin and essential access/unloading instructions. Retain the intended project/delivery address separately, show both on review, and explicitly identify the alternative as the delivery endpoint used for route distance and fee calculation. A No answer uses the intended delivery location but does not guarantee unrestricted access. A saved Project site is never overwritten with the alternate drop-off. If an alternate lies outside Vendor coverage or a route cannot be confirmed, show a fulfillment-review blocker instead of a fictitious distance or zero delivery fee.

**Ready-Mixed Concrete (approved by the project owner on 2026-10-16).** For ready-mixed concrete the Buyer chooses the Required PSI (each option is one strength class with its own price per m³) and enters the Order Volume (m³), or requests a free site inspection when the volume is unknown: the store visits a saved site on a preferred date and then quotes the measured volume in the store conversation. Only Site Delivery is offered. The delivery estimate shows mixer trucks, trips, each trip's load and any mobilization fee the Vendor charges per truck or per trip. The inspection is free and orders nothing until the Buyer accepts a quotation.

**Vehicle and trip recommendation.** Use the fulfilling Vendor's currently configured eligible vehicles. Conventional materials use actual weight, cargo dimensions and capacity checks. Ready-mixed concrete uses required m³ and mixer capacity, with payload/access checks; bagged cement remains conventional cargo. Mixed loads may require separate compatible groups. The suggestion is advisory and must identify missing physical data or the need for manual arrangement. The Vendor confirms vehicles, counts, trips, endpoint, expected fulfillment date and final fee before Buyer acceptance/payment. Display material fee changes through the existing quotation/revision summary, including any alternate drop-off and additional trip. Do not silently accept a new location or price for the Buyer.

The accepted order preserves its delivery and financial snapshot. Later vehicle deletion, capacity/rate changes, profile edits or schedule changes cannot change that record. A further commercial revision follows the existing approval rules. There is no automatic dispatch or live GPS tracking.

For Site Delivery, the system recommends the most suitable configured vehicle. If the load exceeds one vehicle or trip, the Vendor confirms the number of vehicles or trips before the final delivery fee is presented. The final fee uses the Vendor's base fee, per-kilometer rate, route distance, confirmed trips, capacity, and documented access restrictions.

### Payment Processing

After Vendor confirmation, the Buyer reviews the final itemized amount and selects an available method. Online payment is routed for the Vendor's Xendit sub-account. COD is restricted to Site Delivery and In-Store Payment to Self-Pickup. Physical methods appear only when enabled by the selected Vendor.

The online-payment breakdown separately displays the Payment Processing Fee. Supported channels are taken from the actual Xendit configuration. A channel without an approved refund route is not enabled unless the workflow clearly discloses and records the Vendor-managed refund method.

The Buyer accepts the current Terms version, cancellation and refund conditions, fulfillment commitment, processing-fee treatment, Work Package scope, latest quotation version where applicable, and any NRPC Terms before payment. Acceptance is versioned and timestamped. For COD or In-Store Payment with NRPC, the Buyer pays the accepted NRPC online within the 24-hour Pending Payment window; that amount is credited against the later physical-payment balance.

Project-Based and Item-Based checkout use the same FIN-02 financial snapshot. Comparison totals and budget checks include Buyer-payable materials VAT, delivery and the estimated or confirmed Buyer processing fee, with its estimate status visible. They never add the Vendor-paid 2% commission or merchant withholding. A processor fee unavailable until channel selection is identified as pending, and the full payable total is presented before acceptance. Counter-offers cannot request an unsupported tax exemption or override validated tax fields.

## 6. Purchase Order Generation and Vendor Confirmation

**Phase 8 decisions — approved by the project owner on 2026-09-29.** Respond to a Vendor revision or NRPC proposal within 24 hours of the Vendor revision; expiry sets `EXPIRED` and releases reserved stock. Rejecting either sets `CANCELLED` and releases it. The original online payment deadline is **superseded by the 2026-10-02 decision below**, including manual confirmation and auto-accept. Countdown labels also show the exact Asia/Manila date and time.

For this release, only Online is offered at submission; COD/In-Store and payment-channel processing fees are deferred to Phase 11. A processing fee is pending until the channel is chosen. Site Delivery always requires Buyer approval of the Vendor-confirmed drop-off, vehicles, trips and fee. A revision can only reduce quantities or add an order-level Vendor discount, never raise prices. Auto-accepted Self-Pickup uses the Owner/Manager's optional pickup lead-time setting; an unset value routes the entire order to manual review.

**Pending Payment window — approved by the project owner on 2026-10-02 (supersedes the original order payment deadline).** After the Vendor confirms an online order, the order shows **Pending Payment** with a 24-hour deadline, displayed as "Pay before" the exact Asia/Manila date and time with a countdown. While it is Pending Payment the Order Details and Orders list offer **Pay now** (or **Re-process payment** after a failed or abandoned attempt); it reuses the same order and amount, only one checkout can be open at a time, and a verified payment is recorded once. A failed, cancelled or abandoned checkout never cancels the order; each checkout session lasts at most 45 minutes and never past the deadline. The server clock and `payment_expires_at` are the only source of truth: at the deadline the order is closed automatically with reason `PAYMENT_WINDOW_EXPIRED` (state `EXPIRED`, shown to the Buyer as cancelled because payment expired), the reserved stock and any quote hold are released, and the Vendor is notified. The Buyer is reminded 12 hours and 1 hour before the deadline. A payment verified by the provider before the cancellation job takes the order lock confirms the order; one that arrives afterwards is compensated, never applied to the closed order. Orders already waiting keep the deadline they were given.

**Phase 11 decisions — approved by the project owner on 2026-10-02.** Checkout now offers Online plus any physical method the Vendor Owner enabled (COD for Site Delivery, In-Store Payment for Self-Pickup). After acceptance the Buyer chooses Cards, GCash, Maya, GrabPay or ShopeePay; each shows its DEMO-rate Payment Processing Fee and total before payment. Returning from the hosted page shows **Pending** until the provider-verified payment is recorded; the app never confirms a payment from the return link. Physical-payment records made by the Vendor appear on Order Details and the Buyer may confirm each one once.

The system creates the Purchase Order after the Vendor confirms and the Buyer accepts the final package. It contains:

- Material lines, specifications, quantities, units, and price snapshots.
- Missing items identified for separate sourcing.
- Confirmed fulfillment date.
- Confirmed delivery vehicle or trip count and delivery fee, where applicable.
- Total amount and Payment Processing Fee, where applicable.
- NRPC amount, reason, affected lines, accepted Terms version, and assurance-payment credit, where applicable.
- Fulfillment and payment methods.
- Project and work-package references.
- Source system-estimate or accepted quotation version and its change summary.
- Buyer, Vendor, and acceptance timestamps.

If the Vendor rejects or does not respond within 24 hours, the request expires, reservations are released, and the Buyer may refresh the three highest eligible alternatives by FMS. A single pre-confirmation rejection receives no fixed point deduction. Repeated non-response or inaccurate stock contributes only to the defined CRR or NFR rules.

## 7. Order Fulfillment and Milestone Tracking

The Vendor supplies an expected fulfillment date appropriate to the material and order. The former fixed “three days plus two days” rule is removed. A missed date creates a late milestone and notification but does not automatically cancel a paid order without a safe refund or dispute path.

For Site Delivery, fulfillment proof requires a delivery photo, timestamp, receiver name, and optional signature. For Self-Pickup, it requires handover confirmation, timestamp, and Buyer or authorized-receiver confirmation. Real-time GPS tracking is outside the capstone scope.

The Buyer receives in-app and push milestones and important email notices. No routine milestone SMS is sent. After `DELIVERED` or `PICKED_UP`, the Buyer has two calendar days to confirm receipt or report an issue. Reminders are sent before automatic confirmation. An open dispute pauses automatic confirmation.

For a Self-Pickup no-show, reminders are sent during the confirmed pickup window. After 48 hours from `READY_FOR_PICKUP`, the Vendor may request cancellation or rescheduling. Repeated confirmed no-shows are referred for Admin review and never cause automatic suspension solely because a fixed count was reached.

**Phase 12 decisions — approved by the project owner on 2026-10-02.** Order Details shows a milestone stepper with proof attached to the Delivered or Picked up step; progress comes only from Vendor-recorded milestones, never live GPS. The two-calendar-day receipt window is 48 hours from `DELIVERED` or `PICKED_UP`, with reminders 24 hours and 2 hours before automatic confirmation; Report a Problem pauses it and the remaining time resumes when the Buyer resolves the report. The Buyer withdraws a request before Vendor confirmation, cancels with a reason at `CONFIRMED` (final immediately, full refund including the Payment Processing Fee), and sends a reasoned cancellation request at `PROCESSING`, which the Vendor must finalize within 24 hours (it may keep only an accepted NRPC with preparation evidence) or it is finalized with a full refund; the Buyer may withdraw that request. At `READY_FOR_PICKUP` and `OUT_FOR_DELIVERY` cancellation is disabled with the reason in text while remedies stay available. A refund reads **Refund initiated** until the provider verifies it and **Refund processed** only after; cash collected physically is returned as a Vendor reimbursement that the Buyer may confirm. Fulfillment Messages become read-only, with history kept, once the order is completed or cancelled. See the System Workflow owner decision of the same date.

Material traceability fields are required only when applicable to the category, certification, batch-controlled product, or Vendor's invoice obligations. They are not mandatory for every material.

## 8. Budget Monitoring Dashboard

### Project-Level View

| **Metric** | **Description** |
| --- | --- |
| Total Approved Budget | Buyer-defined project ceiling |
| Allocated to Work Packages | Sum of active work-package budgets |
| Unallocated Reserve | Project budget less allocations |
| Committed Spend | Pending Spend + Actual Spend + Cancelled-order Paid Amount Awaiting Refund; a summary, not another deduction |
| Pending Spend | Confirmed orders not yet completed |
| Actual Spend | Completed-order Buyer cost net of successful refunds, plus legally retained cancellation costs |
| Remaining Balance | Budget less Committed Spend; never subtract Actual Spend again |
| Budget Utilization | Percentage of budget committed or spent |

### Work Package-Level View

The work-package view adds planned versus current cost, confirmed missing-item cost, linked Item-Based orders, pending Vendor-confirmation count, refund adjustments, and override history.

Budget totals follow FIN-11. Use disjoint buckets: Pending Spend for confirmed incomplete orders; Actual Spend for completed orders net of successful refunds plus legally retained cancellation costs; and Cancelled-order Paid Amount Awaiting Refund for paid principal/fees awaiting recovery. `Committed Spend = Pending Spend + Actual Spend + Cancelled-order Paid Amount Awaiting Refund`; `Remaining Balance = Budget − Committed Spend`. On cancellation release only the unpaid obligation, move retained costs into Actual Spend and keep refundable collected amounts encumbered until successful refund or evidenced cash reimbursement. Never count a child order or NRPC principal twice. Withholding, Vendor commission and Vendor service-bill payments never change Buyer budget amounts.

### Budget Alert System

At 90% utilization, the system sends an early warning. When a new order would exceed 100%, checkout pauses and requires an explicit **Budget Override** with a written reason. The Buyer may continue after acknowledgment; the resulting deficit, user, amount, reason, and timestamp are retained for audit. Budget warnings do not alter or cancel an order automatically.

## 9. Post-Fulfillment

After completion, the Buyer may rate the Vendor and purchased products for 14 calendar days. Ratings remain hidden until both parties submit or the window expires and may be corrected within 24 hours of submission. The Buyer may add the Vendor as a **Favorite Supplier**. Trusted Supplier remains a system-awarded badge.

A return or dispute may be filed within seven calendar days after completion for an eligible wrong, defective, incomplete, misleading, late, missing, payment, or fulfillment issue. Evidence is attached to the case. A rating connected to an active case may be withheld until resolution.

The Buyer may view an already issued Vendor invoice or request a copy/correction through the order record. Issuance is the Vendor's duty at the legally required time and does not wait for completion. The three-business-day response target is for the requested document service and never extends that legal duty. Purchase Orders and payment confirmations are not tax invoices. TEST files are labeled samples; FIN-09 governs invoice provenance, reconciliation and electronic-invoicing coverage.

When all work packages are resolved, the Buyer may mark the project Completed and export a Procurement Summary Report containing budgets, Purchase Orders, Vendor records, fulfillment states, invoice references, refunds, and override history.

## 10. Relationship to the Item-Based Procurement Module

- Missing Project-Based lines may be sourced through Item-Based orders and linked back to the originating work package.
- Both modules use the same versioned Order-from-Chat engine, confirmation-before-payment rule, payment methods, inventory reservations, delivery calculation, NRPC controls, Purchase Order model, milestone states, cancellation refunds, dispute-conclusion refunds, and ratings.
- Project-Based selection remains one Vendor per work package; linked Item-Based purchases do not become split Project-Based awards.
- Ratings from both modules contribute to the same eligible Vendor and product score calculations.

---

- **Order Fulfillment, Cancellation, Return, and Tracking**

The shared milestone sequence is:

`Awaiting Vendor Confirmation → Awaiting Buyer Approval or NRPC Acceptance, when applicable → Awaiting Payment → Confirmed → Processing → Ready for Pickup or Out for Delivery → Delivered or Picked Up → Completed`

The system controls request, payment, and verified-payment transitions. Authorized Vendor users control preparation and fulfillment milestones. Every change records actor, role, previous state, new state, timestamp, and evidence reference.

The Buyer may withdraw an order before Vendor confirmation. From `CONFIRMED` through `PROCESSING`, the Buyer may submit a cancellation request with a valid reason. The request records `CANCELLATION_REQUESTED` until the applicable automatic rule, Vendor response, or Admin review produces a final decision. Cancellation is not permitted once the order reaches `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`. Report a Problem, dispute, return, warranty, and non-waivable statutory remedies remain available.

MateryalPH charges no standard cancellation fee. NRPC is a Vendor-determined portion of the existing order value for actual irreversible preparation and has no platform-wide numeric cap. The Vendor must enter the amount, reason, affected lines, and applicable preparation description before Buyer payment or preparation. It is disabled by default, requires manual review, and the Buyer must explicitly accept the versioned NRPC Terms. The Buyer may flag a disproportionate amount for Admin review without automatically blocking an accepted order.

For online payment, NRPC is tagged within the paid total. For COD or In-Store Payment, NRPC is paid online within the 24-hour Pending Payment window and credited against the physical-payment balance. When an eligible Buyer cancellation becomes final during `PROCESSING`, the accepted NRPC may be retained only when the Vendor substantiates the preparation. Vendor cancellation forfeits NRPC and results in a full refund of Buyer-paid order amounts. NRPC cannot reduce a remedy for defective, incorrect, unsafe, misrepresented, or otherwise nonconforming goods or Vendor fault.

Refunds follow two independent paths. A finalized cancellation of an already-paid order automatically initiates an idempotent **Cancellation Refund**. A dispute remains `DISPUTE_OPEN`; only a concluded decision awarding money initiates a **Dispute-Conclusion Refund**. For their online portions, both return funds to the original payment method where supported, record `REFUND_PENDING`, and wait for verified provider evidence before recording `PARTIALLY_REFUNDED`, `REFUNDED`, or `REFUND_FAILED`. Any physical portion follows the separate Vendor reimbursement process in FIN-07 and does not wait for a Xendit webhook. A failed or expired payment for which no funds were captured requires no refund. If reconciliation proves capture after a failed application flow, the system creates a compensating refund.

When the Buyer prevails because of Vendor fault, the intended remedy makes the Buyer whole, including the accepted NRPC and disclosed processing fee, subject to the technically supported route. For a Buyer-requested cancellation without Vendor fault, a nonreturnable payment-processing fee may be excluded only if clearly disclosed and legally permitted. The Buyer sees the masked original payment method, refund amount, reason, reference, state, and channel-dependent arrival information. The interface never asks the Buyer to redirect a Xendit refund to another destination. Admins never manually hold or disburse funds.

Under FIN-07, a cash reimbursement has its own Vendor action/evidence and Buyer confirmation, while the original online NRPC payment uses the supported Refund API. No refund is claimed for an unpaid cash balance. The demo clearly labels simulated reimbursement; a real or test provider failure remains visible with support/escalation and no false completion. Vendor commission and tax adjustments occur separately and are not charged to the Buyer.

---

**Price Monitoring Implementation in the System**

The **Price Trend Insight** is the Materials Analytics feature specified by MAT-01–MAT-07 in the System Workflow. Its daily history uses ordinary, comparable, VAT-inclusive public Tier 2 listing prices with equal Vendor weighting. Completed-sale and negotiated quotation prices remain separate operational records and do not contribute to this public average. Buyer location/radius, variant/unit, endpoint dates, sample counts, dataset and last successful capture are always visible. A chart is a planning estimate, not an official market price or accepted quotation. Historical records remain reproducible and cannot rewrite Purchase Orders.


---

**Construction Procurement Budget Monitoring System**

The Budget Monitoring Module combines Project-Based and linked Item-Based procurement. It displays Approved Budget, Committed Spend, Pending Spend, Actual Spend, Refund Adjustments, and Remaining Balance per project and work package. Available balance accounts for confirmed but incomplete orders so that pending procurement is not ignored.

1. **Multi-Project Overview Dashboard:** The individual Buyer sees all projects owned by the account, including total budget, committed and actual spend, remaining balance, and project status. Buyer Team Accounts are not implied.
2. **Budget Report Export:** The Buyer may export PDF or CSV reports containing work-package budgets, Vendor names, order amounts, Purchase Order references, payment and delivery states, refunds, remaining balance, and Budget Override records.

---

**Supplier Preference and Favorites Feature**

The Buyer may mark a Tier 2 Vendor as a **Favorite Supplier** from Product Details, Vendor Store Profile, Messages, or Post-Fulfillment. Favorites may be organized by project or phase and display the Buyer's own transaction history, prior fulfillment experience, and current serviceability.

Favorites receive a visible indicator, dedicated filter, and optional **Favorites First** sort. They do not silently override SRS or FMS when Best Deal ranking is selected. A Favorite outside the current radius or without active matching inventory is not promoted as eligible. Removing a Favorite does not delete transaction or audit records.

---

**Dispute Workflow for Buyers**

**Phase 13 dispute decisions — approved by the project owner on 2026-10-04.** (1) **Order state.** Filing moves the order to DISPUTED only while it awaits receipt (Delivered or Picked Up), which pauses automatic receipt confirmation; a case filed before handover leaves fulfillment running, and a completed order stays COMPLETED. At case end a DISPUTED order returns to COMPLETED (commission is earned then, and any awarded refund opens the fee-credit proposal); a Full Refund decided before handover cancels the order. (2) **Refund timing.** A decision marked immediately enforceable executes at once; otherwise its remedy, including the one Dispute-Conclusion Refund linked to the Case ID and decision version, executes only when the five-business-day appeal window lapses unappealed. An appeal decision is final and executes immediately. (3) **One appeal per case**, on new evidence or a material process error, decided by a different reviewer than the original decider. (4) **Sanctions.** Warnings and confirmed metric events take effect when the decision executes; Temporary Restriction, Suspension and Permanent Ban are recorded with the decision and referred to User Management Staff, who apply them under the Phase 16 enforcement workflow.

The Buyer selects an eligible order and completes the structured Refund/Dispute Request Form. The Buyer chooses an issue type, identifies affected lines, describes the requested remedy, enters a requested amount when partial, and attaches available photos, video, delivery evidence, chat reference, invoice, or other supporting material. The form displays the original masked payment method for information but never collects a different refund destination. Submission creates a Case ID and `DISPUTE_OPEN`, not a refund, and notifies the Vendor.

- Vendor response: 48 calendar hours.
- Mutual-resolution period: 72 calendar hours after a response, or immediate escalation after no response.
- Admin clarification request: 24 calendar hours for each requested party.
- Appeal: one appeal within five business days and only with new relevant evidence.

Possible outcomes include Dismissed, Replacement, Full Refund, Partial Refund, Warning, Score Adjustment through the applicable metric, Temporary Restriction, Suspension, or Permanent Ban. A concluded Full Refund or Partial Refund decision initiates the separate Dispute-Conclusion Refund and links it to the Case ID. All deadlines use Asia/Manila time and are shown in the interface. The Buyer can view the case state, evidence history, messages, decision reason, refund state, expected arrival information, and appeal state.

---

The financial source register, calculations, worked examples and acceptance cases are in FIN-01–FIN-12 of [the System Workflow](MateryalPH_Final_System_Workflow.md). Buyer screens present those results through the existing page structure and accessible Design, Flow and Logic patterns. The capstone does not submit tax returns, issue official Vendor invoices or claim production compliance.

### Future Enhancements

Buyer organization team accounts, live GPS delivery tracking, machine-learning recommendations, vouchers, and procurement beyond the 50-km platform radius are outside the current capstone scope.


### Owner decision — 2026-10-02: Store messaging and product cards (MSG-02)

This decision supersedes the product-required/locked-product entry wording in Phase 9. A Buyer may message an active Tier 2 Vendor directly from Store Profile without a product. General and product inquiries reuse one SALES / ITEM_BASED conversation per Buyer and Vendor store. The owner confirmed that Work Package quotation conversations and order-specific FULFILLMENT threads remain separate with their existing authority and commercial records.

Product Details opens that store conversation and prepares an unsent, removable product draft; opening it never sends a message. Product Details prepares the viewed product even when it is already the latest attached product (owner decision 2026-10-10); nothing is sent until the Buyer taps Send. Preserve unsent Buyer text/product drafts locally in secure storage, and only restore after current conversation authorization succeeds. The composer offers a searchable, paginated picker restricted to that store's currently eligible active products. Text, product-only and text-with-product messages are supported. Product references use the existing listing variant UUID (`product_id`); snapshot listing ID, name, integer-centavo price and safe public image URL at send time. Preserve the snapshot after catalog changes and display No longer available when the offer is unavailable. Product cards do not modify quotations, inventory, or accepted terms.

Client-generated message IDs bind immutable sender, text and product content. Optimistic messages show Sending, failure and Retry; retry reuses the same identifier. Inbox rows show the public other-party identity/avatar, latest message preview (Sent a product: [name] for product messages), Manila timestamp and unread count, ordered by activity. Opening the thread marks received messages read. Loading, No messages yet and real failures with functional Retry are separate states.

Use existing Reverb viewer-authorized channels and account inbox invalidations. Reconnect reauthorizes and fetches missed history; REST polling is a recovery fallback. Typing is an ephemeral, debounced event with a server timestamp, no database/outbox persistence, and approximately three-second expiry. Read/send/file/channel checks continue to revalidate account, store, role and handler authority; preserve scanner, commercial-history and privacy safeguards. Everyday messaging and uploads have no application request-rate limit; authentication and verification protections remain. No Admin receives general conversation access through this change.

Legacy duplicate general inquiries are linked to the oldest canonical thread without moving or deleting immutable commercial history. They remain reachable from Earlier inquiry history; new general chat goes to the canonical thread. Existing quotation actions retain their purpose-specific authorization. The unique partial index excludes Work Package and fulfillment threads.


### Owner decision — 2026-10-02: Later quotations in a permanent store chat (MSG-03)

The owner approved later, separate quotations in the same general store conversation after an earlier quotation is accepted. Vendor sales staff use New quotation; Customer Service retains draft-only authority. Each quotation keeps its own immutable published versions and accepted order. An idempotent start action requires the current quotation version, and the new draft advances the version counter so a stale editor cannot overwrite it. Earlier accepted quotations remain Accepted with their original order links; they are never relabeled Superseded by a later purchase. Work Package inquiries keep their one-quotation commercial boundary; fulfillment threads cannot create quotations.

A Buyer may add or update the saved delivery location and heavy-vehicle access declaration from Delivery details inside the general thread, without a product or a blocking chat-entry dialog. Only the Buyer's owned, nonarchived locations are permitted; the intended site and alternate drop-off remain separate. Changes require the current conversation version and are rejected while the current quotation is Published or Viewed. An existing draft's version advances, and publication rechecks the delivery reference after route calculation. Existing accepted quotation and order snapshots remain unchanged. This follows from the permanent product-free store chat: delivery must not be fixed to its first entry.

Local runtime verification uses Reverb's private channels. Native Buyer sockets send the explicit application-origin label `https://materyalph-buyer` (not a network endpoint); it grants no channel permission. Browser origins remain explicitly allowlisted. Application keys must not contain a colon because Pusher signatures use `key:signature`. No secret values belong in documentation or client bundles.

### Owner decision — 2026-10-03: Message inbox scope, personal archive and realtime fallback (MSG-04)

The Buyer's Messages inbox lists sales and quotation conversations only. The order-specific FULFILLMENT thread is reached from Order Details (**Fulfillment Messages**) and is never listed in the inbox. Vendor navigation update approved on 2026-10-07: the order's Message control opens its fulfillment thread in a popup without leaving Order Details. Owner and Store Manager may also use Fulfillment conversations inside an authorized Buyer sales inquiry to list existing threads for that Buyer and store across Item-Based and Project-Based orders. The paginated list shows active conversations first, then completed/cancelled read-only history; selecting one opens the same popup, and closing preserves the underlying inquiry and draft. Fulfillment threads remain excluded from the main sales inbox. Assigned Fulfillment Staff continue to see only their assigned thread in Messages. Access, read-only closure and attribution rules are unchanged.

Owner-approved badge update (2026-10-12): the Vendor Messages navigation badge includes received unread sales and fulfillment messages within the current member role and assignment scope. Buyer My Orders cards and Order Details Fulfillment Messages show the current Buyer unread received messages for that order. Counts use existing per-user read receipts, hide at zero, and update through private realtime invalidations and authoritative REST recovery. Inquiry inbox contents and fulfillment access rules remain unchanged.

Swiping an inbox row left archives that conversation for the Buyer only. Archive is a personal, idempotent and reversible inbox filter: it never deletes or edits messages, quotations, orders or any commercial history, and it is not offered for FULFILLMENT threads. An Archived view lists archived conversations and swipe restores them. New activity in an archived conversation returns it to the inbox. Archive and restore are audited.

Realtime stays the primary path. While the Reverb subscription is not established (unreachable, blocked, reconnecting, or backgrounded), an open inbox or thread polls the REST API every four seconds and falls back to a 45-second safety poll once the subscription is live, so a Buyer or Vendor never needs a manual refresh. A thread opens at, and follows, the newest message.

**Phase 14 decisions — approved by the project owner on 2026-10-04.** (1) **DEMO analytics data.** An explicit, non-production command seeds clearly labelled "DEMO —" stores, comparable groups for non-regulated materials and simulated daily history published only into the isolated DEMO environment; DEMO history never enters the TEST capture dataset and every analytics response carries its dataset label. (2) **Moderation and score investigation.** Super Admin and User Management Staff hold `reviews.moderate` and `scores.investigate` (exclusions and badge suppression); Order and Dispute Staff view scores read-only. No Admin can award a badge or set a score. (3) **Request Correction.** The review is hidden publicly and its author may submit one correction within 7 days; a correction returns it to the moderation queue (still hidden until restored); without a correction it stays hidden. Original content and every decision remain in the immutable history. (4) **OHS cadence.** The 00:30 Asia/Manila daily job recalculates VCS, MQS, CRR, FRR and badges every day; OHS is recalculated every Monday and carried forward between recalculations; VPS is computed daily from the current VCS and OHS.

**Phase 14 implementation definitions.** NFR counts Vendor-caused cancellations and confirmed non-fulfillment findings over orders that reached CONFIRMED in the trailing 30 days; LSR compares the first Ready for Pickup or Out for Delivery milestone's Asia/Manila date with the Vendor-confirmed date; FRR counts Self-Pickup orders made ready, and Site Delivery orders delivered, on or before that date; RR counts validated defect/wrong-item/incomplete returns over fulfilled orders; ODR counts concluded Buyer cases decided for the Buyer (replacement or refund); LVD counts confirmed misrepresented-listing findings in 90 days. Penalty-band rates are percentages rounded half-up to two decimals (2.00% carries no NFR penalty; 2.01% the Low penalty). A CRR inquiry is a Buyer's human message that opens an episode in a sales conversation; follow-ups before a reply are the same inquiry; it counts as answered when a person replies or a quotation is published within 12 wall-clock hours (store hours never apply); automated system messages never count. Most Ordered ranks Vendors with completed orders in the same canonical category and registered province; ties at the top-10% cutoff are all included. Trusted Supplier uses the first Store Activation date as verification age; a serious compliance violation is a confirmed misrepresented-listing finding in 90 days; an unresolved severe dispute is a case under Admin review, decided or under appeal. The 14-day rating window and 24-hour correction are exact instants from completion and submission. Hours never change eligibility, scores or MAT calculations.

**Phase 16 decisions — approved by the project owner on 2026-10-09.** (1) **Small-cell disclosure.** Geographic analytics suppresses any person-derived cell (registered Buyers, active users, orders, GMV, rates and response time) built from fewer than **5 distinct persons** and rolls it up into the parent area; when exactly one sibling would be suppressed, the smallest other sibling is also suppressed (complementary suppression) so it cannot be recovered by subtraction. The reason is shown with every suppressed cell, unresolved geography is reported separately and never assigned to an area, and Buyer coordinates are never stored in analytics facts or shown. Public storefront Vendor counts are not suppressed. The threshold is a versioned Platform Setting (3–50, default 5). (2) **Platform Settings.** Every listed non-secret default is wired to its consuming rule and applies to **new records only**; existing deadlines, versions and decisions keep their stored values. Each change needs the settings permission, recent re-authentication and a reason, and creates an append-only version with the previous value and a correlation ID. SRS and FMS default weights must total 100; VPS weights (50/50), the radius values, LIVE commerce, statutory rates and any NRPC cap are fixed and have no control. (3) **Graduated enforcement.** A **Warning** is recorded only. A **Temporary Restriction** makes a Vendor store RESTRICTED (out of discovery) or blocks a Buyer from new orders, quotations, inquiries and conversations, and lifts automatically when its 1–365-day duration ends. A **Suspension** makes the store SUSPENDED, or the Buyer account SUSPENDED with every session revoked, until lifted. A **Permanent Ban** is Super Admin only with recent re-authentication. Every applied sanction records a continuation plan for open orders (continue, monitored fulfillment, cancellation review, replacement, refund, or no open orders), and refunds always proceed. Lifting a Vendor sanction returns the store to its readiness state, never directly to Active. Dispute referrals are recommended by Order & Dispute and decided by User Management. (4) **Map.** The geographic dashboard draws a Google Maps JavaScript data layer with the referrer-restricted browser key and simplified PSGC boundaries loaded by an import command; areas without imported geometry, and every area when the map is unavailable, are shown as keyboard-operable tiles with the same values, and a synchronized sortable table offers the same selection.
**Phase 16 for Buyers.** A Temporary Restriction blocks only new commerce (orders, quotation decisions, Work Package inquiries and new conversations) and shows when it ends; existing orders, receipt confirmation, disputes and refunds continue. A Suspension signs the Buyer out everywhere. Buyers appear in Admin analytics only as aggregates by PSGC area under the small-cell rule; their coordinates are never used in analytics.


**Buyer My Orders decisions — approved by the project owner on 2026-10-10.** (1) **Fulfillment Messages from submission.** Each order's single FULFILLMENT thread opens in the order-submission transaction (cart checkout, quotation acceptance or project Vendor selection) instead of at the first `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`. Buyer and store may message while the order is open; it becomes read-only at `COMPLETED`, `CANCELLED`, `DECLINED` or `EXPIRED`, with a closing system message, and Fulfillment Staff access still follows the current assignment. It stays separate from the SALES inquiry conversation and out of the Buyer inbox; the Buyer opens it from the message button on each My Orders card or from Order Details. An open order submitted before this change gains its thread when the Buyer opens it or at the first handover milestone. (2) **Status chips.** My Orders has Item and Project tabs and the chips Confirmation (awaiting the Vendor, the Buyer's approval or NRPC acceptance, or payment), Processing (confirmed, preparing, cancellation requested), To ship (ready for pickup, out for delivery), To receive (delivered or picked up, awaiting receipt confirmation), Completed, Cancelled (cancelled, declined, expired) and Disputed. Cards that need the Buyer stay highlighted with their next step. Card shortcuts are the server's own actions: Confirm receipt and Report a problem while awaiting receipt, Return/Refund (the Return or Refund Request) until the post-completion window ends, View case, Cancellation details, and Buy again. (3) **Buy Again.** For a completed or cancelled Item-Based order, Buy Again adds each still-eligible line to the cart at today's price version and the original quantity, using the same eligibility, radius and quantity checks as adding by hand. Lines that cannot be added are listed with their reason and are never reduced to fit stock, so exact inventory is not revealed. Earlier prices, discounts and delivery fees are never reused, and nothing is reserved until checkout. **Amended by the project owner on 2026-10-14:** the All chip is removed and My Orders opens on Confirmation, split out of Processing as above; Confirmation, Processing, To ship, To receive and Disputed show a count badge of the Buyer's orders in that chip for the selected tab (Completed and Cancelled are history and show none). The API still accepts `group=ALL`.

**Work Package authoring decisions — approved by the project owner on 2026-10-12.** (1) **Allocation is a hard ceiling.** Every Work Package budget that is not `CANCELLED`, Drafts included, is deducted from the Project budget as soon as it is saved. A save is rejected (`WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT`) when the allocations would exceed the Project budget, and lowering the Project budget below its allocations is rejected (`PROJECT_BUDGET_BELOW_ALLOCATED`). `Allocated to Work Packages` and `Unallocated Reserve` in the budget view follow this rule. (2) **Unlisted materials.** A material line names a canonical catalog material, chosen from exact, alias or close-match suggestions, or an unlisted material the Buyer names with any normalized unit and free technical details. An unlisted line is never machine-matched: system scanning, the budget estimate and quotation reconciliation always treat it as a missing line, and it is resolved only by an audited waiver that may name the Buyer's separate purchase. Catalog lines state technical details by their category attribute codes so matching can compare them. Each line may carry an informational description and colour. (3) **Materials budget estimate.** While drafting, the Buyer may turn on an advisory estimate. Each catalog line is priced at the half-up average of one price per Vendor, that Vendor's lowest eligible exact match (material, unit, brand when set and every stated detail), among the Vendors scanning would consider within the package's confirmed radius of its site. Unlisted and unmatched lines are shown without a price. The estimate covers materials only, excludes delivery fees and labor, is not stored and is not a system-compiled estimate or a quotation. (4) **Finalize** saves the Draft; activation remains a separate, explicit action.

**Vendor selection decisions — approved by the project owner on 2026-10-12.** (1) **Find vendors.** The Vendor comparison opens from the Work Package as its own screen: a map of the locked site with radius choices, and a results list sorted on the server by best match, budget fit, rating or price and filtered by preferred sellers, complete match or within budget. Best match is a fixed ranking; Budget fit, Rating and Price each carry a direction arrow, opening on high to low, high to low and low to high respectively, and tapping the selected tab reverses it while choosing another tab resets that tab to its own default (requested 2026-10-17). A Vendor with no rating is always last, ties go to the nearest store, and a radius change keeps the chosen sort and direction. Each result opens the Vendor's system-compiled estimate as a quotation view; a published Vendor quotation stays separate and is reviewed in the conversation. (2) **Missing materials.** For a line the Vendor cannot supply, the quotation view recommends eligible Item-Based offers of the same canonical material and unit within the package radius, exact matches first, with stock shown only as a label. Adding one creates a separate Item-Based cart line tagged with the Work Package line; it never joins the Project-Based order. After checkout and Vendor acceptance the tagged order can be linked to the missing line, which still verifies material, unit, brand, specifications and quantity. Unlisted lines have no recommendations and are resolved by waiver. (3) **Delivery mode** is shown as locked in the activated package; changing it requires a new Work Package version, so it is not a comparison filter. (4) **Both — approved by the project owner on 2026-10-17.** A Work Package's Fulfillment may be Delivery, Pickup or Both, where Both means the Buyer is open to either. The Vendor scan lists every eligible store that offers Site Delivery, Self-Pickup or both, and each result states which of the two it offers. For a store offering both, the Buyer picks Delivery or Pickup on its quotation view, which is re-priced for the pick (Delivery adds the estimated delivery fee; Pickup excludes ready-mixed concrete, which is mixer-delivered). That pick is required before messaging the Vendor or selecting it, and the quotation and order carry that one concrete method. A Both package accepts only Online payment, because Cash on Delivery needs Delivery and In-Store Payment needs Pickup, and it requires the delivery details (Site contact, Access instructions and the heavy-vehicle answer). The Site contact defaults to the Buyer's registered number and stays editable.

**Specification matching and choice — requested by the project owner on 2026-10-16.** (1) **Stated details.** A catalog line's technical details use its category's attribute codes and labels, the same ones Vendors fill in Product information; numbers must be above zero and are stored in one canonical form, choices use the category's spelling, and any other code is rejected (`INVALID_SPECIFICATION`). The editor shows, for each detail, the values currently eligible in-stock products are listed with ("Listed"), from public listing facts only. Matching everywhere (scanning, the budget estimate, missing-line recommendations, linked-order verification and quotation reconciliation) compares normalized values, so `15.0` equals `15` and text ignores case and repeated spaces. (2) **Specification options.** A Vendor's eligible offers for a line that share normalized details and option label form one specification option. A line is filled from one option only and never mixes two. When exactly one option fits, it is used. When several fit because the Buyer left a detail open, the line is flagged `selection_required`, lists every option (details, lowest unit price, availability label only) and is priced on the option that supplies the most as a labelled basis ("From …"); nothing is auto-selected. Selecting the Vendor or messaging it is refused (`SPECIFICATION_SELECTION_REQUIRED`) until the Buyer chooses each such option. The choice re-prices the candidate on the server (lines, VAT, delivery estimate, score, budget label) without storing anything, and the same choices are sent with selection or inquiry, which record the applied estimate. (3) **Quotation Order summary.** Each supplied product shows its labelled details, variant, quantity × price and "Sold by" store, and opens Product Details on that variant; Product Details uses the same category labels. Missing-item recommendations and separate purchases also name their store and open Product Details. Missing items are still bought only through separate, tagged Item-Based purchases.

**Owner decision — 2026-10-13: delivery assignments and proof.** Site Delivery dispatch requires an active same-store Fulfillment Staff assignment and an available accepted registered vehicle, saved atomically with Out for Delivery. Active allocations cannot exceed the registered configuration's available count. Owner/Manager reassignment before Delivered records reason/history, notifies affected staff and preserves accepted arrangements and charges; a different commercial arrangement still needs Buyer approval. Acknowledgement and issue reports are attributed events, not new order states. Assigned staff alone use the standalone Fulfillment workspace; Owner/Manager oversight stays in Order Details. Store Profile appears in the sidebar for Vendor Owners and Store Managers, with existing role-specific profile permissions; Fulfillment Staff have no My Products or E-Invoices navigation/API access. Existing authorized Owner profile management remains available.

The Buyer sees public assigned staff name, assigned vehicle, destination, milestones, delivery issues and private proof from Order Details, with the existing order-specific fulfillment messages and automatic REST refresh after private invalidations. Private staff contacts/credentials are excluded. Only the current active assigned Fulfillment Staff may record Delivered; Owner/Manager delivery proof controls are replaced by assignment oversight and the submitted proof. Out for Delivery opens staff/accepted-vehicle selection inside that phase, and Done saves assignment and dispatch together. Delivered requires successful receiver-name/photo submission through validated, scanned private evidence storage; optional signature, notes and up to three additional photos use the configured evidence limit. Buyer receipt confirmation stays separate. Staff directions use the registered store and confirmed order endpoint, an actual provider route, estimated driving distance/time, accessible addresses and external navigation; no live GPS tracking is introduced. Closure revokes staff order/thread/file access while retaining Buyer/Owner history. Self-Pickup retains its existing handover and optional staff assignment rules. This delivery requirement supersedes earlier optional-delivery-assignment defaults.

**Owner-requested delivery recommendation update — 2026-10-15.** Automatically select a system recommendation for each separately carried compatible load group from the fulfilling Vendor's currently eligible vehicles. Rank by the lowest calculated delivery fee, then fewer total trips, fewer vehicles and a stable vehicle-ID tie break. Item-Based previews, checkout and Project-Based system estimates show the calculated fee and recommended vehicle/trips; Vendor order confirmation loads and selects the recommendation automatically. This remains advisory. A dimensional rejection or missing measurements still requires accurate transport data or a documented manual arrangement and must never be presented as a proven fit or invented fee. The Owner/Store Manager confirms access, endpoint, date, vehicle counts and trips. Changing the recommended vehicle, count, trips or gross formula fee requires a 10–2000-character explanation, frozen with the original recommendation and confirmed arrangement, shown to the Buyer for explicit approval before payment. Recheck against the submitted recommendation when available, including changed route/rate costs. Manual reviews disclose their explanation. Existing approval, NRPC, role permissions, idempotency, audit/outbox, payment gates and immutable historical snapshots remain authoritative.

## Unified inquiry inbox — owner decision, 2026-10-15

Messages shows one sales inbox entry per Buyer and Vendor Store. Opening it uses the existing Item-Based inquiry as the main conversation. Project inquiries inside that conversation lists the pair's Work Package conversations, with their own locked originals, editable duplicates, quotation versions, messages and read receipts. New Work Package inquiries also ensure an empty main Item-Based conversation exists. Existing project-only histories receive an empty main conversation through an additive data migration; no commercial history is moved or deleted.

**Owner UI decision — 2026-10-18.** Quotation history opens in a modal above the conversation and preserves its draft and scroll position. Project inquiries and its counts show open quotation workflows only: the current version of an undeleted, unassigned Active/Quotation Inquiry Work Package in an Active Project, with a Draft, Published, Viewed, Countered or Stock Revalidation Required quotation. Published, Viewed and Countered deadlines must remain in the future. Accepted, expired, rejected, withdrawn and older inquiries retain their existing authorized history routes. The server applies this filter before pagination for both Buyer and Vendor.

The inbox preview, activity order and unread badge aggregate the authorized item and project conversations. Reading the main item inquiry does not mark project messages read. Archive/restore applies to the whole personal Store inquiry group, and activity in any inquiry restores the group. Work Package inquiry creation remains in the Project Vendor comparison flow. Fulfillment communication stays with its existing order-specific entry and authority.

### Owner decision — 2026-10-18: Buyer payment choice for message quotations

For Item-Based and Project-Based message quotations, the Vendor selects fulfillment and publishes the commercial terms without selecting a payment method. Before accepting the latest quotation, the Buyer must explicitly choose an available method: Cash on Delivery or Online Payment for Site Delivery; In-Store Payment or Online Payment for Self-Pickup. Existing Vendor-enabled physical-method settings and online-account readiness still determine availability, and the server rechecks them at acceptance. No method is preselected. The choice is recorded in the accepted order, commercial snapshot and acceptance event; it never rewrites a published quotation version. Older accepted orders retain their recorded method. Existing NRPC, processing-fee, reservation, idempotency and payment-verification rules continue to apply. This supersedes earlier wording requiring the Vendor to choose payment in the quotation builder.

### Owner decision — 2026-10-18: Grouped Work Package quotations

New comparisons offer complete single-Vendor packages first, followed by up to three distinct editable supplier arrangements. Multi-Vendor members are equal; the selected arrangement replaces the single-selected-Vendor restriction for this flow. All members must meet existing Project-Based eligibility within 50 km. Existing exact specification matching, explicit specification choices, removal preferences, per-supplier fulfillment and payment choices, mixer-only ready-mixed concrete, and authoritative combined materials/delivery totals apply. Selecting a proposal saves only a draft. After the checklist and checkout, one explicit idempotent submission sends independent pending requests; it never accepts a quotation, reserves stock or starts payment. Existing formal quotations still require explicit Buyer acceptance. A declined, expired or cancelled allocation can be replaced while other Vendor orders remain intact. Work Package progress covers all requirements and member orders; completion requires completed exact quantities or existing explicit waivers. Historical awards, quotations, orders and Item-Based carts retain their original relationships. This decision supersedes earlier one-awarded-Vendor and primary/supplementary wording for new arrangements.


### Owner decision — 2026-10-19: Arrangement options and Best Match

New Work Package comparisons retain all complete single-Vendor options and explore distinct exact-compatible supplier/product allocations, returning up to three groups when alternatives exist. Deduplication uses supplier, original requirement, product and quantity; changing only fulfillment mode does not create another group card. Search is bounded and is advisory, not an exhaustive optimization or a guarantee of three eligible combinations. Explicit edited drafts and removals resume unchanged.

Complete arrangements rank together by arrangement FMS rather than always promoting single Vendors. The existing four criteria and independently saved Buyer weights remain unchanged and normalize by their sum. Material Match uses the average exact quantity share fulfilled per original requirement, never a sum of PC/CUM quantities; explicit waivers do not become supplied materials. Budget Fit uses every supplier's materials and applicable delivery against the Work Package budget, with existing over-budget rules. Distance and normalized VPS are weighted by each supplier's share of the arrangement's material cost; New Vendors retain the existing neutral scoring treatment and public New Vendor label. No group VPS or average of individual whole-package FMS scores is invented. This version is `fms.arrangement-material-share.v1`; historical Vendor FMS calculations retain their version.

Complete coverage precedes FMS; reviewable, known-cost options precede options needing cost/data review. Equal FMS prefers fewer Vendors, then lower known delivery-inclusive total and a stable identity. Price sort compares known complete totals independently of FMS. The Best Match list displays TOP 1 — Best Match for You only on an eligible, fully covered, known-cost first option, with an expandable component/weight/supplier-share explanation. Editing an allocation recalculates its FMS and costs. Opaque Buyer/Work Package/version-scoped proposals preserve the exact option opened; current price, stock, specification and delivery checks still apply before saving a draft or submitting requests. Existing confirmation, reservation, payment, cart independence and historical-record rules are unchanged. This supersedes single-Vendor-first ordering for new grouped comparisons.


### Owner enhancement - 2026-10-19: Help Center support

Help Center includes Contact Us and My Support Requests. Account identity is populated from authenticated server records; existing identity masking remains effective. Buyers may supply a concern category, subject, description, optional order/project/work-package/transaction reference and private supporting files. Submission displays a ticket number. Buyers read responses, status and history and send follow-ups in the same ticket, with notifications for Admin responses and status changes. This does not replace order disputes or Buyer-Vendor messaging.
