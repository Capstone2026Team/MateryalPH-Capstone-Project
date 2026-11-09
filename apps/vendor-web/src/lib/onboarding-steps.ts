import type { VendorOnboardingSection } from '@materyalph/api-client-ts'

export type OnboardingStep = { label: string; requirements: string[]; key?: string }

export const verificationSteps: OnboardingStep[] = [
  { label: 'Business Information', requirements: ['business_type', 'business_information', 'legal_identity', 'business_registration', 'lgu_permit', 'bir_cor', 'identity_evidence', 'identity_back_evidence', 'representative_identity', 'representative_identity_back', 'tax_profile', 'tax_relief_evidence', 'authority_to_act'] },
  { label: 'Registered Business Address', requirements: ['registered_business_address'] },
  { label: 'Supplier Type / Classification', requirements: ['supplier_classification'] },
  { label: 'Privacy, Review and Submit', requirements: ['commission_terms', 'privacy_acknowledgement'] },
]

export const setupSteps: OnboardingStep[] = [
  { key: 'S1', label: 'Public Store Profile', requirements: ['public_store_profile', 'store_media'] },
  { key: 'S2', label: 'Fulfillment Configuration', requirements: ['bulk_capability', 'fulfillment_method', 'delivery_configuration'] },
  { key: 'S3', label: 'Xendit TEST Connection', requirements: ['payment_connection'] },
  { key: 'S5', label: 'Store Operation', requirements: ['store_operation'] },
  { key: 'S6', label: 'Review and Complete', requirements: [] },
]

/** Resume actionable corrections first, then the first unfinished saved requirement. */
export function resumeOnboardingStep(steps: OnboardingStep[], section: VendorOnboardingSection): number {
  const required = section.steps.filter(item => item.level !== 'OPTIONAL' && item.status !== 'NOT_APPLICABLE' && item.progressStatus !== 'NOT_APPLICABLE')
  if (!required.length) return 0
  const correction = required.find(item => ['CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'].includes(item.status))
  const unfinished = correction ?? required.find(item => !['COMPLETED', 'APPROVED'].includes(item.progressStatus ?? item.status))
  return unfinished ? Math.max(0, steps.findIndex(step => step.requirements.includes(unfinished.key))) : steps.length - 1
}

/** Retain existing S5/S6 deep links; former optional-team links open fulfillment guidance. */
export function setupStepIndex(key: string | null): number {
  return key === 'S4' ? 1 : setupSteps.findIndex(step => step.key === key)
}

