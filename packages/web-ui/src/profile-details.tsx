import type { ReactNode } from 'react'

/** `card` frames the group on its own surface with stacked label/value pairs; `plain` keeps the ruled list. */
export function ProfileDetails({ title, items, action, columns = 2, appearance = 'plain' }: { title: string; items: [string, ReactNode][]; action?: ReactNode; columns?: 2 | 3; appearance?: 'plain' | 'card' }) {
  if (appearance === 'card') {
    return <section aria-label={title} className="min-w-0 rounded-surface border border-border-default bg-surface-primary">
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border-default px-5 py-4 sm:px-6"><h2 className="text-lg font-semibold">{title}</h2>{action}</div>
      <dl className={`grid gap-x-8 gap-y-5 px-5 py-5 sm:grid-cols-2 sm:px-6 ${columns === 3 ? 'xl:grid-cols-3' : ''}`}>{items.map(([label, value]) => <div key={label} className="min-w-0"><dt className="text-xs font-medium text-text-secondary">{label}</dt><dd className="mt-1 break-words text-sm font-semibold text-text-strong">{value || 'Not recorded'}</dd></div>)}</dl>
    </section>
  }
  return <section aria-label={title} className="min-w-0 space-y-5">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="text-lg font-semibold">{title}</h2>{action}</div>
    <dl className={`grid gap-x-8 sm:grid-cols-2 ${columns === 3 ? 'xl:grid-cols-3' : ''}`}>{items.map(([label, value]) => <div key={label} className="min-w-0 border-t border-border-default py-4"><dt className="text-sm text-text-secondary">{label}</dt><dd className="mt-1 break-words text-sm font-semibold">{value || 'Not recorded'}</dd></div>)}</dl>
  </section>
}

export function ProfileSplitPanel({ details, documents }: { details: ReactNode; documents: ReactNode }) {
  return <div className="grid min-w-0 items-start gap-6 xl:grid-cols-[minmax(0,1.6fr)_minmax(320px,1fr)]"><div className="min-w-0 space-y-6">{details}</div><aside aria-label="Business documents" className="min-w-0 space-y-5 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6">{documents}</aside></div>
}
