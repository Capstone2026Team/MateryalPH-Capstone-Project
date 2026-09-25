import { useEffect, useRef, type ReactNode } from 'react'
import { Check } from 'lucide-react'
import { Button } from './button'
import { checklistProgress } from './verification-checklist'
import type { VendorOnboardingSection } from '@materyalph/api-client-ts'

type OnboardingStep = { label: string; requirements: string[] }

export function OnboardingFlow({ steps, current, onStep, section, children, actions, busy = false, autosave = false }: {
  steps: OnboardingStep[]; current: number; onStep: (step: number) => void
  section: VendorOnboardingSection; children: ReactNode; actions: ReactNode; busy?: boolean; autosave?: boolean
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
  return <div className="min-w-0 space-y-5">
    <nav aria-label={`${section.label} steps`} className="min-w-0 rounded-surface border border-border-default bg-surface-primary">
      <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 border-b border-border-default px-5 py-3 text-sm">
        <p className="font-semibold" aria-live="polite" aria-atomic="true">Step {current + 1} of {steps.length}</p>
        <p className="text-text-secondary">{progress.complete} of {progress.total} checklist items complete</p>
      </div>
      <ol className={`grid auto-rows-fr grid-cols-1 gap-1 p-2 min-[360px]:grid-cols-2 ${steps.length === 4 ? 'lg:grid-cols-4' : steps.length === 5 ? 'sm:grid-cols-3 lg:grid-cols-5' : 'sm:grid-cols-3 lg:grid-cols-6'}`} aria-label="Choose a section">
        {steps.map((step, index) => {
          const requirements = section.steps.filter(item => step.requirements.includes(item.key))
          const complete = requirements.length > 0 && requirements.every(item => ['APPROVED', 'COMPLETED', 'NOT_APPLICABLE'].includes(item.status))
          return <li key={step.label} className="flex min-w-0"><button type="button" disabled={busy} onClick={() => onStep(index)} aria-current={current === index ? 'step' : undefined} className={`flex min-h-20 w-full min-w-0 items-center gap-2 rounded-control border-b-2 px-3 py-3 text-left text-sm leading-5 transition-colors motion-reduce:transition-none disabled:opacity-60 ${current === index ? 'border-action-primary bg-brand-orange-50 font-semibold text-action-primary' : 'border-transparent text-text-secondary hover:bg-surface-canvas'}`}>
            <span className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full border text-xs font-semibold ${current === index ? 'border-action-primary bg-action-primary text-white' : complete ? 'border-status-success text-status-success' : 'border-border-default bg-surface-primary text-text-strong'}`}>{complete ? <><Check size={15} aria-hidden="true" /><span className="sr-only">Completed, </span></> : index + 1}</span>
            <span className="min-w-0 break-words">{step.label}</span>
          </button></li>
        })}
      </ol>
    </nav>
    <section className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="onboarding-section-title">
      <h2 ref={heading} tabIndex={-1} id="onboarding-section-title" className="mb-6 text-2xl font-semibold tracking-tight">{steps[current]?.label}</h2>
      <div className="min-w-0">{children}</div>
      <p className="mt-6 text-xs leading-5 text-text-secondary">{autosave ? `Progress saves when you change steps or return to the dashboard.${section.key === 'STORE_VERIFICATION' ? ' Only Submit for Admin Review sends your documents to Admin.' : ''}` : 'Switching steps keeps your edits on this page. Save a draft to keep them for later.'}</p>
      <div className="mt-8 flex flex-col sm:flex-row sm:flex-wrap items-stretch sm:items-center gap-3 border-t border-border-default pt-5">
        {current > 0 && <Button type="button" variant="secondary" disabled={busy} onClick={() => onStep(current - 1)}>Back</Button>}
        {actions}
        {current < steps.length - 1 && <Button type="button" className="sm:ml-auto" disabled={busy} onClick={() => onStep(current + 1)}>Next</Button>}
      </div>
    </section>
  </div>
}

// Keep native form values mounted across steps. Hidden sections are excluded from
// layout, keyboard navigation and the accessibility tree; saves still include them.
export function OnboardingStepContent({ active, children }: { active: boolean; children: ReactNode }) {
  return <div hidden={!active}>{children}</div>
}
