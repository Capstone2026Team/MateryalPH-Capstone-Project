import { useEffect, useRef, useState } from 'react'
import { Button } from './button'
import { readWebPrivateFile } from './web-api-session'

export type PrivateEvidenceItem = { id: string; label: string; loadUrl: () => Promise<{ url: string }> }

export function PrivateEvidenceGallery({ items, apiBasePath }: { items: PrivateEvidenceItem[]; apiBasePath: string }) {
  return <div className="grid gap-5">{items.map(item => <EvidencePreview key={item.id} item={item} apiBasePath={apiBasePath} />)}</div>
}

function EvidencePreview({ item, apiBasePath }: { item: PrivateEvidenceItem; apiBasePath: string }) {
  const [preview, setPreview] = useState<{ url: string; type: string } | null>(null)
  const [error, setError] = useState('')
  const [zoomed, setZoomed] = useState(false)
  const dialog = useRef<HTMLDialogElement>(null)
  const [retry, setRetry] = useState(0)

  useEffect(() => {
    let active = true
    let objectUrl = ''
    setPreview(null)
    setError('')
    void item.loadUrl().then(file => readWebPrivateFile(apiBasePath, file.url)).then(blob => {
      if (!active) return
      objectUrl = URL.createObjectURL(blob)
      setPreview({ url: objectUrl, type: blob.type })
    }).catch(() => { if (active) setError('Preview could not be loaded. Try again.') })
    return () => { active = false; if (objectUrl) URL.revokeObjectURL(objectUrl) }
  }, [apiBasePath, item.id, retry])

  return <div className="min-w-0 border-t border-border-default pt-4">
    <div className="mb-3 flex flex-wrap items-center justify-between gap-3"><h4 className="font-semibold">{item.label}</h4>{preview && <Button type="button" variant="quiet" onClick={() => dialog.current?.showModal()}>Enlarge {item.label}</Button>}</div>
    {error ? <div role="alert" className="text-sm text-status-error">{error} <Button type="button" variant="quiet" onClick={() => setRetry(value => value + 1)}>Retry preview</Button></div>
      : !preview ? <p role="status" className="text-sm text-text-secondary">Loading private evidence…</p>
        : preview.type.startsWith('image/') ? <button type="button" aria-label={`Enlarge ${item.label}`} className="flex min-h-44 w-full items-center justify-center overflow-hidden rounded-control border border-border-default bg-surface-primary p-2" onClick={() => dialog.current?.showModal()}><img src={preview.url} alt={item.label} className="max-h-80 w-full object-contain" /></button>
          : <iframe src={preview.url} title={item.label} className="h-96 w-full rounded-control border border-border-default bg-surface-primary" />}
    {preview && <dialog ref={dialog} aria-label={`${item.label} full preview`} onClose={() => setZoomed(false)} className="fixed inset-0 m-auto max-h-[95dvh] w-[min(98vw,1200px)] max-w-none rounded-surface border border-border-default bg-surface-primary p-4 text-text-strong backdrop:bg-black/50">
      <div className="mb-3 flex flex-wrap items-center justify-between gap-3"><h2 className="text-lg font-semibold">{item.label}</h2><div className="flex gap-2">{preview.type.startsWith('image/') && <Button type="button" variant="secondary" onClick={() => setZoomed(value => !value)}>{zoomed ? 'Fit image' : 'Zoom in'}</Button>}<Button type="button" variant="secondary" onClick={() => dialog.current?.close()}>Close preview</Button></div></div>
      <div className="max-h-[78dvh] overflow-auto">{preview.type.startsWith('image/') ? <img src={preview.url} alt={item.label} className={zoomed ? 'max-w-none' : 'max-h-[75dvh] w-full object-contain'} /> : <iframe src={preview.url} title={`${item.label} full size`} className="h-[75dvh] w-full border-0" />}</div>
    </dialog>}
  </div>
}
