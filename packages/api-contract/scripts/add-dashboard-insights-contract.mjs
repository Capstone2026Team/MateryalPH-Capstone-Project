import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Dashboard insights contract: the read-only Vendor and Admin dashboard bundles (charts, KPI deltas, forecasts, K-Means
// segments, DBSCAN outliers, Apriori rules and the workflow-threshold Vendor class). Every section a role cannot see is
// null, never a redacted copy; peso values are Owner-only on the Vendor side; Admin marketplace data comes from the
// disclosure-controlled geographic read model. Idempotent: rerunning replaces the dashboard insights block.
const file = new URL('../openapi.yaml', import.meta.url);
const original = readFileSync(file, 'utf8');
const crlf = original.includes('\r\n');
let source = original.replace(/\r\n/g, '\n');
const ref = name => ({ $ref: `#/components/schemas/${name}` });
const str = { type: 'string' }, uuid = { type: 'string', format: 'uuid' }, int = { type: 'integer' }, num = { type: 'number' }, bool = { type: 'boolean' }, dt = { type: 'string', format: 'date-time' }, date = { type: 'string', format: 'date' };
const NULLABLE = new WeakSet();
const nullable = schema => {
  const out = schema.$ref ? { oneOf: [schema, { type: 'null' }] } : { ...schema, type: [schema.type, 'null'], ...(schema.enum ? { enum: [...schema.enum, null] } : {}) };
  NULLABLE.add(out);
  return out;
};
const arr = items => ({ type: 'array', items });
const enumOf = (...values) => ({ type: 'string', enum: values });
const obj = (properties, description) => ({ type: 'object', required: Object.keys(properties).filter(key => !NULLABLE.has(properties[key])), properties, ...(description ? { description } : {}) });
const stringMap = { type: 'object', additionalProperties: { type: 'string' } };
const percent = nullable({ type: 'string', pattern: '^\\d{1,3}\\.\\d{2}$' });
const count = obj({ key: str, count: int });
const VENDOR = 'Vendor Dashboard';
const ADMIN = 'Admin Dashboard';

const schemas = {
  DashboardCount: count,
  DashboardRate: obj({ percent, numerator: int, denominator: int }, 'A rate with its numerator and denominator; percent is null when the denominator is zero.'),
  DashboardDelta: obj({ value: int, previous: int, change_percent: nullable(num) }, 'The period value and the equal-length period before it.'),
  DashboardResponseTime: obj({ mean_seconds: nullable(int), median_seconds: nullable(int), p90_seconds: nullable(int), answered: int, unanswered: int }),
  DashboardForecastPoint: obj({ date, value: num, lower: num, upper: num }),
  DashboardAnomaly: obj({ date, value: num, expected: num, deviation: num }, 'A day more than three residual standard deviations from its fitted value.'),
  DashboardForecast: obj({
    state: enumOf('OK', 'INSUFFICIENT_DATA'), observed_days: int, direction: enumOf('INCREASING', 'DECREASING', 'FLAT', 'UNKNOWN'), change_percent: nullable(num), r_squared: nullable(num),
    weekday_strength: nullable(num), expected_total: nullable(num), points: arr(ref('DashboardForecastPoint')), anomalies: arr(ref('DashboardAnomaly')),
  }, 'Least-squares trend plus a weekday pattern with a 95% prediction band. A planning estimate only; INSUFFICIENT_DATA below seven active days. Money forecasts are integer centavos.'),
  DashboardRule: obj({ antecedent: arr(str), consequent: arr(str), support: num, support_count: int, confidence: num, lift: num },
    'Apriori association rule: items ordered together more often than chance (lift above 1). Co-occurrence, not causation.'),
  DashboardAction: obj({ key: enumOf('ORDER_CONFIRMATION', 'FULFILLMENT_OVERDUE', 'FULFILLMENT_DUE_TODAY', 'ASSIGNED_FULFILLMENT', 'DISPUTE_RESPONSE', 'OUT_OF_STOCK', 'LIMITED_STOCK'),
    label: str, count: int, severity: enumOf('ACTION', 'ALERT'), href: str, detail: nullable(str) }, 'Work waiting for this role; present only when the role may act on it.'),
  DashboardClassification: obj({ class: enumOf('BUILDING_TRACK_RECORD', 'BELOW_WATCH_LEVEL', 'WATCH', 'HEALTHY'), label: str, path: arr(str),
    bands: { type: 'object', additionalProperties: enumOf('NONE', 'LOW', 'MEDIUM', 'HIGH') } }, 'Fixed decision tree over the System Workflow thresholds. An indicator only: it changes no score, badge, ranking or sanction.'),

  VendorDashboardSeriesPoint: obj({ date, orders: int, order_requests: int, orders_average: nullable(num), gross_sales_centavos: nullable(int), net_sales_centavos: nullable(int), sales_average_centavos: nullable(int) }),
  VendorDashboardProduct: obj({ name: str, category: str, orders: int, buyers: int, value_centavos: nullable(int) }),
  VendorDashboardSegment: obj({ id: int, label: str, size: int, average_orders: num, average_buyers: num, average_value_centavos: nullable(int), examples: arr(str) }),
  VendorDashboardOrders: obj({
    kpis: obj({ order_volume: ref('DashboardDelta'), gross_sales_centavos: nullable(ref('DashboardDelta')), net_sales_centavos: nullable(ref('DashboardDelta')),
      average_order_value_centavos: nullable({ type: 'object', required: [], properties: { value: nullable(int), previous: nullable(int) } }),
      fulfillment_rate: ref('DashboardRate'), cancellation_rate: ref('DashboardRate'), dispute_rate: ref('DashboardRate'), response_time: ref('DashboardResponseTime') }),
    series: arr(ref('VendorDashboardSeriesPoint')),
    forecast: obj({ horizon_days: int, orders: ref('DashboardForecast'), sales: nullable(ref('DashboardForecast')) }),
    pipeline: arr(obj({ state: str, count: int })),
    incoming: arr(obj({ order_id: uuid, reference: str, procurement_type: enumOf('ITEM_BASED', 'PROJECT_BASED'), fulfillment_method: enumOf('DELIVERY', 'PICKUP'), line_count: int, total_centavos: int, submitted_at: nullable(dt), due_at: nullable(dt) })),
    funnel: arr(obj({ key: enumOf('INQUIRIES', 'QUOTATIONS', 'ORDER_REQUESTS', 'CONFIRMED', 'COMPLETED'), label: str, count: int })),
    mix: obj({ procurement: arr(ref('DashboardCount')), fulfillment: arr(ref('DashboardCount')), payment: arr(ref('DashboardCount')) }),
    products: obj({
      top: arr(ref('VendorDashboardProduct')), categories: arr(obj({ category: str, orders: int, value_centavos: nullable(int) })),
      segments: obj({ state: enumOf('OK', 'INSUFFICIENT_DATA'), reason: nullable(str), k: nullable(int), silhouette: nullable(num), features: arr(str), segments: arr(ref('VendorDashboardSegment')),
        points: arr(obj({ name: str, orders: int, buyers: int, segment: str })) }, 'K-Means demand groups of the store’s own products.'),
      basket_rules: obj({ baskets: int, rules: arr(ref('DashboardRule')), window_days: int }, 'Co-ordered materials in the last 90 days across at least two distinct Buyers.'),
    }),
    unusual_days: obj({ state: enumOf('OK', 'INSUFFICIENT_DATA'), epsilon: nullable(num), days: arr(obj({ date, orders: int, gross_sales_centavos: nullable(int) })) }, 'DBSCAN noise points among the store’s active days.'),
  }, 'Store-wide order measures (orders.confirm). Peso fields are null unless the caller holds finance.view (Owner).'),
  VendorDashboardPerformance: obj({ calculated: bool, as_of: nullable(date), label: str, scores: arr(ref('ScoreMetric')), badge_metrics: arr(ref('BadgeMetric')),
    operations: nullable({ type: 'object', additionalProperties: true }), history: arr(ref('ScoreHistoryPoint')), classification: ref('DashboardClassification'), badges: arr(ref('BadgeState')) },
  'scores.view_store (Owner and Store Manager). The Score service values; no second formula.'),
  VendorDashboardStock: obj({ variants: int, in_stock: int, limited_stock: int, out_of_stock: int,
    attention: arr(obj({ name: str, variant: nullable(str), available: str, reorder_level: nullable(str), status: enumOf('OUT_OF_STOCK', 'LIMITED_STOCK') })) }, 'inventory.view. The store’s own stock only.'),
  VendorDashboardDisputes: obj({ open: int, awaiting_response: int, next_response_due_at: nullable(dt), filed_in_period: int, series: arr(obj({ date, cases: int })),
    issue_types: arr(ref('DashboardCount')), statuses: arr(ref('DashboardCount')), fulfillment_issues: int, validated_returns: int }, 'portal.disputes.'),
  VendorDashboardInsights: obj({
    generated_at: dt, period: obj({ days: { type: 'integer', enum: [7, 30, 90] }, from: date, to: date, timezone: str }),
    access: obj({ orders: bool, sales_value: bool, performance: bool, stock: bool, disputes: bool, assigned_fulfillment: bool }),
    definitions: stringMap, orders: nullable(ref('VendorDashboardOrders')), performance: nullable(ref('VendorDashboardPerformance')), stock: nullable(ref('VendorDashboardStock')),
    disputes: nullable(ref('VendorDashboardDisputes')), actions: arr(ref('DashboardAction')),
    traffic: obj({ store_visits: obj({ tracked: bool, reason: str }) }, 'Storefront visits are not recorded by the platform, so no visit figure exists. Product views are reported by Vendor Product Analytics.'),
  }),
  VendorDashboardInsightsEnvelope: obj({ data: ref('VendorDashboardInsights'), meta: { type: 'object', additionalProperties: true }, errors: arr({ type: 'object', additionalProperties: true }) }),

  AdminDashboardSeriesPoint: obj({ date, gross_gmv_centavos: nullable(int), net_gmv_centavos: nullable(int), order_volume: nullable(int), suppressed: bool, gross_average_centavos: nullable(int), volume_average: nullable(num) },
    'Suppressed days are gaps (null), never zero.'),
  AdminDashboardActivityPoint: obj({ date, buyer_dau: nullable(int), vendor_dau: nullable(int), buyer_mau: nullable(int), vendor_mau: nullable(int) }),
  AdminDashboardAreaSegment: obj({ id: int, label: str, size: int, average_vendors: num, average_buyers: num, average_orders: num, average_gmv_centavos: int, examples: arr(str) }),
  AdminDashboardAreas: obj({ children_label: str, considered: int, excluded_suppressed: int, features: arr(str), state: enumOf('OK', 'INSUFFICIENT_DATA'), reason: nullable(str), k: nullable(int), silhouette: nullable(num),
    segments: arr(ref('AdminDashboardAreaSegment')), unusual: arr(obj({ code: str, name: str, vendors: int, orders: int, gmv_centavos: int })),
    recruitment: arr(obj({ code: str, name: str, vendors: int, orders: int, orders_per_vendor: num })), points: arr(obj({ name: str, vendors: int, orders: int, segment: str })) },
  'K-Means area segments, DBSCAN unusual areas and recruitment signals over child areas without a suppressed cell.'),
  AdminDashboardCategories: obj({ demand: arr(obj({ category: str, orders: int })), suppressed_categories: int, rules: arr(ref('DashboardRule')), baskets: int, minimum_buyers: int },
    'Category demand and Apriori rules; a category or rule needs at least minimum_buyers distinct Buyers.'),
  AdminDashboardMarketplace: obj({
    scope: ref('GeoScope'), dataset: ref('GeoDataset'), period: obj({ from: date, to: date, granularity: enumOf('DAY', 'WEEK', 'MONTH'), days: { type: 'integer', enum: [30, 90] } }),
    disclosure: obj({ minimum_persons: int, method: enumOf('ROLL_UP_TO_PARENT'), description: str }), kpis: ref('GeoKpis'), series: arr(ref('AdminDashboardSeriesPoint')),
    forecast: obj({ horizon_days: int, gross_gmv: ref('DashboardForecast'), order_volume: ref('DashboardForecast') }), activity: arr(ref('AdminDashboardActivityPoint')),
    areas: ref('AdminDashboardAreas'), categories: ref('AdminDashboardCategories'),
  }, 'analytics.view_aggregates. Built from the disclosure-controlled geographic read model.'),
  AdminDashboardVendorHealth: obj({
    total: int, classes: arr(obj({ key: enumOf('HEALTHY', 'WATCH', 'BELOW_WATCH_LEVEL', 'BUILDING_TRACK_RECORD'), label: str, count: int })),
    attention: arr(obj({ vendor_id: uuid, store_name: str, class: enumOf('BELOW_WATCH_LEVEL', 'WATCH'), label: str, vps: nullable(str), ohs: nullable(str), reasons: arr(str) })),
    segments: obj({ state: enumOf('OK', 'INSUFFICIENT_DATA'), reason: nullable(str), considered: int, features: arr(str), k: nullable(int), silhouette: nullable(num),
      segments: arr(obj({ id: int, label: str, size: int, average_vps: num, average_ohs: num, average_completed_orders: num })) }),
  }, 'scores.view. Indicator classes only; no flag, warning or sanction is created.'),
  AdminDashboardInsights: obj({ generated_at: dt, access: obj({ marketplace: bool, vendor_health: bool }), definitions: stringMap, marketplace: nullable(ref('AdminDashboardMarketplace')),
    marketplace_unavailable_reason: nullable(str), vendor_health: nullable(ref('AdminDashboardVendorHealth')) }),
  AdminDashboardInsightsEnvelope: obj({ data: ref('AdminDashboardInsights'), meta: { type: 'object', additionalProperties: true }, errors: arr({ type: 'object', additionalProperties: true }) }),
};

const errors = codes => Object.fromEntries(codes.map(code => [String(code), { $ref: '#/components/responses/ErrorResponse' }]));
const paths = {
  '/vendor/dashboard/insights': { get: {
    operationId: 'getVendorDashboardInsights', tags: [VENDOR],
    description: 'Any active Vendor member. Sections follow the fixed-role grants: orders.confirm, finance.view (peso values), scores.view_store, inventory.view and portal.disputes; a section without its grant is null. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED.',
    security: [{ accessCookie: [], webCsrf: [] }],
    parameters: [{ name: 'days', in: 'query', required: false, schema: { type: 'integer', enum: [7, 30, 90], default: 30 } }],
    responses: { 200: { description: 'Authorized result.', content: { 'application/json': { schema: ref('VendorDashboardInsightsEnvelope') } } }, ...errors([401, 403, 422]) },
  } },
  '/admin/dashboard/insights': { get: {
    operationId: 'getAdminDashboardInsights', tags: [ADMIN],
    description: 'Any active Admin. marketplace needs analytics.view_aggregates and the geo_analytics flag; vendor_health needs scores.view. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED; no point or radius filter exists.',
    security: [{ accessCookie: [], webCsrf: [] }],
    parameters: [
      { name: 'days', in: 'query', required: false, schema: { type: 'integer', enum: [30, 90], default: 30 } },
      { name: 'dataset', in: 'query', required: false, schema: enumOf('TEST', 'DEMO') },
      { name: 'area', in: 'query', required: false, description: 'Active-version PSGC code; omit for the Philippines.', schema: { type: 'string', pattern: '^[0-9]{10}$' } },
    ],
    responses: { 200: { description: 'Authorized result.', content: { 'application/json': { schema: ref('AdminDashboardInsightsEnvelope') } } }, ...errors([401, 403, 422]) },
  } },
};

source = source.replace(/\n  # Dashboard insights operations[\s\S]*?(?=\n  # Phase 16 admin operations and geographic analytics operations)/, '');
source = source.replace(/\n    # Dashboard insights schemas[\s\S]*?(?=\n    # Phase 16 admin operations and geographic analytics schemas)/, '');
const indent = (value, pad) => YAML.stringify(value, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE', lineWidth: 0 }).split('\n').filter(Boolean).map(line => pad + line).join('\n');
for (const marker of ['\n  # Phase 16 admin operations and geographic analytics operations', '\n    # Phase 16 admin operations and geographic analytics schemas']) {
  if (!source.includes(marker)) throw new Error(`Marker not found: ${marker.trim()}`);
}
source = source.replace('\n  # Phase 16 admin operations and geographic analytics operations', '\n  # Dashboard insights operations\n' + indent(paths, '  ') + '\n  # Phase 16 admin operations and geographic analytics operations');
source = source.replace('\n    # Phase 16 admin operations and geographic analytics schemas', '\n    # Dashboard insights schemas\n' + indent(schemas, '    ') + '\n    # Phase 16 admin operations and geographic analytics schemas');
for (const tag of [ADMIN, VENDOR]) {
  if (!source.includes(`  - name: ${tag}\n`)) source = source.replace('\ntags:\n', `\ntags:\n  - name: ${tag}\n`);
}
writeFileSync(file, crlf ? source.replace(/\n/g, '\r\n') : source);
console.log(`Authored ${Object.keys(paths).length} dashboard insights operations and ${Object.keys(schemas).length} schemas.`);
