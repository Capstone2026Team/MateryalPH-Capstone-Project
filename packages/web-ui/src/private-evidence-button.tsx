import { useEffect, useRef, useState } from 'react'
import { Button } from './button'
import { readWebPrivateFile } from './web-api-session'

export function PrivateEvidenceButton({ loadUrl, apiBasePath, children, disabled = false }: {
  loadUrl: () => Promise<{ url: string }>; apiBasePath: string; children: React.ReactNode; disabled?: boolean
}) {
  const dialog = useRef<HTMLDialogElement>(null)
  const mounted = useRef(true)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [preview, setPreview] = useState<{ url: string; type: string } | null>(null)
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])
  useEffect(() => {
    if (!preview) return
    dialog.current?.showModal()
    return () => URL.revokeObjectURL(preview.url)
  }, [preview])
  async function open() {
    setBusy(true); setError('')
    try {
      const file = await loadUrl()
      const blob = await readWebPrivateFile(apiBasePath, file.url)
      if (mounted.current) setPreview({ url: URL.createObjectURL(blob), type: blob.type })
    } catch {
      if (mounted.current) setError('Preview could not be opened. Try again.')
    } finally { if (mounted.current) setBusy(false) }
  }
  return <div className="min-w-0">
    <Button type="button" data-review-action variant="quiet" disabled={disabled || busy} onClick={() => void open()}>{busy ? 'Loading document…' : children}</Button>
    {error && <p role="alert" className="mt-2 text-sm text-status-error">{error}</p>}
    {preview && <dialog ref={dialog} aria-label="Submitted document preview" onClose={() => setPreview(null)} className="fixed inset-0 m-auto max-h-[90dvh] w-[min(96vw,1100px)] max-w-none rounded-surface border border-border-default bg-surface-primary p-4 text-text-strong backdrop:bg-black/50">
      <div className="mb-4 flex items-center justify-between gap-4"><h2 className="text-lg font-semibold">Submitted document</h2><Button variant="secondary" onClick={() => dialog.current?.close()}>Close preview</Button></div>
      {preview.type.startsWith('image/') ? <img src={preview.url} alt="Submitted verification document" className="max-h-[70dvh] w-full object-contain" /> : <iframe src={preview.url} title="Submitted verification document" className="h-[70dvh] w-full border-0" />}
      <a href={preview.url} download="verification-document" className="mt-3 inline-flex min-h-11 items-center font-semibold text-action-primary">Download document</a>
    </dialog>}
  </div>
}
