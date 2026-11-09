import { useEffect, useId, useMemo, useState, type ReactNode } from 'react'
import { Inbox } from 'lucide-react'
import { AsyncLoading } from './async-state'
import './queue-workspace.css'

export function QueueLoadingState({ label = 'Loading queue…' }: { label?: string }) {
  return <AsyncLoading label={label} className="mp-queue-loading" />
}

/** Keep server-provided tab totals steady while another selection loads. */
export function useQueueStatusCounts(counts: unknown, failed = false) {
  const current = useMemo(() => counts && typeof counts === 'object' && !Array.isArray(counts) ? Object.fromEntries(Object.entries(counts).filter((entry): entry is [string, number] => typeof entry[1] === 'number')) : undefined, [counts])
  const [last, setLast] = useState<Record<string, number>>({})
  useEffect(() => { if (failed) setLast({}); else if (current) setLast(current) }, [current, failed])
  return failed ? {} : current ?? last
}

/** A stable queue surface contains every state, including errors and out-of-range pages. */
export function QueueSurface({ title, description, count, shown, busy, loaded, error, emptyTitle, emptyDescription, emptyAction, children, footer }: {
  title: string; description?: string; count: number | null; shown: number; busy: boolean; loaded: boolean; error?: ReactNode; emptyTitle: string; emptyDescription: string; emptyAction?: ReactNode; children: ReactNode; footer?: ReactNode
}) {
  const id = useId()
  return <section className="mp-queue-surface mp-card" aria-labelledby={id}>
    <header><div><h2 id={id}>{title}{count !== null && <span>{count.toLocaleString()} {count === 1 ? 'record' : 'records'}</span>}</h2>{description && <p>{description}</p>}</div><p role="status">{busy ? loaded ? 'Updating queue…' : 'Loading queue…' : loaded ? `${shown.toLocaleString()} shown` : 'Queue unavailable'}</p></header>
    <div className="mp-queue-content" aria-busy={busy}>{error ? <div className="mp-queue-error">{error}</div> : !loaded ? <QueueLoadingState /> : shown === 0 ? <div className="mp-queue-empty" role="status"><Inbox size={24} aria-hidden="true" /><h3>{emptyTitle}</h3><p>{emptyDescription}</p>{emptyAction}</div> : children}</div>
    {footer && <footer>{footer}</footer>}
  </section>
}

export function QueueSectionLinks({ links }: { links: { href: string; label: string }[] }) {
  return <nav aria-label="Case sections" className="mp-queue-section-links">{links.map(link => <a key={link.href} href={link.href}>{link.label}</a>)}</nav>
}
