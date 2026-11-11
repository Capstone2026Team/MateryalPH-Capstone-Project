import { useEffect, useId, useLayoutEffect, useRef, useState, type ReactNode } from 'react'
import { ArrowLeft, ArrowRight, Check, Compass, X } from 'lucide-react'
import { Button } from './button'
import './guided-walkthrough.css'

export type WalkthroughStep = { id: string; target: string; title: string; description: string; icon?: ReactNode }

/** Read-only spotlight over the real interface. Native modal semantics contain focus and inert the page. */
export function GuidedWalkthrough({ steps, onClose, onStepChange, label = 'Quick tour', finishLabel = 'Finish', onBackAtStart, initialIndex = 0, busy = false, continuousProgress }: {
  steps: readonly WalkthroughStep[]; onClose: (completed: boolean) => void; label?: string; onStepChange?: (step: WalkthroughStep) => void
  finishLabel?: string; onBackAtStart?: (() => void) | undefined; initialIndex?: number; busy?: boolean
  continuousProgress?: { stepOffset: number; pageIndex: number; pageCount: number } | undefined
}) {
  const dialog = useRef<HTMLDialogElement>(null)
  const card = useRef<HTMLDivElement>(null)
  const heading = useRef<HTMLHeadingElement>(null)
  const mask = useId().replaceAll(':', '')
  const title = useId()
  const description = useId()
  const [index, setIndex] = useState(Math.min(initialIndex, steps.length - 1))
  const [box, setBox] = useState<DOMRect | null>(null)
  const [position, setPosition] = useState({ left: 16, top: 16, maxHeight: 'calc(100dvh - 32px)' })
  const step = steps[Math.min(index, steps.length - 1)]
  useEffect(() => { if (step) onStepChange?.(step) }, [step, onStepChange])

  useEffect(() => {
    const element = dialog.current
    if (!element) return
    const previous = document.activeElement
    element.showModal()
    return () => { element.close(); if (previous instanceof HTMLElement && previous.isConnected) previous.focus() }
  }, [])

  useLayoutEffect(() => {
    if (!step) return
    let target: Element | null = null
    const measure = () => {
      const found = document.querySelector(step.target)
      const compact = found && found.getBoundingClientRect().height > innerHeight * .45
        ? found.querySelector(':scope > header, :scope > h2, :scope > h3, :scope > .chat-sidebar-heading, :scope > .chat-thread-header') ?? found : found
      if (compact !== target) {
        target = compact
        const horizontal: { element: Element; left: number }[] = []
        for (let ancestor = target; ancestor; ancestor = ancestor.parentElement) horizontal.push({ element: ancestor, left: ancestor.scrollLeft })
        const pageX = window.scrollX
        target?.scrollIntoView?.({ block: found?.hasAttribute('data-vendor-guide-target') ? 'start' : 'center', inline: 'nearest', behavior: 'instant' })
        for (const { element, left } of horizontal) if (element.scrollLeft !== left) element.scrollLeft = left
        if (window.scrollX !== pageX) window.scrollTo({ left: pageX, top: window.scrollY, behavior: 'instant' })
      }
      const rect = target?.getBoundingClientRect()
      let visible = rect && rect.width > 0 && rect.height > 0 && rect.right > 0 && rect.left < innerWidth && rect.bottom > 0 && rect.top < innerHeight
        ? new DOMRect(Math.max(6, rect.left), Math.max(6, rect.top), Math.max(0, Math.min(innerWidth - 6, rect.right) - Math.max(6, rect.left)), Math.min(120, innerHeight * .25, rect.height, innerHeight - Math.max(6, rect.top) - 6)) : null
      // Preserve the full target when it fits, and a visible heading-sized strip for tall workspaces.
      if (visible && rect && rect.height <= innerHeight * .45) visible.height = Math.max(0, Math.min(innerHeight - 6, rect.bottom) - visible.top)
      if (visible && (visible.width <= 0 || visible.height <= 0)) visible = null
      const width = card.current?.offsetWidth ?? 340
      const workspace = target?.closest('#main-content')?.getBoundingClientRect()
      const safeLeft = innerWidth >= 1024 && workspace && workspace.width >= width + 32 ? Math.max(16, workspace.left + 16) : 16
      const copy = card.current?.querySelector<HTMLElement>('.mp-walkthrough-copy')
      const height = Math.min((card.current?.scrollHeight ?? 300) + (copy ? Math.max(0, copy.scrollHeight - copy.clientHeight) : 0), innerHeight - 32)
      const right = visible && visible.right + width + 36 <= innerWidth
      const leftSide = visible && visible.left - width - 20 >= safeLeft
      const left = right ? visible!.right + 20 : leftSide ? visible!.left - width - 20 : Math.max(safeLeft, Math.min(visible?.left ?? (innerWidth - width) / 2, innerWidth - width - 16))
      let top = !visible ? (innerHeight - height) / 2 : right || leftSide ? visible.top
        : visible.bottom + height + 32 <= innerHeight ? visible.bottom + 16
          : visible.top - height - 16 >= 16 ? visible.top - height - 16 : innerHeight - height - 16
      top = Math.max(16, Math.min(top, innerHeight - height - 16))
      if (visible && !right && !leftSide && visible.bottom > top - 12 && visible.top < top + height + 12) {
        // Short screens retain all controls. Only spotlight the unobscured part of a large target.
        if (visible.top < top - 20) visible.height = top - 12 - visible.top
        else visible = null
      }
      setBox(visible)
      setPosition({ left, top, maxHeight: 'calc(100dvh - 32px)' })
    }
    measure()
    heading.current?.focus({ preventScroll: true })
    const observer = new ResizeObserver(measure)
    if (card.current) observer.observe(card.current)
    const mutations = new MutationObserver(measure)
    // Lazy route content can mount after the tour; observe only the underlying page.
    const main = document.getElementById('main-content')
    if (main) mutations.observe(main, { childList: true, subtree: true })
    const sidebar = document.getElementById('portal-sidebar')
    if (sidebar) mutations.observe(sidebar, { attributes: true, attributeFilter: ['class'] })
    window.addEventListener('resize', measure)
    window.addEventListener('scroll', measure, true)
    return () => { observer.disconnect(); mutations.disconnect(); window.removeEventListener('resize', measure); window.removeEventListener('scroll', measure, true) }
  }, [step])

  if (!step) return null
  const last = index === steps.length - 1
  const percent = continuousProgress ? (continuousProgress.pageIndex + (busy ? 0 : (index + 1) / steps.length)) / continuousProgress.pageCount * 100 : (index + 1) / steps.length * 100
  return <dialog ref={dialog} className="mp-walkthrough" aria-labelledby={title} aria-describedby={description} onCancel={event => { event.preventDefault(); onClose(false) }}>
    <svg className="mp-walkthrough-shade" aria-hidden="true" onClick={() => onClose(false)}>
      <defs><mask id={mask}><rect width="100%" height="100%" fill="white" />{box && <rect x={box.left - 5} y={box.top - 5} width={box.width + 10} height={box.height + 10} rx="10" fill="black" />}</mask></defs>
      <rect width="100%" height="100%" mask={`url(#${mask})`} />
    </svg>
    {box && <div key={step.id} className="mp-walkthrough-ring" style={{ left: box.left - 5, top: box.top - 5, width: box.width + 10, height: box.height + 10 }} aria-hidden="true" />}
    <div ref={card} className="mp-walkthrough-card" style={position}>
      <div className="mp-walkthrough-top"><span>{label} · {continuousProgress ? `Step ${continuousProgress.stepOffset + index + 1}` : `${index + 1} of ${steps.length}`}</span><button type="button" aria-label="Close tutorial" onClick={() => onClose(false)}><X size={20} aria-hidden="true" /></button></div>
      <div className="mp-walkthrough-progress" role="progressbar" aria-label="Tutorial progress" aria-valuenow={Math.round(percent)} aria-valuemin={0} aria-valuemax={100}><span style={{ width: `${percent}%` }} /></div>
      <div className="mp-walkthrough-copy" key={step.id}>
        <span className="mp-walkthrough-icon" aria-hidden="true">{step.icon ?? <Compass size={24} />}</span>
        <h2 id={title} ref={heading} tabIndex={-1}>{step.title}</h2>
        <p id={description}>{step.description}</p>
      </div>
      <div className="mp-walkthrough-actions"><Button variant="quiet" onClick={() => onClose(false)}>Skip</Button><div><Button variant="secondary" disabled={busy || (index === 0 && !onBackAtStart)} onClick={() => index === 0 ? onBackAtStart?.() : setIndex(index - 1)}><ArrowLeft size={16} aria-hidden="true" />Back</Button><Button disabled={busy} onClick={() => last ? onClose(true) : setIndex(index + 1)}>{busy ? 'Opening…' : last ? finishLabel : 'Next'}{last && finishLabel === 'Finish' ? <Check size={16} aria-hidden="true" /> : <ArrowRight size={16} aria-hidden="true" />}</Button></div></div>
    </div>
  </dialog>
}
