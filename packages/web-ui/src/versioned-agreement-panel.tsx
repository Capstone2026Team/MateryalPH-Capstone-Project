import { useEffect, useRef, useState, type ReactNode } from 'react'
import { Button } from './button'

export function VersionedAgreementPanel({ title, version, content, accepted, eligible, busy, error, children, onAccept }: {
  title: string; version: number; content: string; accepted: boolean; eligible: boolean; busy: boolean; error: string;
  children: ReactNode; onAccept: () => void;
}) {
  const reader = useRef<HTMLDivElement>(null)
  const [opened, setOpened] = useState(false)
  const [read, setRead] = useState(false)
  const [checked, setChecked] = useState(false)
  useEffect(() => {
    if (opened && reader.current && reader.current.scrollHeight <= reader.current.clientHeight + 2) setRead(true)
  }, [opened])
  return <section aria-labelledby="commission-title" className="overflow-hidden rounded-surface border border-border-default bg-surface-primary">
    <div className="flex flex-wrap items-start justify-between gap-4 border-b border-border-default bg-surface-canvas p-5 sm:p-7">
      <div><p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Vendor agreement · TEST/DEMO</p><h2 id="commission-title" className="mt-2 text-xl font-semibold sm:text-2xl">{title}</h2><p className="mt-2 text-sm text-text-secondary">{version ? `Version ${version}` : 'Current version unavailable'} · Required before Store Activation</p></div>
      <span className="rounded-control border border-border-default bg-surface-primary px-4 py-2 text-3xl font-semibold text-action-primary">2%</span>
    </div>
    <div className="grid gap-5 p-5 sm:p-7">{children}
      {content ? <details onToggle={event => setOpened(event.currentTarget.open)} className="rounded-control border border-border-default">
        <summary className="min-h-11 cursor-pointer px-4 py-3 font-semibold text-action-primary">Read the full commission terms</summary>
        {opened && <div ref={reader} tabIndex={0} role="region" aria-label="Current commission agreement" onScroll={event => { const el = event.currentTarget; if (el.scrollTop + el.clientHeight >= el.scrollHeight - 2) setRead(true) }} className="max-h-72 overflow-y-auto whitespace-pre-wrap break-words border-t border-border-default p-4 text-sm leading-7">{content}</div>}
      </details> : <p role="status" className="text-sm text-status-error">The published terms are unavailable. Reload this page to try again.</p>}
      {accepted ? <p role="status" className="rounded-control bg-surface-canvas p-4 text-sm font-semibold">Current commission terms accepted for this organization.</p> : <div className="grid gap-3 border-t border-border-default pt-5">
        {!eligible && <p className="text-sm leading-6 text-text-secondary">Complete Business Information first. Where Authority to Act is required, submit your evidence for Admin review, then return here once the Owner-linked representative is approved for COMMISSION_AGREEMENT.</p>}
        <label className="flex min-h-11 items-start gap-3 text-sm leading-6"><input type="checkbox" className="mt-1 h-5 w-5 shrink-0 accent-action-primary" checked={checked} disabled={!content || !read || !eligible || busy} onChange={event => setChecked(event.target.checked)} /><span>I accept version {version || '—'} of the Vendor commission terms for this organization.</span></label>
        {!read && content && <p className="text-sm text-text-secondary">Open the full terms and read to the end to enable acceptance.</p>}
        <div><Button type="button" disabled={!checked || !read || !eligible || !content || busy} onClick={onAccept}>{busy ? 'Recording acceptance…' : 'Accept commission terms'}</Button></div>
        <p className="text-xs leading-5 text-text-secondary">This action records your acceptance now. Saving a draft or submitting documents does not accept the agreement.</p>
      </div>}
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </div>
  </section>
}
