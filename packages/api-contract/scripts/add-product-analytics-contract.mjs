import { readFileSync, writeFileSync } from 'node:fs';
import YAML from 'yaml';

// Vendor Product Analytics contract (approved by the project owner on 2026-10-10): product views (one per Buyer per
// listing per Asia/Manila day), view-to-order conversion ranked by the Wilson 95% lower bound, views forecast, K-Means
// product segments, DBSCAN unusual days, Apriori co-ordered products and data-derived suggestions. Needs catalog.manage;
// peso values are Owner-only (finance.view). Reuses the dashboard insight schemas for rates, deltas, forecasts and rules.
// Idempotent: rerunning replaces the product analytics block, which sits just before the dashboard insights block.
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
const TAG = 'Vendor Product Analytics';
const SORTS = ['views', 'orders', 'conversion', 'value'];

const schemas = {
  ProductAnalyticsPeriod: obj({ days: int, from: date, to: date, timezone: str }),
  ProductAnalyticsRow: obj({
    listing_id: uuid, name: str, sku: nullable(str), category: str, status: nullable(str), stock_status: enumOf('IN_STOCK', 'LIMITED_STOCK', 'OUT_OF_STOCK'),
    views: int, previous_views: int, views_change_percent: nullable(num), viewers: int, converted: int, conversion: ref('DashboardRate'), conversion_lower_bound: nullable(num),
    orders: int, previous_orders: int, buyers: int, value_centavos: nullable(int), segment: nullable(str), rank_views: nullable(int), rank_orders: nullable(int),
  }, 'One store product with its period measures. conversion_lower_bound is the Wilson 95% lower bound of converted ÷ viewers. value_centavos is null unless the caller holds finance.view (Owner).'),
  ProductAnalyticsSeriesPoint: obj({ date, views: int, orders: int, value_centavos: nullable(int) }),
  ProductAnalyticsSuggestion: obj({
    key: str, kind: enumOf('RESTOCK_VIEWED', 'REORDER_SOON', 'LOW_CONVERSION', 'CONVERTS_WHEN_FOUND', 'BUNDLE', 'NOT_VIEWED', 'VIEWS_RISING', 'VIEWS_FALLING'),
    priority: enumOf('HIGH', 'MEDIUM', 'LOW'), title: str, detail: str, technique: str, href: str, listing_id: nullable(uuid), product: nullable(str),
  }, 'A planning suggestion from data-derived comparisons with the store’s own products or a level the Vendor set. It changes nothing by itself.'),
  ProductAnalyticsSegments: obj({
    state: enumOf('OK', 'INSUFFICIENT_DATA'), reason: nullable(str), k: nullable(int), silhouette: nullable(num), features: arr(str),
    segments: arr(obj({ id: int, label: str, kind: enumOf('POPULAR_CONVERTING', 'VIEWED_NOT_ORDERED', 'CONVERTS_WHEN_FOUND', 'LOW_VISIBILITY'), size: int, average_views: num, average_conversion_percent: num, average_orders: num, examples: arr(str) })),
    points: arr(obj({ listing_id: uuid, name: str, views: int, conversion_percent: num, orders: int, segment: str })), mean_conversion_percent: nullable(num),
  }, 'K-Means groups over product views, conversion % and orders; names compare each centre with the store average.'),
  ProductAnalyticsTracking: obj({ views_since: nullable(date) }, 'The first Asia/Manila day a product view was recorded for this store; views before it were never collected.'),
  VendorProductAnalytics: obj({
    generated_at: dt, period: ref('ProductAnalyticsPeriod'), access: obj({ sales_value: bool }), definitions: stringMap, tracking: ref('ProductAnalyticsTracking'),
    kpis: obj({ views: ref('DashboardDelta'), viewers: ref('DashboardDelta'), products_viewed: obj({ value: int, total: int }), orders: ref('DashboardDelta'), conversion: ref('DashboardRate'), value_centavos: nullable(ref('DashboardDelta')) }),
    series: arr(ref('ProductAnalyticsSeriesPoint')), forecast: obj({ horizon_days: int, views: ref('DashboardForecast') }),
    top_selling: arr(ref('ProductAnalyticsRow')), top_performing: arr(ref('ProductAnalyticsRow')), most_viewed: arr(ref('ProductAnalyticsRow')),
    categories: arr(obj({ category: str, views: int, orders: int, value_centavos: nullable(int) })), segments: ref('ProductAnalyticsSegments'),
    basket_rules: obj({ baskets: int, rules: arr(ref('DashboardRule')), window_days: int }), suggestions: arr(ref('ProductAnalyticsSuggestion')),
    products: obj({ items: arr(ref('ProductAnalyticsRow')), meta: obj({ page: int, per_page: int, total: int, last_page: int, sort: enumOf(...SORTS) }) }),
  }),
  VendorProductAnalyticsEnvelope: obj({ data: ref('VendorProductAnalytics'), meta: { type: 'object', additionalProperties: true }, errors: arr({ type: 'object', additionalProperties: true }) }),
  VendorProductAnalyticsDetail: obj({
    generated_at: dt, period: ref('ProductAnalyticsPeriod'), access: obj({ sales_value: bool }), definitions: stringMap, tracking: ref('ProductAnalyticsTracking'), product: ref('ProductAnalyticsRow'),
    kpis: obj({ views: ref('DashboardDelta'), viewers: ref('DashboardDelta'), orders: ref('DashboardDelta'), buyers: int, conversion: ref('DashboardRate'), store_conversion: ref('DashboardRate'), value_centavos: nullable(ref('DashboardDelta')), products: int }),
    series: arr(ref('ProductAnalyticsSeriesPoint')), forecast: obj({ horizon_days: int, views: ref('DashboardForecast') }),
    unusual_days: obj({ state: enumOf('OK', 'INSUFFICIENT_DATA'), epsilon: nullable(num), days: arr(obj({ date, views: int, orders: int })) }, 'DBSCAN noise points among the product’s active days.'),
    basket_rules: obj({ baskets: int, rules: arr(ref('DashboardRule')), window_days: int }), suggestions: arr(ref('ProductAnalyticsSuggestion')),
  }),
  VendorProductAnalyticsDetailEnvelope: obj({ data: ref('VendorProductAnalyticsDetail'), meta: { type: 'object', additionalProperties: true }, errors: arr({ type: 'object', additionalProperties: true }) }),
  VendorProductAnalyticsSummaries: obj({
    period: ref('ProductAnalyticsPeriod'),
    items: arr(obj({ listing_id: uuid, views: int, previous_views: int, views_change_percent: nullable(num), viewers: int, orders: int, conversion: ref('DashboardRate'), daily_views: arr(int) })),
  }, 'Compact measures for the My Products list; listings outside the caller’s store are left out.'),
  VendorProductAnalyticsSummariesEnvelope: obj({ data: ref('VendorProductAnalyticsSummaries'), meta: { type: 'object', additionalProperties: true }, errors: arr({ type: 'object', additionalProperties: true }) }),
};

