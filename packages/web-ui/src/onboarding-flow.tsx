import { useEffect, useRef, type ReactNode } from 'react'
import { ArrowRight, Check } from 'lucide-react'
import { Button } from './button'
import { checklistProgress, type ChecklistRequirement } from './verification-checklist'

type OnboardingStep = { label: string; requirements: string[]; description?: string }

/** Any server-derived stepped workstream: Vendor onboarding sections and the listing wizard share this pattern. */
export type StepSection = { key: string; label: string; steps: ChecklistRequirement[] }

const DONE = ['APPROVED', 'COMPLETED', 'NOT_APPLICABLE']

/**
 * `tabs` shows the steps as a row above the content. `rail` shows them as a vertical
 * list beside the content from 1024px, with an optional panel (for example a publication
 * gate) under the list; below 1024px the panel follows the content.
 */
export function OnboardingFlow({ steps, current, onStep, section, children, actions, busy = false, autosave = false, layout = 'tabs', railTitle, aside, nextLabel }: {
  steps: OnboardingStep[]; current: number; onStep: (step: number) => void
  section: StepSection; children: ReactNode; actions: ReactNode; busy?: boolean; autosave?: boolean
  layout?: 'tabs' | 'rail'; railTitle?: ReactNode; aside?: ReactNode; nextLabel?: (next: OnboardingStep) => string
}) {
  const progress = checklistProgress(section)
  const heading = useRef<HTMLHeadingElement>(null)
  const previous = useRef(current)
  useEffect(() => {
    if (previous.current === current) return
    previous.current = current
    heading.current?.focus({ preventScroll: true })
    if (heading.current && heading.current.getBoundingClientRect().top < 0) heading.current.scrollIntoView({ block: 'start', behavior: 'instant' })
  }, [current])
  const rail = layout === 'rail'
  const stepState = (step: OnboardingStep) => {
    const requirements = section.steps.filter(item => step.requirements.includes(item.key))
    return requirements.length > 0 && requirements.every(item => DONE.includes(item.status))
  }
  const next = steps[current + 1]
  const content = <section className={`min-w-0 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7 ${rail ? 'lg:col-start-2 lg:row-span-2 lg:row-start-1' : ''}`} aria-labelledby="onboarding-section-title">
    <h2 ref={heading} tabIndex={-1} id="onboarding-section-title" className={`${rail && steps[current]?.description ? 'mb-1' : 'mb-6'} text-2xl font-semibold tracking-tight`}>{steps[current]?.label}</h2>
    {rail && steps[current]?.description && <p className="mb-6 text-sm text-text-secondary">{steps[current]?.description}</p>}
    <div className="min-w-0">{children}</div>
    <p className="mt-6 text-xs leading-5 text-text-secondary">{autosave ? `Progress saves when you change steps or return to the dashboard.${section.key === 'STORE_VERIFICATION' ? ' Only Submit for Admin Review sends your documents to Admin.' : ''}` : 'Switching steps keeps your edits on this page. Save a draft to keep them for later.'}</p>
    <div className="mt-8 flex flex-col sm:flex-row sm:flex-wrap items-stretch sm:items-center gap-3 border-t border-border-default pt-5">
      {current > 0 && <Button type="button" variant="secondary" disabled={busy} onClick={() => onStep(current - 1)}>Back</Button>}
      {actions}
      {next && <Button type="button" className="sm:ml-auto" disabled={busy} onClick={() => onStep(current + 1)}>{nextLabel ? <>{nextLabel(next)} <ArrowRight size={16} aria-hidden="true" /></> : 'Next'}</Button>}
    </div>
  </section>

  if (rail) {
    return <div className="grid min-w-0 gap-5 lg:grid-cols-[17rem_minmax(0,1fr)] lg:grid-rows-[auto_1fr] lg:items-start">
      <nav aria-label={`${section.label} steps`} className="min-w-0 rounded-surface border border-border-default bg-surface-primary lg:col-start-1 lg:row-start-1">
        <div className="border-b border-border-default px-4 py-3">
          {railTitle && <div className="min-w-0 break-words font-semibold">{railTitle}</div>}
          <p className="text-sm text-text-secondary" aria-live="polite" aria-atomic="true">Step {current + 1} of {steps.length} · {progress.complete} of {progress.total} checklist items complete</p>
        </div>
        <ol className="grid grid-cols-1 gap-1 p-2 min-[360px]:grid-cols-2 lg:grid-cols-1" aria-label="Choose a section">
          {steps.map((step, index) => {
            const complete = stepState(step)
            const active = current === index
            return <li key={step.label} className="flex min-w-0"><button type="button" disabled={busy} onClick={() => onStep(index)} aria-current={active ? 'step' : undefined} className={`flex min-h-14 w-full min-w-0 items-start gap-3 rounded-control border-l-4 px-3 py-2.5 text-left text-sm leading-5 transition-colors motion-reduce:transition-none disabled:opacity-60 ${active ? 'border-action-primary bg-brand-orange-50' : 'border-transparent hover:bg-surface-canvas'}`}>
              <span className={`mt-0.5 flex h-7 w-7 shrink-0 items-center justify-center rounded-full border text-xs font-semibold ${active ? 'border-action-primary bg-action-primary text-white' : complete ? 'border-status-success bg-status-success text-white' : 'border-border-default bg-surface-primary text-text-strong'}`}>{complete && !active ? <><Check size={14} aria-hidden="true" /><span className="sr-only">Completed, </span></> : index + 1}</span>
              <span className="min-w-0"><span className={`block break-words font-semibold ${active ? 'text-action-primary' : 'text-text-strong'}`}>{step.label}</span>{step.description && <span className="hidden text-xs text-text-secondary lg:block">{step.description}</span>}</span>
            </button></li>
          })}
        </ol>
      </nav>
      {content}
      {aside && <div className="min-w-0 lg:col-start-1 lg:row-start-2">{aside}</div>}
    </div>
  }

  return <div className="min-w-0 space-y-5">
    <nav aria-label={`${section.label} steps`} className="min-w-0 rounded-surface border border-border-default bg-surface-primary">
      <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 border-b border-border-default px-5 py-3 text-sm">
        <p className="font-semibold" aria-live="polite" aria-atomic="true">Step {current + 1} of {steps.length}</p>
        <p className="text-text-secondary">{progress.complete} of {progress.total} checklist items complete</p>
      </div>
      <ol className={`grid auto-rows-fr grid-cols-1 gap-1 p-2 min-[360px]:grid-cols-2 ${steps.length === 4 ? 'lg:grid-cols-4' : steps.length === 5 ? 'sm:grid-cols-3 lg:grid-cols-5' : 'sm:grid-cols-3 lg:grid-cols-6'}`} aria-label="Choose a section">
        {steps.map((step, index) => {
          const complete = stepState(step)
          return <li key={step.label} className="flex min-w-0"><button type="button" disabled={busy} onClick={() => onStep(index)} aria-current={current === index ? 'step' : undefined} className={`flex min-h-20 w-full min-w-0 items-center gap-2 rounded-control border-b-2 px-3 py-3 text-left text-sm leading-5 transition-colors motion-reduce:transition-none disabled:opacity-60 ${current === index ? 'border-action-primary bg-brand-orange-50 font-semibold text-action-primary' : 'border-transparent text-text-secondary hover:bg-surface-canvas'}`}>
            <span className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full border text-xs font-semibold ${current === index ? 'border-action-primary bg-action-primary text-white' : complete ? 'border-status-success text-status-success' : 'border-border-default bg-surface-primary text-text-strong'}`}>{complete ? <><Check size={15} aria-hidden="true" /><span className="sr-only">Completed, </span></> : index + 1}</span>
            <span className="min-w-0 break-words">{step.label}</span>
          </button></li>
        })}
      </ol>
    </nav>
    {content}
  </div>
}

// Keep native form values mounted across steps. Hidden sections are excluded from
// layout, keyboard navigation and the accessibility tree; saves still include them.
export function OnboardingStepContent({ active, children }: { active: boolean; children: ReactNode }) {
  return <div hidden={!active}>{children}</div>
}
