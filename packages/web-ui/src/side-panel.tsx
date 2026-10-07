import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { X } from 'lucide-react'
import { Button } from './button'
import './side-panel.css'

/** Native modal focus containment, with a persistent header and a scrolling body. */
export function SidePanel({ open, title, description, children, onClose, closeLabel = 'Close panel' }: {
  open: boolean; title: string; description?: string; children: ReactNode; onClose: () => void; closeLabel?: string
}) {
  const dialog = useRef<HTMLDialogElement>(null)
  const titleId = useId()
  const [closing, setClosing] = useState(false)
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null)
  useEffect(() => {
    const element = dialog.current
    if (!element || !open) return
    const previousFocus = document.activeElement
    const overflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    if (typeof element.showModal === 'function') element.showModal()
    else element.setAttribute('open', '')
    return () => {
      if (timer.current) clearTimeout(timer.current)
      if (typeof element.close === 'function') element.close()
      else element.removeAttribute('open')
      document.body.style.overflow = overflow
      if (previousFocus instanceof HTMLElement && previousFocus.isConnected) previousFocus.focus()
    }
  }, [open])
  const close = () => {
    if (closing) return
    setClosing(true)
    timer.current = setTimeout(onClose, window.matchMedia?.('(prefers-reduced-motion: reduce)').matches ? 0 : 180)
  }
  return <dialog ref={dialog} className="mp-side-panel" data-closing={closing} aria-labelledby={titleId} onCancel={event => { if (event.target !== event.currentTarget) return; event.preventDefault(); close() }}>
    <div className="mp-side-panel__layout">
      <div className="flex shrink-0 items-start justify-between gap-3 border-b border-border-default px-5 py-4">
        <div className="min-w-0"><h2 id={titleId} className="break-words text-lg font-semibold">{title}</h2>{description && <p className="mt-1 text-xs text-text-secondary">{description}</p>}</div>
        <Button variant="quiet" aria-label={closeLabel} onClick={close}><X size={20} aria-hidden="true" /></Button>
      </div>
      <div className="mp-side-panel__body">{children}</div>
    </div>
  </dialog>
}