const errors = codes => Object.fromEntries(codes.map(code => [String(code), { $ref: '#/components/responses/ErrorResponse' }]));
const days = { name: 'days', in: 'query', required: false, schema: { type: 'integer', enum: [7, 30, 90], default: 30 } };
const dateParam = name => ({ name, in: 'query', required: false, description: 'Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.', schema: date });
const access = 'Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED.';
const ok = schema => ({ 200: { description: 'Authorized result.', content: { 'application/json': { schema: ref(schema) } } } });
const paths = {
  '/vendor/product-analytics': { get: {
    operationId: 'getVendorProductAnalytics', tags: [TAG], description: `${access} The products table is paginated (20 per page); sort=value falls back to orders without finance.view.`,
    security: [{ accessCookie: [], webCsrf: [] }],
    parameters: [days, dateParam('from'), dateParam('to'), { name: 'sort', in: 'query', required: false, schema: { ...enumOf(...SORTS), default: 'views' } }, { name: 'page', in: 'query', required: false, schema: { type: 'integer', minimum: 1, maximum: 1000, default: 1 } }],
    responses: { ...ok('VendorProductAnalyticsEnvelope'), ...errors([401, 403, 422]) },
  } },
  '/vendor/product-analytics/summaries': { get: {
    operationId: 'getVendorProductAnalyticsSummaries', tags: [TAG], description: `${access} Up to 50 comma-separated listing IDs.`,
    security: [{ accessCookie: [], webCsrf: [] }],
    parameters: [{ name: 'listing_ids', in: 'query', required: true, description: 'Comma-separated listing IDs (at most 50).', schema: { type: 'string', maxLength: 1850 } }, days],
    responses: { ...ok('VendorProductAnalyticsSummariesEnvelope'), ...errors([401, 403, 422]) },
  } },
  '/vendor/product-analytics/listings/{listingId}': { get: {
    operationId: 'getVendorProductAnalyticsDetail', tags: [TAG], description: `${access} A listing outside the caller’s store returns 404 LISTING_NOT_FOUND.`,
    security: [{ accessCookie: [], webCsrf: [] }],
    parameters: [{ name: 'listingId', in: 'path', required: true, schema: uuid }, days, dateParam('from'), dateParam('to')],
    responses: { ...ok('VendorProductAnalyticsDetailEnvelope'), ...errors([401, 403, 404, 422]) },
  } },
};

source = source.replace(/\n  # Product analytics operations[\s\S]*?(?=\n  # Dashboard insights operations)/, '');
source = source.replace(/\n    # Product analytics schemas[\s\S]*?(?=\n    # Dashboard insights schemas)/, '');
const indent = (value, pad) => YAML.stringify(value, { aliasDuplicateObjects: false, defaultStringType: 'QUOTE_DOUBLE', lineWidth: 0 }).split('\n').filter(Boolean).map(line => pad + line).join('\n');
for (const marker of ['\n  # Dashboard insights operations', '\n    # Dashboard insights schemas']) {
  if (!source.includes(marker)) throw new Error(`Marker not found: ${marker.trim()}`);
}
source = source.replace('\n  # Dashboard insights operations', '\n  # Product analytics operations\n' + indent(paths, '  ') + '\n  # Dashboard insights operations');
source = source.replace('\n    # Dashboard insights schemas', '\n    # Product analytics schemas\n' + indent(schemas, '    ') + '\n    # Dashboard insights schemas');
if (!source.includes(`  - name: ${TAG}\n`)) source = source.replace('\ntags:\n', `\ntags:\n  - name: ${TAG}\n`);
writeFileSync(file, crlf ? source.replace(/\n/g, '\r\n') : source);
console.log(`Authored ${Object.keys(paths).length} product analytics operations and ${Object.keys(schemas).length} schemas.`);
