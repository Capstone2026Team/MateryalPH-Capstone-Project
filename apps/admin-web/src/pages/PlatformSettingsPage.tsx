import { Button, EventTimeline, FactList, InfoNote, ReasonedDecisionForm, SidePanel, StatusBadge } from '@materyalph/web-ui'
import { CheckCircle2, History, Lock, Pencil, RefreshCw } from 'lucide-react'
import { useMemo, useState } from 'react'
import { control, label as humanize, manilaDateTime, useLoad, useProtectedAction } from '../lib/operations-hooks'
import { isConflict, listSettings, problemText, settingHistory, updateSetting, type PlatformSetting } from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

const RADIUS_KM = [5, 10, 20, 30, 40, 50]

/** Plain-text rendering of a setting value; objects list each field by name. */
function formatSettingValue(value: unknown): string {
  if (value === null || value === undefined) return 'None'
  if (typeof value === 'boolean') return value ? 'On' : 'Off'
  if (Array.isArray(value)) return value.map(item => formatSettingValue(item)).join(', ')
  if (typeof value === 'object') return Object.entries(value as Record<string, unknown>).map(([key, item]) => `${humanize(key)}: ${typeof item === 'object' && item !== null && !Array.isArray(item) ? `(${formatSettingValue(item)})` : formatSettingValue(item)}`).join('; ')
  return String(value)
}

const sumLeaves = (value: unknown): number => typeof value === 'number' ? value : typeof value === 'object' && value !== null ? Object.values(value).reduce<number>((sum, item) => sum + sumLeaves(item), 0) : 0

/** Structured value display: objects render as one chip per field, everything else as plain text. */
function SettingValue({ value, muted = false }: { value: unknown; muted?: boolean }) {
  if (value === null || value === undefined) return <span className="text-sm text-text-secondary">None</span>
  if (typeof value !== 'object' || Array.isArray(value)) return <span className={`text-sm ${muted ? 'text-text-secondary' : 'font-semibold text-text-strong'}`}>{formatSettingValue(value)}</span>
  return <ul className="flex flex-wrap gap-2">{Object.entries(value as Record<string, unknown>).map(([key, item]) => <li key={key} className={`rounded-pill border px-3 py-1 text-sm ${muted ? 'border-border-default bg-surface-primary text-text-secondary' : 'border-brand-orange-300 bg-surface-primary font-semibold text-text-strong'}`}>{humanize(key)}: {typeof item === 'object' && item !== null && !Array.isArray(item) ? `(${formatSettingValue(item)})` : formatSettingValue(item)}</li>)}</ul>
}

function setAt(value: unknown, path: string[], next: unknown): unknown {
  if (path.length === 0) return next
  const [head = '', ...rest] = path
  const base = (typeof value === 'object' && value !== null && !Array.isArray(value) ? value : {}) as Record<string, unknown>
  return { ...base, [head]: setAt(base[head], rest, next) }
}

function ValueEditor({ settingKey, value, path, onChange, errors }: { settingKey: string; value: unknown; path: string[]; onChange: (path: string[], value: unknown) => void; errors: Record<string, string> }) {
  const name = ['value', ...path].join('.')
  const fieldLabel = path.length ? humanize(path[path.length - 1]) : 'Value'
  const error = errors[name]
  const errorId = `${name}-error`
  const described = error ? { 'aria-invalid': true, 'aria-describedby': errorId } : {}
  const message = error ? <span id={errorId} role="alert" className="text-sm font-normal text-status-error">{error}</span> : null
  if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
    const entries = Object.entries(value as Record<string, unknown>)
    const fieldset = <fieldset className={`grid min-w-0 gap-3 ${path.length ? 'rounded-control border border-border-default p-3' : ''} sm:grid-cols-2`}>
      {path.length > 0 && <legend className="px-1 text-sm font-semibold">{fieldLabel}</legend>}
      {entries.map(([key, item]) => <div key={key} className={typeof item === 'object' && item !== null && !Array.isArray(item) ? 'sm:col-span-2' : ''}><ValueEditor settingKey={settingKey} value={item} path={[...path, key]} onChange={onChange} errors={errors} /></div>)}
      {message && <div className="sm:col-span-2">{message}</div>}
    </fieldset>
    return fieldset
  }
  if (typeof value === 'boolean') return <label className="flex min-h-11 items-center gap-3 text-sm font-semibold"><input type="checkbox" className="h-5 w-5" checked={value} onChange={event => onChange(path, event.target.checked)} {...described} />{fieldLabel}{message}</label>
  if (settingKey.endsWith('_radius_km')) return <label className="grid gap-2 text-sm font-semibold">{fieldLabel} (km)<select className={control} value={String(value)} onChange={event => onChange(path, Number(event.target.value))} {...described}>{RADIUS_KM.map(km => <option key={km} value={km}>{km} km</option>)}</select>{message}</label>
  if (Array.isArray(value)) return <label className="grid gap-2 text-sm font-semibold">{fieldLabel}<input className={control} inputMode="numeric" defaultValue={value.join(', ')} onChange={event => onChange(path, event.target.value.split(',').map(item => item.trim()).filter(Boolean).map(Number))} {...described} /><span className="text-[13px] font-normal text-text-secondary">Separate values with commas.</span>{message}</label>
  if (typeof value === 'string') return <label className="grid gap-2 text-sm font-semibold">{fieldLabel}<input className={control} inputMode="decimal" value={value} onChange={event => onChange(path, event.target.value)} {...described} />{message}</label>
  return <label className="grid gap-2 text-sm font-semibold">{fieldLabel}<input className={control} type="number" inputMode="numeric" step={1} value={Number.isFinite(value as number) ? String(value) : ''} onChange={event => onChange(path, event.target.value === '' ? null : Number(event.target.value))} {...described} />{message}</label>
}

