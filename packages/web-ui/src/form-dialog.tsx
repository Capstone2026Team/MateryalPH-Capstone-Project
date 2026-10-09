import { useEffect, useId, useRef, type ReactNode } from 'react'
import { X } from 'lucide-react'
import { Button } from './button'

/** A modal editor with persistent content and independently scrolling fields. */
export function FormDialog({ open, title, description, children, footer, busy = false, onClose, bodyClassName, headerMedia, headerDetails, size = 'wide' }: {
  open: boolean; title: string; description: string; children: ReactNode; footer: ReactNode; busy?: boolean; onClose: () => void; bodyClassName?: string; headerMedia?: ReactNode; headerDetails?: ReactNode; size?: 'compact' | 'wide'
}) {
  const dialog = useRef<HTMLDialogElement>(null)
  const titleId = useId()
  const descriptionId = useId()
  useEffect(() => {
    const element = dialog.current
    if (!element || !open) return
    const previousFocus = document.activeElement
    const overflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    if (!element.open) { if (typeof element.showModal === 'function') element.showModal(); else element.setAttribute('open', '') }
    return () => {
      if (element.open) { if (typeof element.close === 'function') element.close(); else element.removeAttribute('open') }
      document.body.style.overflow = overflow
      if (previousFocus instanceof HTMLElement && previousFocus.isConnected) previousFocus.focus()
    }
  }, [open])
  return <dialog ref={dialog} aria-labelledby={titleId} aria-describedby={descriptionId} onCancel={event => { if (event.target !== event.currentTarget) return; event.preventDefault(); if (!busy) onClose() }} className={`fixed inset-0 m-auto max-h-[calc(100dvh_-_2rem)] w-[calc(100%_-_2rem)] ${size === 'compact' ? 'max-w-2xl' : 'max-w-5xl'} overflow-hidden rounded-surface border border-border-default bg-surface-primary p-0 text-text-strong shadow-xl backdrop:bg-black/50`}>
    <div className="flex max-h-[calc(100dvh_-_2rem)] flex-col">
      <header className="flex shrink-0 items-start justify-between gap-4 border-b border-border-default px-5 py-4 sm:px-6">
        <div className="flex min-w-0 flex-1 flex-wrap items-start gap-4">
          {headerMedia && <div className="shrink-0">{headerMedia}</div>}
          <div className="min-w-0 flex-1 basis-32">
            <h2 id={titleId} className="break-words text-xl font-semibold">{title}</h2>
            <p id={descriptionId} className="mt-1 break-words text-sm text-text-secondary">{description}</p>
            {headerDetails && <div className="mt-3">{headerDetails}</div>}
          </div>
        </div>
        <Button variant="quiet" aria-label={`Close ${title.toLowerCase()}`} disabled={busy} onClick={onClose}><X size={20} aria-hidden="true" /></Button>
      </header>
      <div className={bodyClassName ?? 'min-h-0 overflow-y-auto overscroll-contain px-5 py-5 sm:px-6'}>{children}</div>
      {footer && <div className="shrink-0 border-t border-border-default bg-surface-primary px-5 py-4 sm:px-6">{footer}</div>}
    </div>
  </dialog>
}
