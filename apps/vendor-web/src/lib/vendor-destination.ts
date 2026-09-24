import type { VendorOnboardingSnapshot } from './onboarding-api'

export function vendorLoginDestination(snapshot: VendorOnboardingSnapshot): string {
  if (snapshot.welcomeRequired) return '/welcome'
  if (snapshot.activation.status === 'ACTIVE') return '/dashboard'
  if (!snapshot.permissions.includes('vendor.onboarding.manage')) return '/dashboard'
  if (snapshot.setup.status === 'COMPLETED') return '/dashboard'
  if (['SUBMITTED', 'PENDING_VERIFICATION', 'APPROVED'].includes(String(snapshot.verification.status))) return '/onboarding/setup'
  return '/onboarding/verification'
}
