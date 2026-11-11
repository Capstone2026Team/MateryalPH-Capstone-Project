import { useEffect, useRef, useState, type ReactNode } from 'react'
import { ArrowLeft, ArrowRight, Check, FlaskConical } from 'lucide-react'
import { Button } from './button'
import { FormDialog } from './form-dialog'
import { FormControlScope } from './field'
import './tutorial-practice.css'

export type PracticeStep = { title: string; description: string; target?: string; nextLabel?: string }

/** An isolated, interactive example. Its caller supplies local state and local-only actions. */
export function TutorialPractice({ title, steps, step, onStep, onClose, onNext, children, sampleAction }: {
  title: string; steps: readonly PracticeStep[]; step: number; onStep: (index: number) => void
  onClose: (completed: boolean) => void; onNext?: () => boolean; children: ReactNode; sampleAction?: ReactNode
}) {
  const content = useRef<HTMLDivElement>(null)
  const heading = useRef<HTMLHeadingElement>(null)
  const [error, setError] = useState('')
  const current = steps[step]!
  useEffect(() => {
    setError('')
    const coach = heading.current?.closest('.mp-practice-coach')
    if (coach) coach.scrollTop = 0
    heading.current?.focus({ preventScroll: true })
    const root = content.current
    let target: Element | null = null
    const timer = window.setTimeout(() => {
      target = current.target ? root?.querySelector(current.target) ?? null : null
      target?.setAttribute('data-practice-highlight', '')
      const anchor = target?.querySelector('header, h2, h3') ?? target
      anchor?.scrollIntoView({ block: 'start', inline: 'nearest', behavior: 'instant' })
    }, 120)
    return () => { window.clearTimeout(timer); target?.removeAttribute('data-practice-highlight') }
  }, [step, current.target])
  return <FormDialog open title={title} description="Tutorial demo · Nothing is saved to your store or sent." size="full" initialFocus="title" tutorialHelp={false} onClose={() => onClose(false)} bodyClassName="mp-practice-body" footer={<div className="mp-practice-actions">
    <Button variant="quiet" onClick={() => onClose(false)}>Skip</Button>
    <div className="flex flex-wrap justify-end gap-2"><Button variant="secondary" disabled={step === 0} onClick={() => onStep(step - 1)}><ArrowLeft size={16} aria-hidden="true" />Back</Button><Button onClick={() => { if (onNext && !onNext()) { setError('Complete the highlighted sample fields or action before continuing.'); return }; if (step === steps.length - 1) onClose(true); else onStep(step + 1) }}>{current.nextLabel ?? (step === steps.length - 1 ? 'Finish' : 'Next')}{step === steps.length - 1 ? <Check size={16} aria-hidden="true" /> : <ArrowRight size={16} aria-hidden="true" />}</Button></div>
  </div>}>
    <aside className="mp-practice-coach" aria-label="Practice instructions">
      <p className="flex items-center gap-2 text-xs font-semibold text-action-primary"><FlaskConical size={16} aria-hidden="true" />Practice · {step + 1} of {steps.length}</p>
      <div className="mp-practice-progress" role="progressbar" aria-label="Practice progress" aria-valuemin={0} aria-valuemax={steps.length} aria-valuenow={step + 1}><span style={{ width: `${(step + 1) / steps.length * 100}%` }} /></div>
      <h3 ref={heading} tabIndex={-1} className="text-lg font-semibold">{current.title}</h3>
      <p className="text-sm leading-6 text-text-secondary">{current.description}</p>
      {sampleAction}
      {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    </aside>
    <div ref={content} className="mp-practice-workspace" onClickCapture={event => { if ((event.target as Element).closest('a[href]')) event.preventDefault() }}><FormControlScope prefix="tutorial-practice-">{children}</FormControlScope></div>
  </FormDialog>
}
