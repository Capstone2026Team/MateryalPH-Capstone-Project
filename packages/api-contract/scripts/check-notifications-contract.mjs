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
