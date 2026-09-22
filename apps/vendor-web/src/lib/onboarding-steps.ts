export type OnboardingStep = { label: string; requirements: string[] }

export const verificationSteps: OnboardingStep[] = [
  { label: 'Business Information', requirements: ['business_type', 'business_information', 'legal_identity', 'business_registration', 'lgu_permit', 'bir_cor', 'identity_evidence', 'identity_back_evidence', 'representative_identity', 'representative_identity_back', 'tax_profile', 'tax_relief_evidence', 'authority_to_act'] },
  { label: 'Registered Business Address', requirements: ['registered_business_address'] },
  { label: 'Supplier Type / Classification', requirements: ['supplier_classification'] },
  { label: 'Privacy, Review and Submit', requirements: ['privacy_acknowledgement'] },
]

export const setupSteps: OnboardingStep[] = [
  { label: 'Public Store Profile', requirements: ['public_store_profile', 'store_media'] },
  { label: 'Fulfillment Configuration', requirements: ['bulk_capability', 'fulfillment_method', 'delivery_configuration'] },
  { label: 'Xendit TEST Connection', requirements: ['payment_connection'] },
  { label: '2% Commission Terms', requirements: ['commission_terms'] },
  { label: 'Team Accounts', requirements: ['team'] },
  { label: 'Review and Complete', requirements: [] },
]

