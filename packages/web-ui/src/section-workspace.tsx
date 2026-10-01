import { MetricCard } from './dashboard-patterns'
import { useId, useState, type ReactNode } from 'react'
import { Button } from './button'
import { ALL_DATES, DateFilter } from './date-filter'

export function SectionWorkspace({ sections, dateFilter = false, beforeSectionChange, dashboard = false }: { sections: { label: string; content: ReactNode }[]; dateFilter?: boolean; beforeSectionChange?: () => boolean | Promise<boolean>; dashboard?: boolean }) {
  const [selected, setSelected] = useState(0)
  const [changing, setChanging] = useState(false)
  async function select(index: number) {
    if (index === selected || changing) return
    if (!beforeSectionChange) { setSelected(index); return }
    const allowed = beforeSectionChange()
    if (typeof allowed === 'boolean') { if (allowed) setSelected(index); return }
    setChanging(true)
    try { if (await allowed) setSelected(index) } finally { setChanging(false) }
  }
  const [range, setRange] = useState(ALL_DATES)
  const id = useId()
  return <div className="space-y-6">
    <div className="flex flex-col-reverse gap-4 xl:flex-row xl:items-start xl:justify-between"><nav aria-label="Workspace sections" className={`${dashboard ? 'grid grid-cols-2 md:flex md:flex-wrap' : 'flex flex-wrap'} min-w-0 max-w-full gap-1 rounded-surface border border-border-default bg-surface-primary p-1`}>{sections.map((section, index) => <Button key={section.label} className={dashboard ? 'min-w-0 px-3 py-2 text-xs sm:text-sm' : 'text-sm'} variant={selected === index ? 'primary' : 'quiet'} aria-pressed={selected === index} aria-controls={id} disabled={changing} onClick={() => void select(index)}>{section.label}</Button>)}</nav>{dateFilter && <DateFilter value={range} onChange={setRange} />}</div>
    {dateFilter && <p className="border-l-2 border-brand-orange-300 pl-3 text-xs leading-5 text-text-secondary">Period: {range.label}{range.from || range.to ? ` · ${range.from || 'Any start'} — ${range.to || 'Any end'}` : ''}. Date selection is a UI preview; current counts and demonstration data are not date-filtered.</p>}
    <section id={id} aria-label={sections[selected]?.label} className={dashboard ? 'space-y-5' : undefined}>{dashboard && <div className="flex items-center gap-3"><h2 className="text-xs font-semibold uppercase tracking-widest text-action-primary">{sections[selected]?.label}</h2><div className="h-px flex-1 bg-border-default" /></div>}{sections[selected]?.content}</section>
  </div>
}

export function PreviewMetrics({ labels }: { labels: string[] }) {
  return <div className="space-y-4"><p className="text-sm text-text-secondary">Design preview · Not yet implemented. No live operational data.</p><dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{labels.map(label => <MetricCard key={label} label={label} value={<span aria-label="Not yet implemented">—</span>} description="Available in a later phase" />)}</dl></div>
}
