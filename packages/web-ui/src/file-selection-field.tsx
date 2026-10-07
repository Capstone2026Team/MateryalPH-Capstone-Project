import { useEffect, useId, useRef, useState } from 'react'
import { FileImage, Upload } from 'lucide-react'
import { Button } from './button'

export function FileSelectionField({ label, accept, hint, chooseLabel = 'Choose file', file, disabled = false, required = false, error, onChange }: {
  label: string; accept: string; hint: string; chooseLabel?: string;
  file: File | null; disabled?: boolean; required?: boolean; error?: string | undefined;
  onChange: (file: File | null) => void;
}) {
  const id = useId()
  const input = useRef<HTMLInputElement>(null)
  const [preview, setPreview] = useState<{ file: File; url: string } | null>(null)
  const [failedPreview, setFailedPreview] = useState<string | null>(null)
  useEffect(() => {
    if (!file || !['image/jpeg', 'image/png'].includes(file.type)) {
      setPreview(null)
      return
    }
    const url = URL.createObjectURL(file)
    setPreview({ file, url })
    setFailedPreview(null)
    return () => URL.revokeObjectURL(url)
  }, [file])
  const currentPreview = preview?.file === file ? preview : null
  return <div className="grid min-w-0 content-start gap-2">
    <label htmlFor={id} className="text-sm font-semibold">{label}{required && <span className="text-status-error"> *<span className="sr-only"> (required)</span></span>}</label>
    <div className={`flex min-w-0 flex-wrap items-center gap-3 rounded-control border bg-surface-primary p-3 ${error ? 'border-status-error' : 'border-border-default'}`}>
      <label className={`relative inline-flex min-h-11 shrink-0 items-center justify-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold text-text-strong focus-within:ring-2 focus-within:ring-focus-ring focus-within:ring-offset-2 ${disabled ? 'opacity-50' : 'cursor-pointer hover:bg-surface-canvas'}`}>
        <Upload size={16} aria-hidden="true" />{file ? 'Change file' : chooseLabel}
        <input ref={input} id={id} type="file" accept={accept} disabled={disabled} aria-required={required} aria-invalid={Boolean(error)} aria-describedby={`${id}-hint${error ? ` ${id}-error` : ''}`} className="sr-only" onChange={event => {
          const selected = event.target.files?.[0]
          if (selected) onChange(selected)
        }} />
      </label>
      <div className="min-w-0 flex-1 basis-40" aria-live="polite">
        {file && <p className="flex items-start gap-1.5 text-sm font-medium"><FileImage size={16} className="mt-0.5 shrink-0 text-text-secondary" aria-hidden="true" /><span className="min-w-0 break-all">{file.name}</span></p>}
        <p id={`${id}-hint`} className="text-xs leading-5 text-text-secondary">{file ? 'Selected · ' : ''}{hint}</p>
      </div>
      {file && <Button type="button" variant="quiet" disabled={disabled} aria-label={`Remove ${label.toLowerCase()}`} onClick={() => {
        if (input.current) input.current.value = ''
        onChange(null)
        input.current?.focus()
      }}>Remove</Button>}
      {currentPreview && <figure className="min-w-0 basis-full border-t border-border-default pt-3">
        {failedPreview === currentPreview.url
          ? <p role="status" className="rounded-control bg-surface-canvas p-4 text-sm text-text-secondary">This image could not be previewed. Choose another photo to review it.</p>
          : <img src={currentPreview.url} alt={`Selected image preview: ${file?.name}`} className="max-h-80 w-full rounded-control bg-surface-canvas object-contain" onError={() => setFailedPreview(currentPreview.url)} />}
        <figcaption className="mt-2 text-xs text-text-secondary">Selected image · review before submitting.</figcaption>
      </figure>}
    </div>
    {error && <p id={`${id}-error`} className="text-sm text-status-error" role="alert">{error}</p>}
  </div>
}