function SettingEditor({ setting, onSaved, onClose }: { setting: PlatformSetting; onSaved: (next: PlatformSetting) => void; onClose: () => void }) {
  const [draft, setDraft] = useState<unknown>(() => structuredClone(setting.value))
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<string | null>(null)
  const [fields, setFields] = useState<Record<string, string>>({})
  const { run, busy, dialog } = useProtectedAction()
  const weights = setting.key.startsWith('ranking.')
  const total = weights ? sumLeaves(draft) : null
  async function save(reason: string) {
    setError(null); setConflict(null); setFields({})
    const result = await run(`Verify to change ${setting.label}`, () => updateSetting(setting.key, draft, setting.version, reason))
    if (result.ok) { onSaved(result.value); return }
    if (isConflict(result.problem)) setConflict('Another Admin saved a newer version of this setting. Reload to review it before changing it again.')
    else { setFields(result.problem.fields); setError(problemText(result.problem)) }
  }
  const unit = (value: unknown) => setting.key.endsWith('_radius_km') && typeof value === 'number' ? `${value} km` : value
  return <SidePanel open title={`Change ${setting.label}`} description="Changes apply to new records only and are versioned." onClose={onClose}>
    <div className="grid gap-5">
      <div className="rounded-control border border-border-default bg-surface-canvas p-4"><FactList columns={1} facts={[{ label: 'Applies to', value: setting.appliesTo }, { label: 'Validation rule', value: setting.validationRule }]} /></div>
      <ReasonedDecisionForm title="New value" target={setting.label} version={setting.version} before={<SettingValue value={unit(setting.value)} muted />} after={<SettingValue value={unit(draft)} />} submitLabel="Save new version" busy={busy} error={error} conflict={conflict} onReload={() => window.location.reload()} minReason={10} maxReason={500} onSubmit={reason => void save(reason)}>
        <ValueEditor settingKey={setting.key} value={draft} path={[]} errors={fields} onChange={(path, value) => setDraft((current: unknown) => setAt(current, path, value))} />
        {total !== null && <p aria-live="polite" className={`rounded-control border px-3 py-2 text-sm font-semibold ${total === 100 ? 'border-status-success/30 bg-green-50 text-status-success' : 'border-status-error/30 bg-red-50 text-status-error'}`}>Total: {total}% {total === 100 ? '(valid)' : '— the weights must total exactly 100%'}</p>}
      </ReasonedDecisionForm>
    </div>
    {dialog}
  </SidePanel>
}

function SettingHistory({ setting, onClose }: { setting: PlatformSetting; onClose: () => void }) {
  const history = useLoad(() => settingHistory(setting.key), [setting.key])
  return <SidePanel open title={`${setting.label} history`} description="Append-only versions, newest first." onClose={onClose}>
    <div>
      {history.error ? <ErrorState message={history.error} onRetry={history.retry} /> : !history.data ? <LoadingState /> :
        <EventTimeline label={`${setting.label} versions`} formatDate={manilaDateTime} empty="Only the approved default exists; no version has been stored."
          events={history.data.map(version => ({ id: String(version.version), title: `Version ${version.version} · ${version.source === 'SEED' ? 'Approved default' : 'Admin change'}`, at: version.effectiveFrom, actor: version.changedBy ? `${version.changedBy}${version.changedRole ? ` (${version.changedRole})` : ''}` : 'System',
            detail: <div className="grid gap-1"><p><span className="font-semibold">Value:</span> {formatSettingValue(version.value)}</p>{version.previousValue !== null && version.previousValue !== undefined && <p className="text-text-secondary">Previous: {formatSettingValue(version.previousValue)}</p>}<p className="text-text-secondary">Reason: {version.reason}</p>{version.correlationId && <p className="break-all text-[13px] text-text-secondary">Correlation ID {version.correlationId}</p>}</div> }))} />}
    </div>
  </SidePanel>
}

