import { useId, type ReactNode } from 'react'
import { ChevronDown, Info } from 'lucide-react'
import { formatPesoCentavos } from './order-patterns'
import './finance-reconciliation.css'

/** One surface for finance queues, their filters and every result state. */
export function FinanceQueueWorkspace({ title, description, filters, dateFilter, note, children }: {
  title: string; description: string; filters: ReactNode; dateFilter: ReactNode; note?: ReactNode; children: ReactNode
}) {
  const id = useId()
  return <section className="mp-finance-queue mp-card" aria-labelledby={id}>
    <header className="mp-finance-queue-header"><h2 id={id}>{title}</h2><p>{description}</p></header>
    <div className="mp-finance-queue-toolbar"><div>{filters}</div><div>{dateFilter}</div></div>
    {note && <div className="mp-finance-queue-note"><Info size={16} aria-hidden="true" /><div>{note}</div></div>}
    <div className="mp-finance-queue-content">{children}</div>
  </section>
}

/** Keeps related labels and recorded values close together in tables and review details. */
export function FinanceRecordFacts({ items }: { items: [string, ReactNode][] }) {
  return <dl className="mp-finance-record-facts">{items.map(([label, value]) => <div key={label}><dt>{label}</dt><dd>{value}</dd></div>)}</dl>
}

function reviewFacts(values: Record<string, unknown>): [string, ReactNode][] {
  const labels: Record<string, string> = {
    credit_centavos: 'Proposed credit', target_before_centavos: 'Commission before credit', target_after_centavos: 'Commission after credit',
    returned_exclusive_centavos: 'Returned materials (VAT-exclusive)', prepared_by_user_id: 'Prepared by (user ID)',
  }
  return Object.entries(values).map(([key, value]) => {
    const words = key.replace(/_centavos$/, '').replaceAll('_', ' ')
    const label = labels[key] ?? words.charAt(0).toUpperCase() + words.slice(1)
    const display = value === null || value === undefined ? '—'
      : key.endsWith('_centavos') && typeof value === 'number' && Number.isSafeInteger(value) ? formatPesoCentavos(value)
      : typeof value === 'object' ? JSON.stringify(value) : String(value)
    return [label, display]
  })
}

/** Preserve the supplied records while displaying monetary values in pesos. */
export function FinanceReviewValues({ expected, reported }: { expected: Record<string, unknown>; reported: Record<string, unknown> }) {
  return <details className="mp-finance-review-values">
    <summary><ChevronDown size={16} aria-hidden="true" />Expected and reported values</summary>
    <div className="mp-finance-review-values-grid">
      <section aria-label="Expected values"><h4>Expected</h4>{Object.keys(expected).length ? <FinanceRecordFacts items={reviewFacts(expected)} /> : <p>No expected values recorded.</p>}</section>
      <section aria-label="Reported values"><h4>Reported</h4>{Object.keys(reported).length ? <FinanceRecordFacts items={reviewFacts(reported)} /> : <p>No reported values recorded.</p>}</section>
    </div>
  </details>
}
