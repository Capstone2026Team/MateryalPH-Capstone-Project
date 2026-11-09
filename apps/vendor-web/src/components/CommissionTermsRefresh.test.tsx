import { act, render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { CommissionTerms } from './CommissionTerms'
import { getVendorOnboarding, type VendorOnboardingSnapshot } from '../lib/onboarding-api'

vi.mock('../lib/onboarding-api', () => ({ getVendorOnboarding: vi.fn(), acceptVendorCommission: vi.fn(), readableOnboardingError: vi.fn() }))
afterEach(() => { vi.useRealTimers(); vi.clearAllMocks() })

test('an open consent reader switches terms at the effective time without replacing unsaved parent fields', async () => {
  vi.useFakeTimers()
  const snapshot: VendorOnboardingSnapshot = {
    lockVersion: 1, stepCompletion: [], requirements: [], drafts: [], organization: { lockVersion: 1 }, sections: {}, setup: {}, permissions: [], welcomeRequired: false,
    activation: { status: 'IN_PROGRESS', marketplaceDiscoverabilityStatus: 'HIDDEN', readiness: { ready: false, status: 'NOT_READY', ruleVersion: 'test', blockers: [] } },
    verification: { commissionTerms: { accepted: true, canAccept: true, agreement: { id: 'terms-1', version: 1, content: 'Original published terms' },
      upcoming: { id: 'policy-2', effectiveFrom: new Date(Date.now() + 1000).toISOString(), rateLabel: '3.00%' } } },
  }
  vi.mocked(getVendorOnboarding).mockResolvedValue({ ...snapshot, verification: { commissionTerms: { accepted: false, canAccept: true, agreement: { id: 'terms-2', version: 2, content: 'New published terms' } } } })
  const saved = vi.fn()
  await act(async () => { render(<CommissionTerms snapshot={snapshot} onSaved={saved} />) })
  expect(screen.getByText('Current commission terms accepted for this organization.')).toBeVisible()
  await act(async () => { vi.advanceTimersByTime(1100) })
  expect(getVendorOnboarding).toHaveBeenCalledTimes(1)
  expect(screen.getByText(/Version 2 · Vendor-paid commission/)).toBeVisible()
  expect(screen.getByRole('checkbox')).not.toBeChecked()
  expect(screen.getByRole('checkbox')).toBeDisabled()
  expect(saved).not.toHaveBeenCalled()
})
