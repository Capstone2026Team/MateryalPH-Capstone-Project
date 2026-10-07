import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { NotificationsApi, ReportingApi, type TaxPackage, type TaxPackageInput, type DeliveryFailure } from '@materyalph/api-client-ts'
import { Button, enableWebPush, NotificationsWorkspace, createWebApiConfiguration, notificationError } from '@materyalph/web-ui'
import { AdminShell } from './PhaseThreeAdminPages'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
export function AdminNotificationsPage() {
  const navigate = useNavigate()
  return <AdminShell activeHref="/notifications"><div className="grid gap-5"><nav className="flex flex-wrap gap-5"><Link className="inline-flex min-h-11 items-center text-action-primary underline" to="/reports/tax">Tax support packages</Link><Link className="inline-flex min-h-11 items-center text-action-primary underline" to="/notifications/failures">Delivery exceptions</Link></nav><NotificationsWorkspace basePath={basePath} audience="admin" navigate={navigate} {...(import.meta.env.VITE_FIREBASE_PUSH_ENABLED === 'true' ? { enablePush: () => enableWebPush(basePath, 'admin', { apiKey: import.meta.env.VITE_FIREBASE_API_KEY, appId: import.meta.env.VITE_FIREBASE_APP_ID, projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID, messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID }, import.meta.env.VITE_FIREBASE_VAPID_KEY) } : {})} /></div></AdminShell>
}

export function AdminDeliveryFailuresPage() {
  const [items, setItems] = useState<DeliveryFailure[]>([])
  const [error, setError] = useState('')
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(false)
  async function load(number = 1) {
    try { const result = await new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })).listNotificationFailures({ page: number }); setItems(old => number === 1 ? result.data : [...old, ...result.data]); setHasMore(result.meta.has_more === true); setPage(number); setError('') }
    catch (cause) { setError(await notificationError(cause)) }
  }
  useEffect(() => { void load() }, [])
  return <AdminShell activeHref="/notifications"><h1 className="text-2xl font-semibold">Delivery exceptions</h1><p className="my-4 text-text-secondary">External deliveries that exhausted their five attempts. Original business transactions remain recorded.</p>{error && <p role="alert">{error}</p>}<Button variant="secondary" onClick={() => void load()}>Refresh</Button><ul className="mt-5 divide-y divide-border-default">{items.map(item => <li key={item.id} className="py-4"><strong>{item.channel} · {item.state}</strong><p className="text-sm">{item.attemptCount} attempts · {item.failureCode}</p><p className="break-all text-xs text-text-secondary">Delivery reference: {item.id}</p></li>)}</ul>{!items.length && !error && <p className="mt-5">No failed deliveries to show.</p>}{hasMore && <Button variant="secondary" onClick={() => void load(page + 1)}>Load more</Button>}</AdminShell>
}

