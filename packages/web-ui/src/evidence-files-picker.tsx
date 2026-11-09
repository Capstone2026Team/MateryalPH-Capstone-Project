import { useId, useState } from 'react'
import { Upload } from 'lucide-react'
import { FileSelectionReview } from './file-selection-review'

const limits: Record<string, number> = { 'image/jpeg': 10, 'image/png': 10, 'application/pdf': 10, 'video/mp4': 25, 'video/quicktime': 25 }

/** Review multiple local proof files; the caller uploads through its authorized domain API. */
export function EvidenceFilesPicker({ files, onChange, disabled = false }: { files: File[]; onChange: (files: File[]) => void; disabled?: boolean }) {
  const id = useId()
  const [error, setError] = useState('')
  return <section className="grid min-w-0 gap-3" aria-label="Proof attachments">
    <div className="flex flex-wrap items-center justify-between gap-2">
      <div><h4 className="text-sm font-semibold">Proof attachments <span className="font-normal text-text-secondary">(optional)</span></h4><p id={`${id}-hint`} className="mt-1 text-xs text-text-secondary">Up to 5 files. JPG, PNG or PDF: 10 MB each. MP4 or MOV: 25 MB each.</p></div>
      <label className={`inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default px-3 text-sm font-semibold focus-within:ring-2 focus-within:ring-focus-ring ${disabled ? 'opacity-50' : 'cursor-pointer hover:bg-surface-canvas'}`}>
        <Upload size={16} aria-hidden="true" />Add proof
        <input id={id} type="file" multiple className="sr-only" aria-label="Add proof attachments" aria-describedby={`${id}-hint`} accept={Object.keys(limits).join(',')} disabled={disabled} onChange={event => {
          const added = Array.from(event.target.files ?? [])
          event.target.value = ''
          if (files.length + added.length > 5) { setError('Attach up to 5 proof files.'); return }
          if (added.some(file => !limits[file.type] || file.size < 1 || file.size > limits[file.type]! * 1024 * 1024)) { setError('Choose a supported file within its size limit.'); return }
          setError(''); onChange([...files, ...added])
        }} />
      </label>
    </div>
    {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    <FileSelectionReview files={files} disabled={disabled} compact onRemove={index => { setError(''); onChange(files.filter((_, i) => i !== index)) }} />
    <p className="text-xs text-text-secondary">Stored privately with this decision for authorized enforcement review.</p>
  </section>
}
