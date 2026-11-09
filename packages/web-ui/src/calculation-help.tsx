import { useCallback, useId, useLayoutEffect, useRef, useState, type ReactNode } from 'react'
import { Info, X } from 'lucide-react'
import './calculation-help.css'

/** Keep the card's decorative icon alongside its calculation control. */
export function MetricHeadingActions({ title, icon, calculation }: { title: string; icon?: ReactNode; calculation?: ReactNode }) {
  if (!icon && !calculation) return null
  return <span className="mp-metric-heading-actions">{icon && <span className="mp-kpi-icon" aria-hidden="true">{icon}</span>}{calculation && <CalculationHelp title={title}>{calculation}</CalculationHelp>}</span>
}

/** A click-open explanation that floats above the page without resizing its card. */
export function CalculationHelp({ title, children, label, wide = false }: { title: string; children: ReactNode; label?: string; wide?: boolean }) {
  const [open, setOpen] = useState(false)
  const trigger = useRef<HTMLButtonElement>(null)
  const panel = useRef<HTMLDivElement>(null)
  const id = useId()
  const close = useCallback((restoreFocus = false) => {
    setOpen(false)
    if (restoreFocus) trigger.current?.focus({ preventScroll: true })
  }, [])

  useLayoutEffect(() => {
    if (!open) return
    const position = () => {
      if (!trigger.current || !panel.current) return
      const anchor = trigger.current.getBoundingClientRect()
      const bounds = panel.current.getBoundingClientRect()
      const gutter = 12, gap = 8
      const above = anchor.top - gap - bounds.height
      const top = above >= gutter ? above : anchor.bottom + gap
      panel.current.style.left = `${Math.max(gutter, Math.min(anchor.left, window.innerWidth - bounds.width - gutter))}px`
      panel.current.style.top = `${Math.max(gutter, Math.min(top, window.innerHeight - bounds.height - gutter))}px`
    }
    const outside = (event: PointerEvent | FocusEvent) => {
      const target = event.target as Node
      if (!panel.current?.contains(target) && !trigger.current?.contains(target)) close()
    }
    const escape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.preventDefault()
        close(true)
      }
    }
    panel.current?.showPopover?.()
    position()
    panel.current?.focus({ preventScroll: true })
    const observer = typeof ResizeObserver === 'undefined' ? null : new ResizeObserver(position)
    if (panel.current) observer?.observe(panel.current)
    window.addEventListener('resize', position)
    window.addEventListener('scroll', position, true)
    document.addEventListener('pointerdown', outside)
    document.addEventListener('focusin', outside)
    document.addEventListener('keydown', escape)
    return () => {
      observer?.disconnect()
      window.removeEventListener('resize', position)
      window.removeEventListener('scroll', position, true)
      document.removeEventListener('pointerdown', outside)
      document.removeEventListener('focusin', outside)
      document.removeEventListener('keydown', escape)
    }
  }, [open, close])

  return <>
    <button ref={trigger} type="button" className={`mp-calculation-trigger${label ? ' mp-calculation-trigger-labelled' : ''}`} aria-label={`${label ?? 'How this is calculated'}: ${title}`} aria-haspopup="dialog" aria-expanded={open} aria-controls={open ? id : undefined} onClick={() => setOpen(current => !current)}>
      <Info size={15} aria-hidden="true" />{label && <span>{label}</span>}
    </button>
    {open && <div ref={panel} id={id} popover="manual" role="dialog" aria-labelledby={`${id}-title`} tabIndex={-1} className={`mp-calculation-popover${wide ? ' mp-calculation-popover-wide' : ''}`}>
      <header className="mp-calculation-popover-header"><div><p>How this is calculated</p><h3 id={`${id}-title`}>{title}</h3></div><button type="button" aria-label="Close calculation explanation" onClick={() => close(true)}><X size={18} aria-hidden="true" /></button></header>
      <div className="mp-calculation-popover-content">{children}</div>
    </div>}
  </>
}