export function AdminTaxPackagesPage() {
  const { packageId } = useParams()
  const navigate = useNavigate()
  const api = useMemo(() => new ReportingApi(createWebApiConfiguration(basePath, { refreshSession: true })), [])
  const [items, setItems] = useState<TaxPackage[]>([])
  const [detail, setDetail] = useState<TaxPackage | null>(null)
  const [form, setForm] = useState<TaxPackageInput['form']>('1601-EQ')
  const [entity, setEntity] = useState<TaxPackageInput['withholdingEntity']>('DEMO_PLATFORM_WITHHOLDER')
  const [period, setPeriod] = useState('')
  const [vendor, setVendor] = useState('')
  const prepareKey = useRef({ scope: '', key: crypto.randomUUID() })
  const [due, setDue] = useState('')
  const [source, setSource] = useState('')
  const [reason, setReason] = useState('')
  const [reconciled, setReconciled] = useState(false)
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)
  const [status, setStatus] = useState('')
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(false)
  const load = useCallback(async (number = 1) => {
    try {
      if (packageId) { const result = await api.getTaxPackage({ packageId }); setDetail(result.data) }
      else { const result = await api.listTaxPackages({ page: number }); setItems(old => number === 1 ? result.data : [...old, ...result.data]); setHasMore(result.meta.has_more === true); setPage(number) }
    } catch (cause) { setError(await notificationError(cause)) }
  }, [api, packageId])
  useEffect(() => { void load() }, [load])
  async function action(work: () => Promise<void>) { setBusy(true); setError(''); try { await work() } catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) } }
  const control = 'mt-1 min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3'
  return <AdminShell activeHref="/finance"><div className="grid gap-6"><Link to="/notifications" className="inline-flex min-h-11 items-center text-action-primary underline">Back to notifications & exports</Link><header><h1 className="text-2xl font-semibold">Tax support packages</h1><p className="mt-2 text-text-secondary">SAMPLE / DEMO · No BIR submission. Calendar reporting periods are separate from taxable-year threshold counters.</p></header>{error && <p role="alert">{error}</p>}{status && <p role="status">{status}</p>}
    {!packageId ? <><form className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-5" onSubmit={event => { event.preventDefault(); void action(async () => { const scope = JSON.stringify([form, period, entity, vendor]); if (prepareKey.current.scope !== scope) prepareKey.current = { scope, key: crypto.randomUUID() }; const result = await api.prepareTaxPackage({ idempotencyKey: prepareKey.current.key, taxPackageInput: { form, periodStart: period, withholdingEntity: entity, vendorOrganizationId: vendor || null } }); navigate(`/reports/tax/${result.data.id}`) }) }}><div className="grid gap-4 sm:grid-cols-2"><label>Support form<select className={control} value={form} onChange={e => setForm(e.target.value as TaxPackageInput['form'])}>{['2307', '0619-E', '1601-EQ', 'QAP', '1604-E', 'ANNUAL_ALPHALIST'].map(value => <option key={value}>{value}</option>)}</select></label><label>Calendar period start<input className={control} type="date" required value={period} onChange={e => setPeriod(e.target.value)} /></label></div><label>Withholding entity<select className={control} value={entity} onChange={e => setEntity(e.target.value as TaxPackageInput['withholdingEntity'])}><option value="DEMO_PLATFORM_WITHHOLDER">Platform · WI820 / WC820</option><option value="DEMO_PROVIDER_WITHHOLDER">Processor · WI830 / WC830</option></select></label><label>Named Vendor ID {form === '2307' ? '(required)' : '(optional)'}<input className={control} value={vendor} required={form === '2307'} onChange={e => setVendor(e.target.value)} /></label><div><Button type="submit" disabled={busy}>Prepare draft</Button></div></form><ul className="divide-y divide-border-default">{items.map(item => <li key={item.id} className="py-4"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline" to={`/reports/tax/${item.id}`}>{item.packageType} · {item.periodStart} – {item.periodEnd}</Link><p className="text-sm">{item.state} · {item.dueDateReviewerId ? 'Deadline reviewed' : 'DUE_DATE_REVIEW_REQUIRED'}</p></li>)}</ul>{hasMore && <Button variant="secondary" onClick={() => void load(page + 1)}>Load more packages</Button>}</> : detail && <section className="grid gap-5 rounded-surface border border-border-default bg-surface-primary p-5"><h2 className="text-xl font-semibold">{detail.packageType} · {detail.state}</h2><p>{detail.periodStart} – {detail.periodEnd} · {detail.withholdingEntity}</p><p>Nominal due: {detail.nominalDueDate ?? 'Unknown'} · Actual due: {detail.actualDueDate ?? 'Review required'} (Asia/Manila)</p><p className="font-semibold">{detail.dueDateStatus}</p><p className="text-sm text-text-secondary">Source: {detail.dueDateSource} · Reviewer: {detail.dueDateReviewerId ?? 'Required'}</p><details><summary className="min-h-11 cursor-pointer py-3">Source versions, totals and reconciliation exceptions</summary><pre className="max-h-96 overflow-auto whitespace-pre-wrap break-all text-xs">{JSON.stringify(detail.snapshot, null, 2)}</pre></details>
      {detail.state === 'DRAFT' && <form className="grid gap-4 border-t border-border-default pt-5" onSubmit={event => { event.preventDefault(); void action(async () => { await api.reviewTaxPackage({ packageId, taxPackageReview: { lockVersion: detail.lockVersion, actualDueDate: due, dueDateSource: source, reason, reconciled } }); await load() }) }}><h3 className="font-semibold">Independent finance review</h3><p className="text-sm text-text-secondary">The preparer cannot approve this package. Review the applicable form, source reconciliation and current legal calendar; cite any override.</p><label>Reviewed actual due date<input className={control} type="date" required value={due} onChange={e => setDue(e.target.value)} /></label><label>Legal source and version<input className={control} minLength={10} required value={source} onChange={e => setSource(e.target.value)} /></label><label>Review reason<input className={control} minLength={10} required value={reason} onChange={e => setReason(e.target.value)} /></label><label className="flex min-h-11 items-center gap-3"><input type="checkbox" required checked={reconciled} onChange={e => setReconciled(e.target.checked)} />I reconciled issuer, payees, periods, deductions and adjustments.</label><div><Button type="submit" disabled={busy}>Approve reviewed package</Button></div></form>}
      {['REVIEWED', 'EXPORTED'].includes(detail.state) && <div className="flex flex-wrap gap-3"><Button disabled={busy} onClick={() => void action(async () => { await api.requestDocumentExport({ audience: 'admin', idempotencyKey: crypto.randomUUID(), documentExportInput: { type: 'TAX_PACKAGE', format: 'CSV', resourceId: packageId, purpose: 'Reviewed demo tax support package export', filters: {} } }); setStatus('Export queued. Open Documents & exports to download after generation.'); await load() })}>Queue sample export</Button>{detail.state === 'EXPORTED' && <Button variant="secondary" disabled={busy} onClick={() => void action(async () => { await api.recordTaxSimulation({ packageId }); setStatus('SIMULATED_SUBMISSION_RECORDED. No government acknowledgment or payment was created.'); await load() })}>Record demo submission</Button>}</div>}
    </section>}
  </div></AdminShell>
}

