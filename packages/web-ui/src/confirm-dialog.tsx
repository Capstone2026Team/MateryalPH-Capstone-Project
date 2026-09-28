import { useEffect, useId, useRef, type ReactNode } from 'react'
import { Button } from './button'

/**
 * Modal confirmation for an irreversible action. Focus starts on Cancel, Escape cancels,
 * and the confirm button names the exact action.
 */
export function ConfirmDialog({ open, title, children, confirmLabel, busy = false, onConfirm, onCancel }: {
  open: boolean; title: string; children: ReactNode; confirmLabel: string; busy?: boolean; onConfirm: () => void; onCancel: () => void
}) {
  const dialog = useRef<HTMLDialogElement>(null)
  const titleId = useId()
  useEffect(() => {
    const element = dialog.current
    if (!element) return
    if (open && !element.open) { if (typeof element.showModal === 'function') element.showModal(); else element.setAttribute('open', '') }
    if (!open && element.open) { if (typeof element.close === 'function') element.close(); else element.removeAttribute('open') }
  }, [open])
  return <dialog ref={dialog} aria-labelledby={titleId} onCancel={event => { event.preventDefault(); if (!busy) onCancel() }} className="fixed inset-0 m-auto w-[min(92vw,28rem)] rounded-surface border border-border-default bg-surface-primary p-5 text-text-strong backdrop:bg-black/50">
    {open && <>
      <h2 id={titleId} className="text-lg font-semibold">{title}</h2>
      <div className="mt-2 text-sm text-text-secondary">{children}</div>
      <div className="mt-5 flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">
        <Button variant="secondary" autoFocus disabled={busy} onClick={onCancel}>Cancel</Button>
        <Button variant="danger" disabled={busy} onClick={onConfirm}>{busy ? 'Working…' : confirmLabel}</Button>
      </div>
    </>}
  </dialog>
}