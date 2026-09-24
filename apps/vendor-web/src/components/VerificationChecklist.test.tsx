import { expect, test } from 'vitest'
import { verificationChecklist, type ChecklistRequirement } from '@materyalph/web-ui'

const item = (key: string, status: string): ChecklistRequirement => ({ key, status, label: key, level: 'REQUIRED' })
test('one ID includes both sides and stays incomplete when its back needs correction', () => {
  const groups = verificationChecklist([item('identity_evidence', 'APPROVED'), item('identity_back_evidence', 'CHANGES_REQUIRED')])
  expect(groups).toHaveLength(1)
  expect(groups[0]).toMatchObject({ key: 'legal_identity_id', status: 'CHANGES_REQUIRED' })
  expect(groups[0]?.requirements.map(value => value.key)).toEqual(['identity_evidence', 'identity_back_evidence'])
})
test('business information retains authority and unknown required gates while omitting inactive and optional items', () => {
  const groups = verificationChecklist([item('business_information', 'APPROVED'), item('authority_to_act', 'PENDING_VERIFICATION'), item('future_required_gate', 'NOT_STARTED'), item('representative_identity', 'NOT_APPLICABLE'), { ...item('optional_certification', 'NOT_STARTED'), level: 'OPTIONAL' }])
  expect(groups).toHaveLength(1)
  expect(groups[0]?.requirements.map(value => value.key)).toEqual(['business_information', 'authority_to_act', 'future_required_gate'])
  expect(groups[0]?.status).not.toBe('COMPLETED')
})
test('passport identity page can complete without a non-applicable back', () => {
  const groups = verificationChecklist([item('identity_evidence', 'APPROVED'), item('identity_back_evidence', 'NOT_APPLICABLE')])
  expect(groups[0]).toMatchObject({ status: 'COMPLETED' })
  expect(groups[0]?.requirements).toHaveLength(1)
})
test('document groups follow the same order regardless of server ordering', () => {
  const groups = verificationChecklist(['lgu_permit', 'business_registration', 'bir_cor', 'tax_relief_evidence', 'representative_identity', 'identity_evidence', 'business_information'].map(key => item(key, 'PENDING_VERIFICATION')))
  expect(groups.map(group => group.key)).toEqual(['business_information_group', 'legal_identity_id', 'representative_id', 'tax_relief_evidence', 'bir_cor', 'business_registration', 'lgu_permit'])
})

test('grouped checklist retains actionable correction messages on the dashboard', () => {
  const groups = verificationChecklist([{ ...item('identity_back_evidence', 'CHANGES_REQUIRED'), reason: 'Upload a clear back image.' }])
  expect(groups[0]?.reason).toContain('Upload a clear back image.')
})
