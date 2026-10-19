import { checklistProgress, checklistStatus, verificationChecklist } from '@materyalph/web-ui'
import { VendorOnboardingStepFromJSON, VendorOnboardingStepToJSON } from '@materyalph/api-client-ts'
import { expect, test } from 'vitest'

test('saved completion counts independently of the Admin decision and address is separate', () => {
  const steps = ['business_information', 'registered_business_address', 'supplier_classification'].map(key => ({ key, label: key, level: 'REQUIRED', status: 'NOT_STARTED', progressStatus: 'COMPLETED' }))
  const items = verificationChecklist(steps)
  expect(items.map(item => item.key)).toEqual(['business_information_group', 'registered_business_address', 'supplier_classification'])
  expect(items.every(item => item.status === 'NOT_STARTED')).toBe(true)
  expect(checklistProgress({ key: 'STORE_VERIFICATION', steps })).toEqual({ total: 3, complete: 3 })
})

test('partially completed groups show in progress and conditional omissions do not inflate totals', () => {
  expect(checklistStatus([{ key: 'a', label: 'a', level: 'REQUIRED', status: 'COMPLETED' }, { key: 'b', label: 'b', level: 'REQUIRED', status: 'NOT_STARTED' }])).toBe('IN_PROGRESS')
  const steps = [{ key: 'identity_evidence', label: 'ID', level: 'REQUIRED', status: 'NOT_STARTED', progressStatus: 'COMPLETED' }, { key: 'representative_identity', label: 'Representative', level: 'CONDITIONALLY_REQUIRED', status: 'NOT_STARTED', progressStatus: 'NOT_APPLICABLE' }]
  expect(checklistProgress({ key: 'STORE_VERIFICATION', steps })).toEqual({ total: 1, complete: 1 })
})

test('the generated client preserves saved completion separately from review status', () => {
  const wire = { id: 'address', key: 'registered_business_address', label: 'Registered business address', level: 'REQUIRED', status: 'NOT_STARTED', progress_status: 'COMPLETED', lock_version: 1 }
  const step = VendorOnboardingStepFromJSON(wire)
  expect(step).toMatchObject({ status: 'NOT_STARTED', progressStatus: 'COMPLETED' })
  expect(VendorOnboardingStepToJSON(step)).toMatchObject(wire)
  expect(VendorOnboardingStepFromJSON({ ...wire, progress_status: undefined }).progressStatus).toBeUndefined()
})
