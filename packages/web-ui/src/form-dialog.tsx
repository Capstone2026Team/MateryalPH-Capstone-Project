import { useEffect, useId, useRef, type ReactNode } from 'react'
import { X } from 'lucide-react'
import { Button } from './button'

/** A modal editor with persistent content and independently scrolling fields. */
export function FormDialog({ open, title, description, children, footer, busy = false, onClose }: {
  open: boolean; title: string; description: string; children: ReactNode; footer: ReactNode; busy?: boolean; onClose: () => void
}) {
  const dialog = useRef<HTMLDialogElement>(null)
  const titleId = useId()
  const descriptionId = useId()
  useEffect(() => {
    const element = dialog.current
    if (!element) return
    if (open && !element.open) { if (typeof element.showModal === 'function') element.showModal(); else element.setAttribute('open', '') }
    if (!open && element.open) { if (typeof element.close === 'function') element.close(); else element.removeAttribute('open') }
  }, [open])
  useEffect(() => {
    if (!open) return
    const overflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    return () => { document.body.style.overflow = overflow }
  }, [open])
  return <dialog ref={dialog} aria-labelledby={titleId} aria-describedby={descriptionId} onCancel={event => { if (event.target !== event.currentTarget) return; event.preventDefault(); if (!busy) onClose() }} className="fixed inset-0 m-auto max-h-[calc(100dvh_-_2rem)] w-[calc(100%_-_2rem)] max-w-5xl overflow-hidden rounded-surface border border-border-default bg-surface-primary p-0 text-text-strong shadow-xl backdrop:bg-black/50">
    <div className="flex max-h-[calc(100dvh_-_2rem)] flex-col">
      <header className="flex shrink-0 items-start justify-between gap-4 border-b border-border-default px-5 py-4 sm:px-6">
        <div><h2 id={titleId} className="text-xl font-semibold">{title}</h2><p id={descriptionId} className="mt-1 text-sm text-text-secondary">{description}</p></div>
        <Button variant="quiet" aria-label={`Close ${title.toLowerCase()}`} disabled={busy} onClick={onClose}><X size={20} aria-hidden="true" /></Button>
      </header>
      <div className="min-h-0 overflow-y-auto overscroll-contain px-5 py-5 sm:px-6">{children}</div>
      {footer && <div className="shrink-0 border-t border-border-default bg-surface-primary px-5 py-4 sm:px-6">{footer}</div>}
    </div>
  </dialog>
}
