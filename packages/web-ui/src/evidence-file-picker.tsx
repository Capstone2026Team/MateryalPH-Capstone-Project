import { useId, useRef, useState } from 'react'
import { Upload } from 'lucide-react'
import { Button } from './button'
import { FileSelectionReview } from './file-selection-review'
import { StatusMessage } from './status-message'

const accepted = ['image/jpeg', 'image/png', 'image/webp', 'application/pdf']

/** Select and review locally; the parent form owns the authorized upload. */
export function EvidenceFilePicker({ label, file, onChange, disabled = false }: {
  label: string; file: File | null; onChange: (file: File | null) => void; disabled?: boolean
}) {
  const id = useId()
  const input = useRef<HTMLInputElement>(null)
  const [error, setError] = useState('')
  return <div className="grid min-w-0 gap-3">
    <label htmlFor={id} className="text-sm font-semibold">{label}</label>
    <input ref={input} id={id} type="file" className="sr-only" tabIndex={-1} accept={accepted.join(',')} disabled={disabled} onChange={event => {
      const selected = event.target.files?.[0]
      event.target.value = ''
      if (!selected) return
      if (!accepted.includes(selected.type) || selected.size === 0 || selected.size > 10 * 1024 * 1024) {
        setError('Choose a JPG, PNG, WebP or PDF file up to 10 MB.'); return
      }
      setError(''); onChange(selected)
    }} />
    <Button variant="secondary" disabled={disabled} onClick={() => input.current?.click()}><Upload size={16} aria-hidden="true" />{file ? 'Replace file' : 'Choose file'}</Button>
    <p className="text-xs text-text-secondary">JPG, PNG, WebP or PDF up to 10 MB. Stored privately after submission.</p>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <FileSelectionReview files={file ? [file] : []} disabled={disabled} onRemove={() => { setError(''); onChange(null) }} />
  </div>
}
