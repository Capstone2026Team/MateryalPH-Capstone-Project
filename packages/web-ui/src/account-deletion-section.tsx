import { useEffect, useId, useRef, useState } from 'react'
import { ArrowUpRight, CircleCheck, CircleHelp, LockKeyhole, RefreshCw, ShieldCheck, Trash2, TriangleAlert } from 'lucide-react'
import { Button, buttonClassName } from './button'
import { Field } from './field'
import { FormDialog } from './form-dialog'
import { StatusMessage } from './status-message'

export type AccountDeletionReview = {
  canDelete: boolean
  confirmationPhrase: string
  retainedRecords: readonly { category: string; purpose: string }[]
  blockers: readonly { key: string; label: string; count: number; description: string; href: string }[]
}

/** Shared review, disclosure and explicit confirmation for permanent account closure. */
export function AccountDeletionSection({ loadReview, deleteAccount, verify, explainError }: {
  loadReview: () => Promise<AccountDeletionReview>
  deleteAccount: (confirmation: string) => Promise<void>
  verify: () => Promise<boolean>
  explainError: (error: unknown) => Promise<string>
}) {
  const [review, setReview] = useState<AccountDeletionReview | null>(null)
  const [loading, setLoading] = useState(true)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [confirming, setConfirming] = useState(false)
  const [confirmation, setConfirmation] = useState('')
  const lock = useRef(false)
  const mounted = useRef(true)
  const formId = useId()
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])
  useEffect(() => {
    let current = true
    setLoading(true)
    void loadReview().then(result => { if (current) setReview(result) }).catch(async cause => {
      const message = await explainError(cause)
      if (current) { setReview(null); setError(message) }
    }).finally(() => { if (current) setLoading(false) })
    return () => { current = false }
  }, [loadReview, explainError, attempt])

  async function remove() {
    if (lock.current || loading || !review?.canDelete || confirmation !== review.confirmationPhrase) return
    lock.current = true; setBusy(true); setError(null); setConfirming(false)
    try {
      if (!await verify() || !mounted.current) return
      await deleteAccount(confirmation)
    } catch (cause) {
      const message = await explainError(cause)
      if (mounted.current) { setError(message); setConfirmation(''); setAttempt(value => value + 1) }
    } finally {
      lock.current = false
      if (mounted.current) setBusy(false)
    }
  }

  return <section aria-labelledby={`${formId}-title`} className="mx-auto w-full max-w-6xl space-y-6 text-sm leading-6" aria-busy={loading || busy}>
    <header className="flex items-start gap-3 sm:gap-4">
      <span className="flex size-11 shrink-0 items-center justify-center rounded-control border border-status-error/20 bg-surface-primary text-status-error"><Trash2 aria-hidden="true" size={20} /></span>
      <div className="min-w-0">
        <h2 id={`${formId}-title`} className="text-h2 font-semibold">Delete Vendor account</h2>
        <p className="mt-1 max-w-3xl text-text-secondary">Permanently close your store and delete your Owner account. Only the Vendor Owner can do this.</p>
      </div>
    </header>
    <section aria-labelledby={`${formId}-before`} className="grid gap-4 rounded-control bg-surface-canvas p-4 sm:p-5 lg:grid-cols-[minmax(0,1fr)_minmax(220px,0.45fr)] lg:gap-6">
      <div className="min-w-0">
        <h3 id={`${formId}-before`} className="flex items-center gap-2 font-semibold"><TriangleAlert aria-hidden="true" size={18} className="shrink-0 text-status-error" />Before you leave</h3>
        <p className="mt-2 text-text-secondary">Save any invoices, statements and reports you need. Your store will disappear from the marketplace, and you and your team will lose access. <strong className="font-semibold text-text-strong">This cannot be undone.</strong></p>
      </div>
      <div className="min-w-0 border-t border-border-default pt-4 lg:border-t-0 lg:border-l lg:pt-0 lg:pl-6">
        <p className="font-semibold">Only taking a break?</p>
        <p className="mt-1 text-text-secondary">For a temporary break, use Vacation Mode instead.</p>
      </div>
    </section>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <section aria-labelledby={`${formId}-eligibility`} className="overflow-hidden rounded-surface border border-border-default">
      <div className="flex flex-wrap items-center justify-between gap-3 p-4 sm:px-5">
        <h3 id={`${formId}-eligibility`} className="flex items-center gap-2 text-base font-semibold"><ShieldCheck aria-hidden="true" size={18} className="shrink-0 text-text-secondary" />Account deletion eligibility</h3>
        <Button variant="secondary" disabled={loading || busy} onClick={() => { setError(null); setAttempt(value => value + 1) }}><RefreshCw aria-hidden="true" size={16} />Check again</Button>
      </div>
      <div className="px-4 pb-4 sm:px-5 sm:pb-5">
        {loading ? <p role="status" className="flex items-start gap-2 text-text-secondary"><RefreshCw aria-hidden="true" size={18} className="mt-1 shrink-0" />Checking orders, payments, disputes and financial obligations…</p> : review && <>
          <StatusMessage tone={review.canDelete ? 'success' : 'info'}><span className="flex items-start gap-2">{review.canDelete ? <CircleCheck aria-hidden="true" size={18} className="mt-0.5 shrink-0" /> : <CircleHelp aria-hidden="true" size={18} className="mt-0.5 shrink-0" />}<span>{review.canDelete ? 'Your account is eligible for deletion. Eligibility will be checked again when you confirm.' : 'Resolve the following items before deleting your account.'}</span></span></StatusMessage>
          {!review.canDelete && <ul className="mt-2 divide-y divide-border-default">{review.blockers.filter(item => item.count > 0).map(item => <li key={item.key} className="flex flex-col gap-3 py-4 last:pb-0 md:flex-row md:items-center md:justify-between md:gap-6">
            <div className="min-w-0"><p className="flex flex-wrap items-center gap-2 font-semibold">{item.label}<span className="inline-flex min-h-6 min-w-6 items-center justify-center rounded-control bg-surface-canvas px-1.5 text-xs text-text-strong">{item.count}<span className="sr-only"> outstanding</span></span></p><p className="mt-1 text-text-secondary">{item.description}</p></div>
            <a className={buttonClassName('secondary', 'max-w-full self-start text-left md:self-center')} href={item.href}><span className="min-w-0">Review {item.label.toLowerCase()}</span><ArrowUpRight aria-hidden="true" size={16} className="shrink-0" /></a>
          </li>)}</ul>}
        </>}
      </div>
    </section>
    <section aria-labelledby={`${formId}-data`} className="grid gap-x-8 gap-y-4 border-t border-border-default pt-6 xl:grid-cols-[minmax(0,0.85fr)_minmax(0,1.15fr)]">
      <div className="min-w-0">
        <h3 id={`${formId}-data`} className="flex items-center gap-2 text-base font-semibold"><LockKeyhole aria-hidden="true" size={18} className="shrink-0 text-text-secondary" />What happens to your data</h3>
        <p className="mt-3 text-text-secondary">Your login identity and personal profile are anonymized, external sign-in links are removed, and your personal profile photo is queued for secure deletion. All Owner and current team sessions and unused invitations are revoked. Team members’ personal accounts are retained.</p>
      </div>
      <div className="min-w-0">
        <p className="text-text-secondary">Required records, including business identity where necessary, remain restricted to authorized access for these purposes:</p>
        {review && <dl className="mt-3 grid gap-x-6 gap-y-4 sm:grid-cols-2">{review.retainedRecords.map(record => <div key={record.category} className="border-t border-border-default pt-3"><dt className="font-semibold leading-5">{record.category}</dt><dd className="mt-1 text-text-secondary">{record.purpose}</dd></div>)}</dl>}
      </div>
      <p className="text-xs leading-5 text-text-secondary xl:col-span-2">Retention follows the applicable approved schedule and legal holds. Account deletion does not erase transaction history or legal obligations.</p>
    </section>
    <footer className="flex flex-col gap-4 border-t border-border-default pt-5 sm:flex-row sm:items-center sm:justify-between sm:gap-6">
      <div className="min-w-0"><p className="font-semibold">Permanent account deletion</p><p className="mt-1 text-text-secondary">You will confirm this decision and verify your identity before deletion.</p></div>
      <Button variant="danger" className="w-full sm:w-auto" disabled={loading || busy || !review?.canDelete} onClick={() => { setConfirmation(''); setConfirming(true) }}><Trash2 aria-hidden="true" size={16} />{busy ? 'Processing account deletion…' : 'Delete account'}</Button>
    </footer>
    {confirming && review && <FormDialog open size="small" title="Delete account permanently?" description="Your store will close and your team will lose access. This cannot be undone." onClose={() => setConfirming(false)} initialFocus="title" footer={<div className="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end"><Button variant="secondary" onClick={() => setConfirming(false)}>Keep account</Button><Button variant="danger" type="submit" form={formId} disabled={confirmation !== review.confirmationPhrase}>Delete account permanently</Button></div>}>
      <form id={formId} className="space-y-4" onSubmit={event => { event.preventDefault(); void remove() }}><p className="text-text-secondary">Required transaction, tax and audit records are retained. You and your team will be signed out.</p><Field label={`Type ${review.confirmationPhrase} to confirm`} name="confirmation" autoComplete="off" value={confirmation} onChange={event => setConfirmation(event.target.value)} required /></form>
    </FormDialog>}
  </section>
}
