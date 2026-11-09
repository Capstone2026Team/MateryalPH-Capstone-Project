import { AsyncLoading } from './async-state'
import { useEffect, useState } from 'react'
import type { AutomatedResponseSettings } from '@materyalph/api-client-ts'
import { Button } from './button'
import { FormDialog } from './form-dialog'
import { StatusMessage } from './status-message'

export function AutomatedResponseSettingsDialog({ load, save, onClose }: {
  load: () => Promise<AutomatedResponseSettings>
  save: (settings: AutomatedResponseSettings, key: string) => Promise<unknown>
  onClose: () => void
}) {
  const [value, setValue] = useState<AutomatedResponseSettings | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [key, setKey] = useState(() => crypto.randomUUID())
  useEffect(() => {
    let active = true
    load().then(settings => { if (active) { setValue(settings); setError(null) } }).catch(cause => { if (active) setError(cause instanceof Error ? cause.message : 'Unable to load settings. Please retry.') })
    return () => { active = false }
  }, [load, attempt])
  function update(next: Partial<AutomatedResponseSettings>) {
    setValue(current => current ? { ...current, ...next } : current)
    setKey(crypto.randomUUID())
  }
  return <FormDialog open size="compact" title="Automated Response Settings" description="Manage your store's instant replies."
    busy={busy} onClose={onClose} footer={<div className="flex flex-wrap justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={onClose}>Cancel</Button><Button type="submit" form="automated-response-form" disabled={!value || busy}>{busy ? 'Saving…' : 'Save Changes'}</Button></div>}>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    {!value ? <div className="py-6">{error ? <Button variant="secondary" onClick={() => setAttempt(value => value + 1)}>Retry settings</Button> : <AsyncLoading compact label="Loading settings…" />}</div> : <form id="automated-response-form" className="grid gap-6" onSubmit={event => {
      event.preventDefault(); setBusy(true); setError(null)
      void save(value, key).then(onClose).catch(cause => setError(cause instanceof Error ? cause.message : 'Unable to save changes. Please retry.')).finally(() => setBusy(false))
    }}>
      <p className="text-sm text-text-secondary">Set up an automated bot to instantly reply to buyers when they first message you. You can still step in and reply manually at any time.</p>
      <div className="flex items-center justify-between gap-4 border-b border-border-default pb-5"><div><p id="automated-response-label" className="font-semibold">Automated responses</p><p className="mt-1 text-sm text-text-secondary">{value.enabled ? 'On · replies once per thread every 24 hours' : 'Off · buyers receive your manual replies'}</p></div>
        <button type="button" role="switch" aria-labelledby="automated-response-label" aria-checked={value.enabled} disabled={busy} onClick={() => update({ enabled: !value.enabled })} className={`relative flex h-11 w-16 shrink-0 items-center rounded-full border p-1 ${value.enabled ? 'border-action-primary bg-action-primary' : 'border-border-default bg-surface-canvas'}`}><span aria-hidden="true" className={`size-7 rounded-full border border-border-default bg-surface-primary ${value.enabled ? 'translate-x-6' : ''}`} /><span className="sr-only">{value.enabled ? 'On' : 'Off'}</span></button>
      </div>
      <label className="grid gap-2 text-sm font-semibold">Welcome message<textarea rows={4} maxLength={5000} required={value.enabled} disabled={busy} value={value.welcomeMessage} onChange={event => update({ welcomeMessage: event.target.value })} className="w-full rounded-control border border-border-default bg-surface-primary p-3 font-normal" placeholder="Hello! Thank you for messaging our store. Our team will be with you shortly." /></label>
      <fieldset disabled={busy} className="grid min-w-0 gap-4"><legend className="mb-2 font-semibold">Quick reply buttons <span className="text-sm font-normal text-text-secondary">Optional · up to 3</span></legend>
        {value.options.map((option, index) => <div key={index} className="grid gap-3 border-t border-border-default pt-4">
          <div className="flex items-center justify-between gap-3"><span className="text-sm font-semibold">Button {index + 1}</span><Button variant="quiet" aria-label={`Remove quick reply ${index + 1}`} onClick={() => update({ options: value.options.filter((_, i) => i !== index) })}>Remove</Button></div>
          <label className="grid gap-2 text-sm">Button label<input required maxLength={80} value={option.label} onChange={event => update({ options: value.options.map((item, i) => i === index ? { ...item, label: event.target.value } : item) })} className="min-h-11 rounded-control border border-border-default bg-surface-primary px-3" placeholder="Check store hours" /></label>
          <label className="grid gap-2 text-sm">Exact response<textarea required rows={3} maxLength={5000} value={option.response} onChange={event => update({ options: value.options.map((item, i) => i === index ? { ...item, response: event.target.value } : item) })} className="rounded-control border border-border-default bg-surface-primary p-3" /></label>
        </div>)}
        {value.options.length < 3 && <Button variant="secondary" onClick={() => update({ options: [...value.options, { label: '', response: '' }] })}>Add quick reply</Button>}
      </fieldset>
      <p className="text-sm text-text-secondary">Replies use only the text you save here. Buyer messages remain open for your team. Sending a manual reply ends the automated sequence.</p>
    </form>}
  </FormDialog>
}
