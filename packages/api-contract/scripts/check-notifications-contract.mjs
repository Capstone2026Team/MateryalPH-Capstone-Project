import assert from 'node:assert/strict'
import fs from 'node:fs'
import YAML from 'yaml'

const spec = YAML.parse(fs.readFileSync(new URL('../openapi.yaml', import.meta.url), 'utf8'))
for (const path of ['/{audience}/notifications', '/{audience}/notifications/preferences', '/{audience}/notifications/devices', '/{audience}/notifications/{noticeId}/resolve', '/{audience}/reports', '/{audience}/reports/{exportId}/download', '/admin/reports/tax', '/admin/reports/tax/{packageId}/review', '/admin/notifications/failures']) {
  assert.ok(spec.paths[path], path)
  for (const method of Object.values(spec.paths[path])) assert.ok(method.security?.length, `${path} must authenticate`)
}
for (const path of ['/{audience}/reports', '/admin/reports/tax']) assert.ok(spec.paths[path].post.parameters.some(p => p.name === 'Idempotency-Key' && p.required))
assert.equal(spec.components.schemas.NotificationDeviceInput.properties.token.writeOnly, true)
assert.deepEqual(spec.components.schemas.DocumentExportInput.properties.format.enum, ['PDF', 'CSV'])
assert.equal(spec.components.schemas.TaxPackageInput.properties.form.enum.length, 6)
assert.ok(spec.components.schemas.TaxPackageReview.required.includes('due_date_source'))
assert.ok(spec.components.schemas.TaxPackageReview.required.includes('actual_due_date'))
for (const language of ['typescript', 'dart']) {
  const path = language === 'typescript' ? 'src/apis/NotificationsApi.ts' : 'lib/src/api/notifications_api.dart'
  assert.ok(fs.existsSync(new URL(`../generated/${language}/${path}`, import.meta.url)))
}
console.log('Phase 15 notification, export and tax contract checks passed.')
const navigation = spec.paths['/vendor/navigation-updates'].get
const sharedNavigation = spec.paths['/{audience}/navigation-updates'].get
assert.equal(sharedNavigation.operationId, 'getNavigationUpdates')
assert.deepEqual(sharedNavigation.parameters.find(value => value.name === 'audience').schema.enum, ['buyers', 'vendor', 'admin'])
assert.ok(sharedNavigation.security.some(value => value.passportBearer))
assert.ok(sharedNavigation.security.some(value => value.accessCookie && value.webCsrf))
assert.equal(spec.components.schemas.NavigationUpdates.properties.sections.additionalProperties.minimum, 0)
assert.equal(spec.components.schemas.NavigationUpdates.properties.cart_quantity.type, 'string')
assert.equal(spec.components.schemas.NavigationUpdates.properties.cart_version.minimum, 0)
for (const language of ['typescript', 'dart']) {
  const path = language === 'typescript' ? 'src/apis/NotificationsApi.ts' : 'lib/src/api/notifications_api.dart'
  assert.ok(fs.readFileSync(new URL(`../generated/${language}/${path}`, import.meta.url), 'utf8').includes('getNavigationUpdates'))
}
assert.equal(navigation.operationId, 'getVendorNavigationUpdates')
assert.ok(navigation.security?.length)
assert.equal(navigation.responses['200'].content['application/json'].schema.properties.data.$ref, '#/components/schemas/VendorNavigationUpdates')
assert.equal(spec.components.schemas.VendorNavigationUpdates.properties.sections.additionalProperties.minimum, 0)
for (const language of ['typescript', 'dart']) {
  const path = language === 'typescript' ? 'src/apis/NotificationsApi.ts' : 'lib/src/api/notifications_api.dart'
  assert.ok(fs.readFileSync(new URL(`../generated/${language}/${path}`, import.meta.url), 'utf8').includes('getVendorNavigationUpdates'))
}
console.log('Vendor navigation update contract checks passed.')
const bulkRead = spec.paths['/{audience}/notifications/read-all'].post
assert.equal(bulkRead.operationId, 'markNotificationsRead')
assert.ok(bulkRead.security?.length)
assert.equal(bulkRead.requestBody.content['application/json'].schema.$ref, '#/components/schemas/NotificationReadFilter')
assert.deepEqual(spec.components.schemas.NotificationReadFilter.required, ['through_id'])
assert.equal(spec.components.schemas.NotificationReadFilter.properties.through_id.format, 'uuid')
assert.equal(spec.components.schemas.NotificationReadFilter.properties.category.maxLength, 64)
assert.equal(spec.components.schemas.NotificationReadFilter.properties.category.enum, undefined)
assert.equal(spec.components.schemas.NotificationReadFilter.properties.title.deprecated, true)
assert.equal(spec.components.schemas.NotificationBulkReadAction.properties.read_count.minimum, 0)
for (const language of ['typescript', 'dart']) {
  const path = language === 'typescript' ? 'src/apis/NotificationsApi.ts' : 'lib/src/api/notifications_api.dart'
  assert.ok(fs.readFileSync(new URL(`../generated/${language}/${path}`, import.meta.url), 'utf8').includes('markNotificationsRead'))
  const modelPath = language === 'typescript' ? 'src/models/NotificationReadFilter.ts' : 'lib/src/model/notification_read_filter.dart'
  assert.ok(fs.readFileSync(new URL(`../generated/${language}/${modelPath}`, import.meta.url), 'utf8').includes('category'))
}
console.log('Filtered notification read contract checks passed.')
for (const [path, method, operation] of [['unread-count', 'get', 'getNotificationUnreadCount'], ['realtime', 'get', 'getNotificationRealtime'], ['auth', 'post', 'authorizeNotificationChannel']]) {
  const endpoint = spec.paths[`/{audience}/notifications/${path}`][method]
  assert.equal(endpoint.operationId, operation)
  assert.ok(endpoint.security.some(value => value.passportBearer))
  assert.ok(endpoint.security.some(value => value.accessCookie && value.webCsrf))
  assert.deepEqual(endpoint.parameters.find(value => value.name === 'audience').schema.enum, ['buyers', 'vendor', 'admin'])
  for (const language of ['typescript', 'dart']) {
    const apiPath = language === 'typescript' ? 'src/apis/NotificationsApi.ts' : 'lib/src/api/notifications_api.dart'
    assert.ok(fs.readFileSync(new URL(`../generated/${language}/${apiPath}`, import.meta.url), 'utf8').includes(operation))
  }
}
assert.equal(spec.components.schemas.NotificationUnreadCount.properties.unread_count.minimum, 0)
assert.deepEqual(spec.components.schemas.NotificationChannelAuthResponse.required, ['data', 'meta', 'errors'])
console.log('Cross-surface private notification realtime and unread badge contracts passed.')
const reportFilters = spec.paths['/{audience}/reports'].get.parameters
assert.equal(reportFilters.find(value => value.name === 'resource_id').schema.format, 'uuid')
assert.deepEqual(reportFilters.find(value => value.name === 'format').schema.enum, ['PDF', 'CSV'])
assert.ok(reportFilters.find(value => value.name === 'type').schema.enum.includes('EARNINGS'))
assert.ok(spec.components.schemas.DocumentExportInput.properties.type.enum.includes('TRANSACTION_HISTORY'))
assert.equal(spec.components.schemas.DocumentExport.properties.resource_id.format, 'uuid')
for (const language of ['typescript', 'dart']) {
  const apiPath = language === 'typescript' ? 'src/apis/ReportingApi.ts' : 'lib/src/api/reporting_api.dart'
  const client = fs.readFileSync(new URL(`../generated/${language}/${apiPath}`, import.meta.url), 'utf8')
  assert.ok(client.includes('resourceId'))
  assert.ok(client.includes("'format'"))
}
console.log('Contextual PDF export history and Owner finance report contracts passed.')

const sendMessage = spec.paths['/{messagingPortal}/conversations/{conversationId}/messages'].post
assert.match(sendMessage.description, /atomically records one MESSAGES notification/)
assert.match(sendMessage.description, /client_message_id does not duplicate/)
assert.match(sendMessage.description, /public sender and store identity and a bounded message preview/)
assert.match(spec.components.schemas.NotificationItem.properties.title.description, /public sender display name and store name/)
assert.match(spec.components.schemas.NotificationItem.properties.body.description, /320 display characters/)
assert.match(spec.paths['/{messagingPortal}/conversations/{conversationId}/read'].post.description, /later arrivals remain unread/)
assert.match(spec.paths['/{messagingPortal}/conversations/{conversationId}/attachments'].post.description, /MESSAGES notification/)
assert.match(spec.paths['/{audience}/notifications/{noticeId}/resolve'].post.description, /\/messages\/\{conversationId\}/)
assert.match(spec.components.schemas.NotificationPreference.description, /email defaults to disabled/)
assert.match(spec.components.schemas.NotificationPreferenceInput.properties.category.description, /SALES and FULFILLMENT/)
console.log('Vendor-to-Buyer message notification contract checks passed.')
