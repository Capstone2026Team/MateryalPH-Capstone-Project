import { useEffect, useState } from 'react'
import { FileText } from 'lucide-react'
import { Button } from './button'

/** Local selections only: previews never upload files or request a private storage URL. */
export function FileSelectionReview({ files, onRemove, disabled = false }: {
  files: File[]; onRemove: (index: number) => void; disabled?: boolean
}) {
  if (!files.length) return null
  return <div className="grid min-w-0 gap-3">
    <p className="text-sm font-semibold" role="status">Selected files ({files.length}) · review before submitting</p>
    <ul aria-label="Selected evidence files" className={`grid min-w-0 gap-3 ${files.length > 1 ? 'sm:grid-cols-2' : ''}`}>
      {files.map((file, index) => <li key={`${file.name}-${file.size}-${file.lastModified}-${index}`} className="min-w-0 rounded-control border border-border-default bg-surface-primary p-3">
        <SelectedFile file={file} disabled={disabled} onRemove={() => onRemove(index)} />
      </li>)}
    </ul>
    <p className="text-xs text-text-secondary">Pending upload. Files are attached when you submit the form.</p>
  </div>
}

function SelectedFile({ file, onRemove, disabled }: { file: File; onRemove: () => void; disabled: boolean }) {
  const [preview, setPreview] = useState<{ file: File; url: string } | null>(null)
  const [failed, setFailed] = useState(false)
  const image = ['image/jpeg', 'image/png', 'image/webp'].includes(file.type)
  const supported = image || file.type === 'application/pdf'
  useEffect(() => {
    setFailed(false)
    if (!supported) { setPreview(null); return }
    const url = URL.createObjectURL(file)
    setPreview({ file, url })
    return () => URL.revokeObjectURL(url)
  }, [file, supported])
  const url = preview?.file === file ? preview.url : null
  return <div className="grid min-w-0 gap-3">
    {image && url && !failed
      ? <img src={url} alt={`Selected evidence preview: ${file.name}`} className="h-32 w-full rounded-control bg-surface-canvas object-contain" onError={() => setFailed(true)} />
      : <div className="grid h-32 place-content-center justify-items-center gap-2 rounded-control bg-surface-canvas text-text-secondary"><FileText size={28} aria-hidden="true" /><span className="text-xs">{failed ? 'Image preview unavailable' : file.type === 'application/pdf' ? 'PDF document' : 'Preview unavailable'}</span></div>}
    <div className="min-w-0"><p className="break-all text-sm font-semibold">{file.name}</p><p className="mt-1 text-xs text-text-secondary">{(file.size / 1024 / 1024).toFixed(2)} MB · Selected</p></div>
    <div className="flex flex-wrap items-center justify-between gap-2">
      {url && <a href={url} target="_blank" rel="noopener noreferrer" aria-label={`Preview ${file.name}`} className="inline-flex min-h-11 items-center rounded-control px-2 text-sm font-semibold text-action-primary underline underline-offset-4 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">Preview file</a>}
      <Button variant="quiet" disabled={disabled} aria-label={`Remove ${file.name}`} onClick={onRemove}>Remove</Button>
    </div>
  </div>
}
