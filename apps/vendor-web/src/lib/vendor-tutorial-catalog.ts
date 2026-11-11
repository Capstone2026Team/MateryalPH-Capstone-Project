import type { AcknowledgeTutorialTutorialKeyEnum } from '@materyalph/api-client-ts'
import type { PortalNavSection } from '@materyalph/web-ui'

export type VendorGuide = {
  id: string; label: string; group: string; href: string; navigation?: string; description: string
  chapters?: string[] | undefined; tabList?: string; permission?: string; progressKey?: AcknowledgeTutorialTutorialKeyEnum
  contextOnly?: boolean; matches?: RegExp
  parent?: string
}

/** These are the existing authenticated workspaces, not proposed capabilities. */
export const vendorGuides: readonly VendorGuide[] = [
  { id: 'dashboard', progressKey: 'dashboard', label: 'Dashboard', group: 'Overview', href: '/dashboard', navigation: '/dashboard', description: 'Your store summary, priority work and every available dashboard graph.', chapters: ['Overview', 'Traffic & Volume', 'Disputes & Quality'], tabList: 'Workspace sections' },
  { id: 'orders', label: 'Orders', group: 'Store Operations', href: '/orders', navigation: '/orders', progressKey: 'orders', description: 'Find order requests, filter their states and open the next permitted action.' },
  { id: 'fulfillment', progressKey: 'fulfillment', label: 'Fulfillment', group: 'Store Operations', href: '/fulfillment', navigation: '/fulfillment', description: 'Assigned pickups and deliveries, directions, coordination and handover proof.' },
  { id: 'messages', label: 'Inquiries & quotations', group: 'Store Operations', href: '/messages', navigation: '/messages', progressKey: 'messages', description: 'Buyer conversations, material requests, quotation drafts and published terms.' },
  { id: 'invoices', progressKey: 'invoices', label: 'E-Invoices', group: 'Store Operations', href: '/invoices', navigation: '/invoices', description: 'Buyer requests, missing copies, uploaded invoices and reconciliation.', chapters: ['Requests', 'No copy yet', 'Uploaded', 'Mismatches'], tabList: 'Invoice view' },
  { id: 'disputes', progressKey: 'disputes', label: 'Disputes & Appeals', group: 'Store Operations', href: '/disputes', navigation: '/disputes', description: 'Find cases, response deadlines, evidence, resolutions and appeals.' },
  { id: 'reviews', progressKey: 'reviews', label: 'Ratings & Reviews', group: 'Store Operations', href: '/reviews', navigation: '/reviews', description: 'Published store ratings and product reviews, filters and review details.', chapters: ['Store ratings', 'Product reviews'], tabList: 'Review type' },
  { id: 'products', label: 'Product listings', group: 'Store Management', href: '/products', navigation: '/products', progressKey: 'products', description: 'Listing states, search, categories, product cards and Add product.' },
  { id: 'inventory', parent: 'products', label: 'Inventory', group: 'Store Management', href: '/products/inventory', navigation: '/products', permission: 'inventory.view', progressKey: 'inventory', description: 'Stock quantities, prices, confirmation, movements, allotments and auto-accept.' },
  { id: 'vehicles', progressKey: 'vehicles', label: 'Vehicles', group: 'Store Management', href: '/vehicles', navigation: '/vehicles', description: 'Fleet readiness, vehicle availability, capacity, delivery rates and vehicle editing.' },
  { id: 'finance', progressKey: 'finance', label: 'Finance overview', group: 'Finance', href: '/finance', navigation: '/finance', description: 'Sales, earnings, collections, deductions, payment channels and tax profile.' },
  { id: 'commissions', progressKey: 'commissions', parent: 'finance', label: 'Commission monitoring', group: 'Finance', href: '/finance/commissions', navigation: '/finance', description: 'Current terms, estimated and earned fees, credits, statements and recorded payments.' },
  { id: 'transactions', progressKey: 'transactions', parent: 'finance', label: 'Transactions', group: 'Finance', href: '/finance/transactions', navigation: '/finance', description: 'Payment and refund records, filters, dates and transaction details.' },
  { id: 'remittance', progressKey: 'remittance', parent: 'finance', label: 'Xendit cash revenue & remittance', group: 'Finance', href: '/finance?section=threshold', navigation: '/finance', description: 'TEST connection, cash revenue estimates, annual remittance and withholding records.' },
  { id: 'performance', progressKey: 'performance', label: 'Store Performance', group: 'Analytics', href: '/performance', navigation: '/performance', description: 'Published scores, operational measures, score history, badges and store health.' },
  { id: 'analytics', progressKey: 'analytics', label: 'Product Analytics', group: 'Analytics', href: '/analytics/products', navigation: '/analytics/products', description: 'Views, orders, conversion, rankings, category shares, demand groups and associations.' },
  { id: 'team', progressKey: 'team', label: 'Team Accounts', group: 'Vendor Team Accounts', href: '/team', navigation: '/team', description: 'Individual staff accounts, fixed roles, invitations and permitted account management.', chapters: ['Team members', 'Invitations'], tabList: 'Team account views' },
  { id: 'tracking', progressKey: 'tracking', label: 'Team Tracking', group: 'Vendor Team Accounts', href: '/preview/tracking', navigation: '/preview/tracking', permission: 'staff.manage', description: 'Team Tracking opens the first available employee’s recorded work. Choose another person from Your team to see their role-specific statistics, activity history and responsibilities.', chapters: ['Statistics', 'Activity history', 'Role responsibilities'], tabList: 'Tracking views' },
  { id: 'store', label: 'Store profile', group: 'Store Profile', href: '/store-profile', navigation: '/store-profile', progressKey: 'store', description: 'Public store information, media, business evidence, location and operational settings.', chapters: ['Store Information', 'Business Information', 'Store Location', 'Vacation Mode', 'Operating Hours', 'Fulfillment Configuration', 'Account Deletion'], tabList: 'Workspace sections' },
  { id: 'settings', progressKey: 'settings', label: 'Account & security', group: 'Account & Help', href: '/settings', description: 'Personal profile, account details, security, signed-in sessions and agreements.', chapters: ['Profile', 'Account', 'Security', 'Sessions / Devices', 'Agreements'], tabList: 'Account sections' },
  { id: 'notifications', progressKey: 'notifications', label: 'Notifications', group: 'Account & Help', href: '/notifications', description: 'Your notification inbox, record links and notification delivery preferences.' },
  { id: 'support', progressKey: 'support', label: 'Support requests', group: 'Account & Help', href: '/support/requests', description: 'Your private support requests, recorded replies and follow-ups with MateryalPH.' },
  // Record editors are guided only after the user opens a real record. Never invent an ID or create a draft for a tour.
  { id: 'product-editor', label: 'Product editor', group: 'Current record', href: '/products/new', navigation: '/products', permission: 'catalog.manage', contextOnly: true, matches: /^\/products\/(?!inventory$|import$)[^/]+$/, description: 'Material identification, core and technical details, variants, pricing, stock, media and compliance.' },
  { id: 'order-detail', label: 'Order details', group: 'Current record', href: '', navigation: '/orders', contextOnly: true, matches: /^\/orders\/[^/]+$/, description: 'Order information, materials, state families, financial breakdown, fulfillment, messages and history.' },
  { id: 'fulfillment-detail', label: 'Assignment details', group: 'Current record', href: '', navigation: '/fulfillment', contextOnly: true, matches: /^\/fulfillment\/[^/]+$/, description: 'Your assigned items, accepted vehicle, directions, coordination, milestones and proof.' },
  { id: 'case-detail', label: 'Case details', group: 'Current record', href: '', navigation: '/disputes', contextOnly: true, matches: /^\/disputes\/[^/]+$/, description: 'Case status, deadlines, evidence, proposals, Admin questions and available resolution actions.' },
  { id: 'review-detail', label: 'Review details', group: 'Current record', href: '', navigation: '/reviews', contextOnly: true, matches: /^\/reviews\/[^/]+$/, description: 'The published review, rating criteria, attachments and permitted reporting actions.' },
  { id: 'product-insights', label: 'Product analytics details', group: 'Current record', href: '', navigation: '/analytics/products', contextOnly: true, matches: /^\/(?:analytics|performance)\/products\/[^/]+$/, description: 'This product’s saved details, views and orders, conversion, standing, associations and suggestions.' },
  { id: 'statement', label: 'Commission statement', group: 'Current record', href: '', navigation: '/finance', contextOnly: true, matches: /^\/finance\/statements\/[^/]+$/, description: 'The issued statement snapshot, line items, due amount and verified payment history.' },
  { id: 'support-ticket', label: 'Support ticket', group: 'Current record', href: '', contextOnly: true, matches: /^\/support\/(?!requests$)[^/]+$/, description: 'The current support request, its replies, attachments and follow-up controls.' },
  { id: 'verification', label: 'Store Verification', group: 'Current setup page', href: '', contextOnly: true, matches: /^\/onboarding\/verification$/, description: 'The current verification step, evidence requirements and review instructions. Tutorial completion never submits or approves verification.' },
  { id: 'setup', label: 'Store Setup', group: 'Current setup page', href: '', contextOnly: true, matches: /^\/onboarding\/setup$/, description: 'The current setup step and its actual controls. Saved setup, payment readiness and Store Activation remain separate requirements.' },
  { id: 'welcome', label: 'Vendor Welcome', group: 'Current setup page', href: '', contextOnly: true, matches: /^\/welcome$/, description: 'Review the introduction and use the existing Continue action when you are ready to begin store verification.' },
]

