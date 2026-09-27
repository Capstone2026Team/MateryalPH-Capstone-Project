import type { ReactNode } from 'react'

export function ProfileDetails({ title, items, action }: { title: string; items: [string, ReactNode][]; action?: ReactNode }) {
  return <section className="min-w-0 space-y-5">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="text-lg font-semibold">{title}</h2>{action}</div>
    <dl className="grid gap-x-8 sm:grid-cols-2">{items.map(([label, value]) => <div key={label} className="min-w-0 border-t border-border-default py-4"><dt className="text-sm text-text-secondary">{label}</dt><dd className="mt-1 break-words text-sm font-semibold">{value || 'Not recorded'}</dd></div>)}</dl>
  </section>
}

export function ProfileSplitPanel({ details, documents }: { details: ReactNode; documents: ReactNode }) {
  return <div className="grid min-w-0 items-start gap-8 xl:grid-cols-[minmax(0,1.6fr)_minmax(320px,1fr)]"><div className="min-w-0 space-y-8">{details}</div><aside aria-label="Business documents" className="min-w-0 space-y-5 border-t border-border-default pt-6 xl:border-l xl:border-t-0 xl:pl-8 xl:pt-0">{documents}</aside></div>
}
