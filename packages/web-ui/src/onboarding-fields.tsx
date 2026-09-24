import { useEffect, useRef, useState, type ReactNode } from 'react'
import { Button } from './button'

export function FieldRow({ children }: { children: ReactNode }) {
  return <div className="grid min-w-0 gap-5 md:grid-cols-2 [&>*:only-child]:col-span-full">{children}</div>
}

export function AuthorityScopePanel({ selected = [] }: { selected?: string[] }) {
  return <fieldset className="grid gap-2"><legend className="font-semibold">Requested authority scopes</legend>{['TAX_DECLARATIONS', 'COMMISSION_AGREEMENT', 'PAYMENT_CONFIGURATION'].map(scope => <label key={scope} className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" name="authority_scopes" value={scope} defaultChecked={selected.includes(scope)} />{scope.replaceAll('_', ' ')}</label>)}<p className="text-sm text-text-secondary">Requested scopes require an explicit Admin decision for the current representative. Account access alone does not establish authority.</p></fieldset>
}

export function DocumentUploadField({ label, name, pdfOnly = false, busy = false, disabled = false, file, savedFile, error = '', onChange, onPreview }: {
  label: string; name: string; pdfOnly?: boolean; busy?: boolean; disabled?: boolean;
  file: File | null; savedFile?: { name: string; size: number } | undefined; error?: string | undefined;
  onChange: (file: File | null) => void; onPreview?: (() => void) | undefined;
}) {
  const inputRef = useRef<HTMLInputElement>(null)
  const [url, setUrl] = useState('')
  const [localError, setLocalError] = useState('')
  const errorId = `${name}-error`
  const message = localError || error
  useEffect(() => {
    if (!file) { setUrl(''); return }
    const objectUrl = URL.createObjectURL(file)
    setUrl(objectUrl)
    return () => URL.revokeObjectURL(objectUrl)
  }, [file])
  const selected = file ?? savedFile
  return <div className="grid min-w-0 content-start gap-3">
    <label className={`grid min-h-40 min-w-0 cursor-pointer place-items-center gap-3 rounded-control border border-dashed bg-surface-canvas p-4 text-center focus-within:ring-2 focus-within:ring-focus-ring ${message ? 'border-status-error' : 'border-border-default'} ${busy || disabled ? 'opacity-50' : 'hover:border-action-primary'}`}>
      {url && file?.type.startsWith('image/') ? <img src={url} alt={`${label} selected preview`} className="h-40 w-full max-w-full object-contain" /> : <span className="text-sm text-text-secondary">{selected ? 'Document selected' : pdfOnly ? 'PDF, up to 10 MB' : 'JPG, JPEG, PNG or PDF, up to 10 MB'}</span>}
      <span className="font-semibold text-action-primary">{selected ? 'Change file' : 'Choose file'}</span>
      <input ref={inputRef} id={name} type="file" className="sr-only" aria-label={`Select ${label}`} aria-invalid={Boolean(message)} aria-describedby={message ? errorId : undefined} accept={pdfOnly ? '.pdf,application/pdf' : '.jpg,.jpeg,.png,.pdf,image/jpeg,image/png,application/pdf'} disabled={busy || disabled} onChange={event => {
        const chosen = event.target.files?.[0]
        event.target.value = ''
        if (!chosen) return
        const extension = chosen.name.split('.').pop()?.toLowerCase() ?? ''
        const types: Record<string, string> = pdfOnly ? { pdf: 'application/pdf' } : { jpg: 'image/jpeg', jpeg: 'image/jpeg', png: 'image/png', pdf: 'application/pdf' }
        if (!chosen.size || chosen.size > 10 * 1024 * 1024 || !types[extension] || types[extension] !== chosen.type) {
          setLocalError(pdfOnly ? 'Select a non-empty PDF up to 10 MB.' : 'Select a non-empty JPG, JPEG, PNG or PDF up to 10 MB with a matching file type.'); return
        }
        setLocalError(''); onChange(chosen)
      }} />
    </label>
    {selected && <><p className="break-all text-sm">{selected.name} · {(selected.size / 1024 / 1024).toFixed(2)} MB</p><p className="text-sm font-medium">Pending Submission</p><div className="flex flex-wrap gap-2">
      {(file?.type === 'application/pdf' || (!file && onPreview)) && <Button type="button" variant="secondary" onClick={() => file ? window.open(url, '_blank', 'noopener,noreferrer') : onPreview?.()}>Preview document</Button>}
      <Button type="button" variant="quiet" disabled={busy || disabled} onClick={() => { setLocalError(''); onChange(null) }}>Remove</Button>
    </div></>}
    {message && <p id={errorId} role="alert" className="text-sm text-status-error">{message}</p>}
  </div>
}

export function OnboardingFormSection({ title, description, children, panel = false, region = false }: { title: string; description?: string; children: ReactNode; panel?: boolean; region?: boolean }) {
  if (!panel) return <fieldset className="grid min-w-0 gap-5 border-t border-border-default pt-6"><legend className="text-lg font-semibold">{title}</legend>{description && <p className="-mt-2 max-w-2xl text-sm leading-6 text-text-secondary">{description}</p>}{children}</fieldset>
  return <section role={region ? 'region' : 'group'} aria-label={title} className="min-w-0 overflow-hidden rounded-surface border border-border-default bg-surface-primary">
    <header className="border-b border-border-default bg-surface-canvas px-4 py-4 sm:px-6 sm:py-5">
      <h3 className="text-lg font-semibold leading-6 text-text-strong">{title}</h3>
      {description && <p className="mt-2 max-w-3xl text-sm leading-6 text-text-secondary">{description}</p>}
    </header>
    <div className="grid min-w-0 gap-5 p-4 sm:p-6">{children}</div>
  </section>
}