export function availableVendorGuides(navigation: PortalNavSection[], permissions: readonly string[], path: string): VendorGuide[] {
  const enabled = new Set(navigation.flatMap(section => section.items.filter(item => !item.disabled).map(item => item.href)))
  return vendorGuides.filter(guide => (!guide.navigation || enabled.has(guide.navigation)) && (!guide.permission || permissions.includes(guide.permission)) && (!guide.contextOnly || guide.matches?.test(path)))
    .map(guide => guide.id === 'store' ? { ...guide, chapters: permissions.includes('vendor.onboarding.submit') ? guide.chapters?.filter(chapter => chapter !== 'Account Deletion' || permissions.includes('organization.delete')) : undefined } : guide)
}

export function currentVendorGuide(guides: readonly VendorGuide[], path: string, search = ''): VendorGuide | undefined {
  return guides.find(guide => guide.contextOnly && guide.matches?.test(path))
    ?? (path === '/finance' && new URLSearchParams(search).get('section') === 'threshold' ? guides.find(guide => guide.id === 'remittance') : guides.find(guide => !guide.contextOnly && guide.href.split('?')[0] === path))
}

/** A feature has one entry point and continues through all of its authorized tabs and pages. */
export function vendorFeatureGuides(guides: readonly VendorGuide[], start: VendorGuide): VendorGuide[] {
  if (start.contextOnly) return [start]
  const root = start.parent ?? start.id
  const family = guides.filter(guide => !guide.contextOnly && (guide.id === root || guide.parent === root))
  const index = family.findIndex(guide => guide.id === start.id)
  return index < 0 ? [start] : [...family.slice(index), ...family.slice(0, index)]
}

