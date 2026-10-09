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
console.log('Filtered notification read and archive contract checks passed.')
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