export function AdminPlatformSettingsPage() {
  const settings = useLoad(listSettings, [])
  const [editing, setEditing] = useState<PlatformSetting | null>(null)
  const [viewing, setViewing] = useState<PlatformSetting | null>(null)
  const [saved, setSaved] = useState<string | null>(null)
  const groups = useMemo(() => {
    const map = new Map<string, PlatformSetting[]>()
    for (const item of settings.data?.items ?? []) map.set(item.group, [...(map.get(item.group) ?? []), item])
    return [...map.entries()]
  }, [settings.data])
  return <AdminShell activeHref="/settings"><div className="space-y-6">
    <PageHeader eyebrow="Platform" title="Platform Settings" description="Versioned, non-secret operational defaults. Each change records your reason, the previous value and a correlation ID, and applies to new records only."
      actions={<Button variant="secondary" disabled={settings.loading} onClick={settings.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <InfoNote>Credentials, provider keys, LIVE commerce, VPS weights, the radius values and any NRPC cap are not settings. Changing a value requires the Platform Settings permission and identity verification.</InfoNote>
    {saved && <p role="status" className="flex items-start gap-3 rounded-control border border-status-success/30 bg-green-50 px-4 py-3 text-sm text-green-900"><CheckCircle2 size={18} className="mt-0.5 shrink-0" aria-hidden="true" />{saved}</p>}
    {settings.error ? <ErrorState message={settings.error} onRetry={settings.retry} /> : !settings.data ? <LoadingState /> : <>
      {!settings.data.canManage && <p className="text-sm text-text-secondary">You can view settings. Changing them requires the Platform Settings management permission.</p>}
      {groups.map(([group, items]) => <section key={group} aria-labelledby={`group-${group}`} className="space-y-4">
        <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1 border-b border-border-default pb-3"><h2 id={`group-${group}`} className="text-lg font-semibold">{group}</h2><span className="text-sm text-text-secondary">{items.length} {items.length === 1 ? 'setting' : 'settings'}</span></div>
        <div className="grid gap-5 xl:grid-cols-2">{items.map(item => <article key={item.key} className="flex min-w-0 flex-col gap-5 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6">
          <header className="flex flex-wrap items-start justify-between gap-3"><div className="min-w-0 flex-1"><h3 className="break-words text-base font-semibold">{item.label}</h3><p className="mt-1 text-sm leading-6 text-text-secondary">{item.description}</p></div>
            <StatusBadge label={item.version === 0 ? 'Approved default' : `Version ${item.version}`} tone={item.version === 0 ? 'neutral' : 'info'} /></header>
          <div className="grid gap-4 rounded-control border border-border-default bg-surface-canvas p-4">
            <div><p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Current value</p><div className="mt-2"><SettingValue value={item.value} /></div></div>
            <div className="border-t border-border-default pt-4"><p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Previous value</p><div className="mt-2"><SettingValue value={item.previousValue} muted /></div></div>
          </div>
          <FactList facts={[
            { label: 'Applies to', value: item.appliesTo },
            { label: 'Validation rule', value: item.validationRule },
          ]} />
          <footer className="mt-auto flex flex-wrap items-end justify-between gap-4 border-t border-border-default pt-4">
            <p className="min-w-0 flex-1 text-[13px] leading-5 text-text-secondary"><span className="font-medium text-text-strong">Last changed</span> · {item.updatedAt ? `${manilaDateTime(item.updatedAt)}${item.updatedBy ? ` by ${item.updatedBy}` : ''}` : 'Never changed'}{item.lastReason && <><br /><span className="font-medium text-text-strong">Reason</span> · {item.lastReason}</>}</p>
            <div className="flex flex-wrap gap-2">
              {settings.data?.canManage && item.editable && <Button onClick={() => { setSaved(null); setEditing(item) }}><Pencil size={16} aria-hidden="true" />Change</Button>}
              <Button variant="secondary" onClick={() => setViewing(item)}><History size={16} aria-hidden="true" />Version history</Button>
            </div>
          </footer>
        </article>)}</div>
      </section>)}
      <section aria-labelledby="fixed-rules" className="space-y-3">
        <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1 border-b border-border-default pb-3"><h2 id="fixed-rules" className="text-lg font-semibold">Fixed rules (no control)</h2><span className="text-sm text-text-secondary">Set by the workflows; not editable here</span></div>
        <ul className="grid gap-3 md:grid-cols-2">{settings.data.fixed.map(item => <li key={item.key} className="flex gap-3 rounded-surface border border-dashed border-border-default bg-surface-canvas p-4">
          <Lock size={18} aria-hidden="true" className="mt-0.5 shrink-0 text-text-secondary" />
          <div className="min-w-0"><p className="font-semibold">{item.label}: <span className="font-normal">{item.value === null ? 'No cap' : formatSettingValue(item.value)}</span></p><p className="mt-1 text-sm text-text-secondary">{item.reason}</p></div>
        </li>)}</ul>
      </section>
    </>}
    {editing && <SettingEditor setting={editing} onClose={() => setEditing(null)} onSaved={next => { setEditing(null); setSaved(`${next.label} saved as version ${next.version}. It applies to new records only.`); if (settings.data) settings.set({ ...settings.data, items: settings.data.items.map(item => item.key === next.key ? next : item) }) }} />}
    {viewing && <SettingHistory setting={viewing} onClose={() => setViewing(null)} />}
  </div></AdminShell>
}