/** Plain-language interpretation, without changing any calculation or giving financial advice. */
export const vendorSectionHelp: Readonly<Record<string, string>> = {
  'Overview': 'Start with the summary, then check urgent work and the trends below. The selected dates apply to reporting; current-work cards explain when they use all dates.',
  'Traffic & Volume': 'Follow inquiries, quotations, order requests and confirmed orders. These are recorded marketplace interactions, not storefront visitor counts.',
  'Disputes & Quality': 'Review reported cases, current case workload, returns and cancellation measures. A report alone is not a finding of fault.',
  'At a glance': 'These headline measures summarize the selected period. Read each label and comparison carefully; an unavailable comparison is not a zero.',
  'Earnings': 'Confirmed sales after cancelled value and completed refund deductions, before commission and business costs. This is different from money collected or a payout balance.',
  'Gross sales': 'The value of orders first confirmed in the selected period, before later cancellations and refunds. Dates use Asia/Manila.',
  'Average order value': 'Gross sales divided by orders first confirmed in the period. No confirmed orders means this average is unavailable.',
  'Orders confirmed': 'Orders first confirmed in the selected dates. Each order counts once, including orders later completed, cancelled or disputed.',
  'Fulfillment rate': 'Completion by the reporting period’s end for non-cancelled orders due in that period. This differs from the on-time fulfillment score.',
  'Priority actions': 'Work waiting for your role, ordered by urgency. Open the corresponding record after the tour to review and take its permitted action.',
  'Incoming order requests': 'New order requests waiting for your store’s decision. Open a real request to review the materials, fulfillment and response deadline before confirming or declining.',
  'Recent activity': 'The latest recorded store events, with their actor and Manila timestamp. Team Tracking provides the fuller member-by-member view.',
  'Stock status': 'Stock needing attention and confirmation reminders. Review Inventory before changing quantities or availability.',
  'Store performance': 'A snapshot of published store scores and health. Store Performance explains score components, history and badges.',
  'Order activity': 'Compare recorded confirmed orders over time. Any forecast is a planning aid with uncertainty, not a promised order count.',
  'Sales trend': 'Compare earnings, refund deductions and cancelled sales by day. Review the calculation information before comparing these figures with collections.',
  'Sales by category': 'Compare confirmed sales across material categories. The selected dates and access to sales values determine what is shown.',
  'Top products': 'Products ranked by recorded order activity in the period. A high rank reflects the displayed measure, not a quality guarantee.',
  'Product demand patterns': 'Groups products by recorded demand. Use the segment descriptions and chart axes to interpret differences; the groups do not change rankings or prices.',
  'Product demand segments': 'Each point represents a product. Compare orders and distinct Buyers, then inspect the segment label for its demand pattern.',
  'Frequently ordered together': 'Associations found in recorded purchases. They suggest combinations to review and do not guarantee that another Buyer will order them together.',
  'Demand funnel': 'Compare counts at each recorded stage. Stages can involve different days, so these counts are not automatically a single-cohort conversion rate.',
  'Order mix': 'See the share of confirmed orders by procurement type, fulfillment and payment method. This shows order counts, not peso collections.',
  'Requests and confirmations per day': 'Compare requests submitted and orders first confirmed on each Manila day. A request can be confirmed on a later day.',
  'Cases filed per day': 'New cases grouped by filing date. This differs from Open cases, which is the current workload across all dates.',
  'Issue types': 'Filed cases grouped by the reported issue. The issue label is a report, not a final decision or validated return.',
  'Open cases by status': 'Currently active cases grouped by their latest state, regardless of the reporting dates.',
  'Cancellation': 'Cancelled orders among orders first confirmed in the period, including all causes. Store Performance separately explains Vendor-caused scoring measures.',
  'Fleet overview': 'Review registered vehicles and their readiness. Vehicle availability, capacity, rates and staff readiness determine delivery eligibility.',
  'Vehicle Name': 'Use a recognizable name so your team can distinguish this saved vehicle configuration when assigning deliveries.',
  'Vehicle Brand': 'Record the vehicle brand or manufacturer where applicable. This is separate from its category, type and rated capacity.',
  'Number of Vehicles': 'The number of vehicles represented by this configuration. Existing allocations and eligibility checks still determine what can be used for a delivery.',
  'Maximum Weight Capacity (kg)': 'Enter the actual rated payload in kilograms. A suggested payload must be reviewed; it does not replace the vehicle’s real capacity.',
  'Mixer Capacity (m³)': 'Enter the actual mixer drum capacity in cubic meters. Supply volume and drum capacity are different values and must be confirmed separately.',
  'Cargo Length (m)': 'The usable cargo-space length in meters. It contributes to the existing dimensional-fit checks for ordinary cargo.',
  'Cargo Width (m)': 'The usable cargo-space width in meters. Review it alongside cargo length, height and rated payload.',
  'Cargo Height (m)': 'The usable cargo-space height in meters. Existing road, site-access and load checks remain authoritative.',
  'Base Fee (₱)': 'The saved base delivery fee per trip for this configuration. Existing accepted deliveries retain their recorded arrangement and charges.',
  'Per-Kilometer Rate (₱/km)': 'The configured distance rate used by the existing delivery-fee calculation. Review the final proposed arrangement before confirming it for a Buyer.',
  'Maximum Delivery Distance (km)': 'The configured delivery range. This does not expand procurement beyond the platform’s approved distance limits.',
  'Team members': 'Each staff member has an individual account and one fixed role. Existing permissions and delegation govern the actions you can perform.',
  'Invitations': 'Review invited staff and invitation state. Creating or changing an account remains an explicit action outside the tutorial.',
  'Staff dispute access': 'This Owner setting controls dispute access for Store Staff and Customer Service Staff. It does not grant protected finance powers.',
  'Select a team member': 'Choose a real member to see their statistics, activity history and role responsibilities. This is recorded work, not live location tracking.',
  'Selected team member': 'This workspace shows the member you choose from Your team. Review their role-scoped statistics, activity history and responsibilities using the available views.',
  'Team member details': 'After selecting a team member, this area shows the selected view of their recorded work. It stays empty until you choose an authorized member.',
  'Activity history': 'Recorded actions for the selected member and period. Check timestamps and unsuccessful results before interpreting activity totals.',
  'Role responsibilities': 'The fixed role’s responsibilities explain which work the member may perform. A tutorial never grants additional access.',
  'Finance overview': 'Compare sales with collections and deductions. Owner-only financial figures retain their existing definitions and access rules.',
  'Sales and collections': 'Sales measure confirmed commercial value; collections measure recorded receipts. Their dates and treatment of refunds can differ.',
  'Financial calculations': 'Read the recorded materials, discounts, delivery, refunds and receipts behind the totals. Earnings and collections use different events and reporting dates.',
  'Deductions and commission': 'Compare recorded withholding and platform commission over time. Commission is billed separately; withholding is a tax credit and does not reduce the recorded sales value.',
  'Deductions and fees': 'Review Buyer-paid processor fees, withholding and Vendor-paid commission separately. These amounts have different purposes and must not be subtracted from sales as one combined charge.',
  'Product sales value': 'Materials sold in the selected dates after Vendor discounts, including materials VAT. The separate delivery amount reconciles product sales to the displayed earnings.',
  'Conversation inbox': 'Your authorized Buyer conversations, with search, unread indicators and pagination. The first conversation opens automatically; choose another Buyer to switch threads.',
  'Conversation and quotations': 'Read the selected Buyer’s messages and Work Package context, reply, or prepare a quotation using the controls available to your role. The guide never sends a message or publishes a quotation.',
  'Invoice view': 'The tour continues through Requests, No copy yet, Uploaded and Mismatches. Each view has its own list and keeps the selected date filters.',
  'Invoice list': 'Find authorized orders or invoice copies in the selected view. Select a row to show its details; date filters apply to the list while the summary counts cover all dates.',
  'Invoice details': 'Review the selected order, invoice state, issuer, Buyer and accepted amounts. Uploading or preparing a copy does not send it; review it before using Send.',
  'MateryalPH documents': 'Platform Purchase Orders are supporting transaction records. The Vendor issues its own sales invoice through its registered process and supplies a copy when required.',
  'Xendit cash revenue and connection': 'Review the current TEST connection and remittance context. TEST readiness does not establish live payment processing.',
  'Tax profile': 'Review the saved tax classification and masked taxpayer information. Protected changes continue through existing validation and authorization.',
  'Online payment channels': 'Supported online channels and their published demo fees. A configured channel does not by itself prove a successful payment.',
  'Commission overview': 'Distinguish estimated fees on accepted orders, earned fees on completed materials, approved credits and amounts billed or paid.',
  'Commission by order': 'Inspect each order’s saved materials basis and original rate. Historical assessments are not recalculated using today’s terms.',
  'Commission statements': 'Issued commission bills retain their original assessment history. Open an existing statement for its amounts, due date and payment records.',
  'Transactions': 'Find recorded payments and refunds using the available views and dates. Provider redirects alone are not payment confirmation.',
  'Statement summary': 'Review the issued statement’s saved totals, due amount and status before using its explicit payment action.',
  'Payment history': 'Recorded payment events and their authoritative status. Pending or failed attempts do not count as successful settlement.',
  'Xendit cash revenue estimate': 'A revenue estimate from the recorded collections, refunds and withholding context. This is not a marketplace wallet or a provider balance.',
  'Published store scores': 'Published scores use the existing scoring rules. Missing or unpublished scores remain unavailable rather than becoming zero.',
  'Vendor performance (VPS)': 'The published Vendor performance score combines the approved score components. Open the existing calculation help for the exact definitions.',
  'Community rating (VCS)': 'Community rating summarizes eligible published Buyer ratings. It remains separate from operational health and material quality.',
  'Material quality (MQS)': 'Material quality uses eligible product-rating information. Review its coverage before comparing it with other score components.',
  'Operational health (OHS)': 'Operational health uses confirmed operational events under the existing rules. Reports without confirmed findings do not automatically establish fault.',
  'Operational performance': 'These recent operational measures explain order completion, cancellations, disputes and decision time. Their windows can differ from published score windows.',
  'Score history': 'Compare saved published scores over time. Each point is a recorded score snapshot, not a retroactive rewrite.',
  'Badge metrics': 'Review the eligibility measures behind published badges. A badge does not promise stock, sales or fulfillment.',
  'Product views and orders': 'Compare recorded product views and confirmed orders over time. Views start when recording began; earlier days do not have tracked views.',
  'Product quality': 'Review available material quality alongside eligible product ratings. Your role determines which score information is visible.',
  'Suggestions': 'Suggestions summarize recorded demand and stock signals. Review the evidence before taking an explicit product or inventory action.',
  'Top-rated products': 'Products ranked by published product-rating information. Check the displayed coverage and period before comparing results.',
  'Top selling products': 'Products ranked by recorded sales activity under the displayed measure and dates.',
  'Top performing products': 'Compare products using the displayed demand and conversion measures, rather than treating rank as a quality score.',
  'Category share': 'Compare each category’s share of the displayed measure. Read the label to distinguish views, orders and sales value.',
  'All products': 'Search, sort and compare your products, then open a real product for its detailed analytics.',
  'Most viewed products': 'Products with the most recorded Product Details views in the selected period. Views are counts only; Buyer identities are not exposed.',
  'Views by category': 'Recorded views grouped by material category. This shows product interest, not confirmed purchases.',
  'Product performance segments': 'Each point compares views and conversion for a product. Segment descriptions explain the recorded pattern without changing product rankings.',
  'From view to order': 'Review the product’s recorded views and orders and the displayed conversion definition. These counts are not a guaranteed Buyer journey.',
  'Frequently ordered with': 'Products associated with this product in eligible past purchases. Use this as a planning suggestion only.',
  'Store Information': 'Manage the public store description and branding. Public details remain separate from protected business evidence.',
  'Business Information': 'Review the saved legal, representative and compliance information. Existing verification and private-file permissions continue to apply.',
  'Store Location': 'Review the registered store location and its accessible address. The tutorial does not change the map pin.',
  'Vacation Mode': 'Review the current vacation setting and dates. Any change requires the existing explicit action and does not rewrite accepted orders.',
  'Operating Hours': 'Review the saved weekly schedule and closures. Opening hours are informational and do not pause order deadlines.',
  'Fulfillment Configuration': 'Review pickup, delivery, physical-payment selections and delivery readiness. Accepted order arrangements remain unchanged.',
  'Account Deletion': 'Review eligibility and blocking obligations. This guide does not request or confirm deletion; commercial history remains protected.',
  'Order information': 'Review this order’s saved Buyer, references and procurement context before taking an action.',
  'Order items': 'Materials and quantities belong to the order snapshot. Revisions follow the existing review and acceptance flow.',
  'Buyer payment breakdown': 'Review the Buyer’s agreed charges and payment split. Vendor commission and withholding are handled separately.',
  'Order status': 'Order, payment, fulfillment, refund and dispute states are separate. Use the available next action for the current authoritative state.',
  'Delivery coordination': 'Review the accepted delivery assignment and coordination actions. Assignment changes retain existing permissions and history.',
  'Delivery directions': 'Directions and driving estimates use the confirmed endpoints. They do not show live vehicle GPS.',
}

export type VendorPracticeKind = 'products' | 'vehicles' | 'invoices' | 'tracking'
export const practiceLabels: Record<VendorPracticeKind, string> = { products: 'Practice adding a product', vehicles: 'Practice adding a vehicle', invoices: 'Practice E-Invoices', tracking: 'Practice Team Tracking' }
