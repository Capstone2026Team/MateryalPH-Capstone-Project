import { useCallback, useEffect, useRef, useState } from 'react'
import { Button, VersionedAgreementPanel, StatusMessage, formatManilaDateTime, useCommissionPolicyClock } from '@materyalph/web-ui'
import { acceptVendorCommission, getVendorOnboarding, readableOnboardingError, type VendorOnboardingSnapshot } from '../lib/onboarding-api'

const record = (value: unknown): Record<string, unknown> => typeof value === 'object' && value !== null && !Array.isArray(value) ? value as Record<string, unknown> : {}
const number = (value: unknown, fallback = 0) => typeof value === 'number' && Number.isFinite(value) ? value : fallback
const text = (value: unknown) => typeof value === 'string' ? value : ''

/** One version-bound acceptance flow for initial verification and the Finance dialog. */
export function CommissionTerms({ snapshot, onSaved, disabled = false, onBusyChange }: {
  snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; disabled?: boolean; onBusyChange?: (busy: boolean) => void
}) {
  const [latest, setLatest] = useState(snapshot)
  const refreshGeneration = useRef(0)
  const invalidateRefresh = useCallback(() => { refreshGeneration.current++ }, [])
  useEffect(() => { invalidateRefresh(); setLatest(snapshot); return invalidateRefresh }, [snapshot, invalidateRefresh])
  const verification = record(latest.verification)
  const terms = record(verification.commissionTerms ?? verification.commission_terms)
  const agreement = record(terms.agreement)
  const upcoming = record(terms.upcoming)
  const organization = record(latest.organization)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  async function refreshTerms() {
    const generation = ++refreshGeneration.current
    try {
      const fresh = await getVendorOnboarding()
      if (generation === refreshGeneration.current) { setLatest(fresh); setError('') }
    } catch (cause) { if (generation === refreshGeneration.current) setError(await readableOnboardingError(cause)) }
  }
  // Keep only this terms reader current; do not replace the parent's unsaved onboarding fields.
  useCommissionPolicyClock(text(upcoming.effectiveFrom ?? upcoming.effective_from), () => { if (!busy) void refreshTerms() })
  async function accept() {
    invalidateRefresh()
    setBusy(true); onBusyChange?.(true); setError('')
    try { onSaved(await acceptVendorCommission({ organizationLockVersion: number(organization.lockVersion ?? organization.lock_version, 1), agreementVersionId: text(agreement.id), accepted: true })) }
    catch (cause) { setError(await readableOnboardingError(cause)) }
    finally { setBusy(false); onBusyChange?.(false) }
  }
  return <VersionedAgreementPanel key={text(agreement.id)} title="Commission Terms" version={number(agreement.version)} content={text(agreement.content)} accepted={terms.accepted === true} eligible={(terms.canAccept ?? terms.can_accept) === true} busy={busy || disabled} error={error} onAccept={() => void accept()}>
    {error && <Button variant="secondary" disabled={busy} onClick={() => void refreshTerms()}>Refresh terms</Button>}
    {text(upcoming.id) && <StatusMessage tone="info">Upcoming change effective {formatManilaDateTime(text(upcoming.effectiveFrom ?? upcoming.effective_from))}: {text(upcoming.rateLabel ?? upcoming.rate_label)}. <a className="underline" href={`/commission-terms?policy=${text(upcoming.id)}`} target="_blank" rel="noreferrer">Read upcoming terms<span className="sr-only"> (opens in a new tab)</span></a></StatusMessage>}
    <p className="max-w-3xl text-sm leading-6 text-text-secondary">A versioned agreement for the Vendor-paid commission on completed materials. Review the full terms before accepting for your organization.</p>
    <dl className="grid gap-4 sm:grid-cols-2">
      {[["Commission base", "The percentage in this version applies to completed materials after Vendor discounts, excluding included materials VAT. Earlier transactions keep their original rate."], ["Monthly collection", "Collected monthly, with VAT-inclusive commission fee treatment where applicable."], ["Credits and disputes", "Cancellation and partial-refund credits, statement due dates, and the dispute process follow the versioned terms."], ["Authorized acceptance", "The Vendor Owner must accept. Where representative authority is required, current Admin-approved COMMISSION_AGREEMENT authority is also required."]].map(([label, detail]) => <div key={label} className="rounded-control border border-border-default p-4"><dt className="text-sm font-semibold">{label}</dt><dd className="mt-2 text-sm leading-6 text-text-secondary">{detail}</dd></div>)}
    </dl>
    <p className="rounded-control bg-surface-canvas p-4 text-sm leading-6">Changing settings never adds a fee to an already accepted order.</p>
  </VersionedAgreementPanel>
}
