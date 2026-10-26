import { useEffect, useState, type ReactNode } from 'react'
import { Check, Pause } from 'lucide-react'
import { Button, Field, FormDialog, ProfileDetails, ProfileSplitPanel, PrivateEvidenceButton, RevealableValue, StatusBadge, StatusMessage, manilaToday } from '@materyalph/web-ui'
import { revealTin } from '../lib/finance-api'
import { getVendorPrivateFileUrl, readableOnboardingError, saveVendorSetupDraft, type VendorOnboardingSnapshot } from '../lib/onboarding-api'
import { VendorAddressMapSelector } from './VendorAddressMapSelector'

function data(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return {}
  return Object.fromEntries(Object.entries(value).map(([key, item]) => [key.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase()), item]))
}
const text = (value: unknown, fallback = 'Not recorded'): string => typeof value === 'string' && value ? value : fallback
const label = (value: unknown) => text(value).replaceAll('_', ' ').toLowerCase().replace(/^./, c => c.toUpperCase())
const list = (value: unknown): Record<string, unknown>[] => Array.isArray(value) ? value.map(data) : []
const manilaDate = (value: string) => new Date(`${value}T00:00:00+08:00`).toLocaleDateString('en-PH', { month: 'long', day: 'numeric', year: 'numeric', timeZone: 'Asia/Manila' })
const joined = (value: unknown) => Array.isArray(value) ? value.map(String).join(', ') : 'Not recorded'

export function StoreBusinessInformation({ snapshot, renderEditor }: { snapshot: VendorOnboardingSnapshot; renderEditor: () => ReactNode }) {
  const [editing, setEditing] = useState(false)
  const org = data(snapshot.organization)
  const verification = data(snapshot.verification)
  useEffect(() => { if (verification.status === 'PENDING_VERIFICATION') setEditing(false) }, [verification.status])
  const address = data(verification.address)
  const authority = data(verification.authorityReview)
  const identity = data(verification.legalIdentity)
  const representative = data(verification.representative)
  const tax = data(verification.taxProfile)
  const tin = tax.tinLast4 ? <RevealableValue masked={`•••• ${text(tax.tinLast4)}`} label="TIN" reveal={revealTin} readError={readableOnboardingError} /> : 'Not recorded'
  const classification = data(verification.classification)
  const documents = list(verification.documents).filter(doc => !doc.supersededAt)
  const keys = ['identity_evidence', 'identity_back_evidence', 'representative_identity', 'representative_identity_back', 'authority_to_act', 'bir_cor', 'tax_relief_evidence', 'business_registration', 'lgu_permit', 'optional_certification']
  const requirements = snapshot.sections.STORE_VERIFICATION?.steps.filter(step => keys.includes(step.key) && step.status !== 'NOT_APPLICABLE') ?? []
  if (editing && verification.status !== 'PENDING_VERIFICATION') return <div className="space-y-5"><h2 className="text-xl font-semibold">Update business information and documents</h2><p className="text-sm text-text-secondary">Submit changes for Admin review. Previous evidence is retained. Critical changes may restrict store capabilities until approved.</p>{renderEditor()}</div>
  return <div className="space-y-6"><div className="flex flex-wrap items-start justify-between gap-4 border-b border-border-default pb-5"><div className="min-w-0"><h2 className="text-xl font-semibold">Business information</h2><p className="mt-1 text-sm text-text-secondary">Private registration details and evidence for your store.</p></div><div className="flex flex-wrap items-center gap-3"><StatusBadge label={label(verification.status)} /><Button disabled={verification.status === 'PENDING_VERIFICATION'} onClick={() => setEditing(true)}>Update information or documents</Button></div></div>
    <ProfileSplitPanel details={<>
      <ProfileDetails appearance="card" title="Business registration" items={[["Store name", text(org.storeName)], ["Business type", label(org.businessType)], ["Legal business name", text(org.legalBusinessName, text(org.legalName))], ["Company registered name", text(identity.companyRegisteredName, text(org.registeredName))], ["Established", text(org.dateEstablished)], ["Registered individual", [identity.firstName, identity.middleName, identity.surname, identity.suffix].filter(Boolean).join(' ')]]} />
      <ProfileDetails appearance="card" title="Store contacts and representative" items={[["Store email", text(org.storeEmail)], ["Store phone", text(org.storePhone)], ["Representative", text(representative.fullName)], ["Relationship", label(representative.relationship)], ["Authority review", label(authority.decision)], ["Approved authority scope", label(authority.scope)]]} />
      <ProfileDetails appearance="card" title="Registered location" items={[["Complete address", text(address.formattedAddress, [address.unit, address.street, address.barangay, address.cityMunicipality, address.province, address.postalCode].filter(Boolean).join(', '))], ["Address review", label(address.reviewState)], ["Government ID type", label(identity.idType)], ["ID number (last four digits)", identity.idNumberLast4 ? `•••• ${text(identity.idNumberLast4)}` : 'Not recorded']]} />
      <ProfileDetails appearance="card" title="Supplier classification" items={[["Supplier type", label(classification.supplierType)], ["Niches", joined(classification.niches)], ["Custom classifications", joined(classification.customLabels)]]} />
      <ProfileDetails appearance="card" title="Tax registration" items={[["TIN", tin], ["Declared VAT status", label(tax.vatCategory)], ["Admin-verified VAT status", label(tax.vatVerifiedCategory)], ["BIR COR reference", text(tax.birCorReference)], ["Tax profile status", label(tax.status)], ["Evidence environment", text(tax.environment)], ["Registration category", label(tax.registrationCategory)] ]} />
    </>} documents={<><div className="border-b border-border-default pb-4"><h2 className="text-lg font-semibold">Documents and Admin review</h2><p className="mt-1 text-sm text-text-secondary">Private evidence. Verified dates and remarks come from Admin review.</p></div>{requirements.length === 0 && <p className="text-sm text-text-secondary">No document requirements are available.</p>}{requirements.map(requirement => {
      const doc = documents.find(item => item.requirementKey === requirement.key)
      const review = data(doc?.review)
      return <section key={requirement.key} className="space-y-4 rounded-control border border-border-default p-4"><div className="flex flex-wrap items-start justify-between gap-2"><h3 className="min-w-0 font-semibold">{requirement.label}</h3><StatusBadge label={label(requirement.status)} /></div>{requirement.reason && <p className="text-sm text-text-secondary">{requirement.reason}</p>}{doc ? <><div className="flex flex-wrap items-center justify-between gap-3 rounded-control bg-surface-canvas px-3 py-2"><p className="min-w-0 break-all text-sm">{text(doc.originalName)} · Version {String(doc.version)}</p><PrivateEvidenceButton apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loadUrl={() => getVendorPrivateFileUrl(text(doc.fileId))}>View document</PrivateEvidenceButton></div><dl className="grid gap-x-4 gap-y-3 text-sm sm:grid-cols-2 xl:grid-cols-1 2xl:grid-cols-2">{[['Verified document number', text(review.verifiedDocumentNumber, 'Not verified')], ['Issue date', text(review.verifiedIssueDate, 'Not verified')], ['Expiration date', review.expirationKind === 'NO_EXPIRATION' ? 'Not applicable' : text(review.verifiedExpirationDate, 'Not verified')], ['Evidence source', text(review.evidenceSource, 'Not verified')], ['Admin remarks', text(review.remarks, text(review.reason, 'No remarks'))]].map(([name, value]) => <div className="min-w-0" key={name}><dt className="text-xs font-medium text-text-secondary">{name}</dt><dd className="mt-1 break-words font-semibold">{value}</dd></div>)}</dl></> : <p className="text-sm text-text-secondary">No document on file.</p>}</section>
    })}</>} />
  </div>
}

export function StoreLocation({ snapshot }: { snapshot: VendorOnboardingSnapshot }) {
  const address = data(data(snapshot.verification).address)
  const latitude = typeof address.latitude === 'number' ? address.latitude : undefined
  const longitude = typeof address.longitude === 'number' ? address.longitude : undefined
  return <div className="space-y-6"><h2 className="text-xl font-semibold">Store location</h2><p className="text-text-secondary">{text(address.formattedAddress, [address.unit, address.street, address.barangay, address.cityMunicipality, address.province, address.postalCode, 'Philippines'].filter(Boolean).join(', '))}</p><div className="grid items-start gap-8 xl:grid-cols-[minmax(0,1.6fr)_minmax(0,1fr)]"><div>{latitude !== undefined && longitude !== undefined && Math.abs(latitude) <= 90 && Math.abs(longitude) <= 180 ? <VendorAddressMapSelector latitude={latitude} longitude={longitude} /> : <StatusMessage tone="info">No registered map pin is available. Update your registered address in Business Information.</StatusMessage>}</div><ProfileDetails title="Registered address" items={[["Unit / building", text(address.unit)], ["Street", text(address.street)], ["Barangay", text(address.barangay)], ["City / municipality", text(address.cityMunicipality)], ["Province", text(address.province)], ["Postal code", text(address.postalCode)], ["Country", 'Philippines'], ["Address review", label(address.reviewState)]]} /></div><p className="text-sm text-text-secondary">To change the registered location, use Update information or documents in Business Information. Address changes require review.</p></div>
}

export function StoreVacationMode({ snapshot, onSaved }: { snapshot: VendorOnboardingSnapshot; onSaved: (value: VendorOnboardingSnapshot) => void }) {
  const setup = data(snapshot.setup)
  const enabled = setup.vacationMode === true
  const status = enabled ? 'ACTIVE' : setup.vacationStatus === 'SCHEDULED' ? 'SCHEDULED' : 'OFF'
  const startsOn = typeof setup.vacationStartsOn === 'string' ? setup.vacationStartsOn : ''
  const endsOn = typeof setup.vacationEndsOn === 'string' ? setup.vacationEndsOn : ''
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [dialogOpen, setDialogOpen] = useState(false)
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [dialogError, setDialogError] = useState('')
  const today = manilaToday()
  const organizationLockVersion = Number(data(snapshot.organization).lockVersion)
  function openDialog() {
    setFrom(startsOn); setTo(endsOn); setErrors({}); setDialogError(''); setDialogOpen(true)
  }
  async function turnOff() {
    setBusy(true); setMessage(null)
    try {
      onSaved(await saveVendorSetupDraft({ organizationLockVersion, vacationMode: false }))
      setMessage({ tone: 'success', text: status === 'SCHEDULED' ? 'Scheduled Vacation Mode cancelled.' : 'Vacation Mode turned off.' })
    } catch (error) { setMessage({ tone: 'error', text: await readableOnboardingError(error) }) } finally { setBusy(false) }
  }
  async function saveWindow() {
    const next: Record<string, string> = {}
    // An active window keeps its saved start, which is already in the past.
    if (!from) next.from = 'Choose the first day of Vacation Mode.'
    else if (from < today && from !== startsOn) next.from = 'The start date cannot be in the past.'
    if (!to) next.to = 'Choose the last day of Vacation Mode.'
    else if (from && to < from) next.to = 'The end date must be on or after the start date.'
    else if (to < today) next.to = 'The end date cannot be in the past.'
    setErrors(next); setDialogError('')
    if (Object.keys(next).length) return
    setBusy(true)
    try {
      const saved = await saveVendorSetupDraft({ organizationLockVersion, vacationMode: true, vacationStartsOn: from, vacationEndsOn: to })
      onSaved(saved)
      setDialogOpen(false)
      setMessage({ tone: 'success', text: from > today ? `Vacation Mode scheduled from ${manilaDate(from)} to ${manilaDate(to)}.` : `Vacation Mode is on until ${manilaDate(to)}.` })
    } catch (error) { setDialogError(await readableOnboardingError(error)) } finally { setBusy(false) }
  }
  const statusLabel = status === 'ACTIVE' ? (endsOn ? `On until ${manilaDate(endsOn)}` : 'On — no end date') : status === 'SCHEDULED' ? 'Scheduled' : 'Off'
  const paused = ['New Item-Based orders', 'New Project-Based inquiries', 'Quotation acceptance']
  const available = ['Fulfilling your existing orders', 'Existing work and messaging', 'Your regular operating hours']
  return <div className="space-y-6">
    {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    <section aria-label="Vacation Mode status" className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6">
      <div className="flex flex-wrap items-start justify-between gap-5">
        <div className="min-w-0 max-w-2xl space-y-3">
          <div className="flex flex-wrap items-center gap-3"><h2 className="text-xl font-semibold">Vacation Mode</h2><StatusBadge tone={status === 'ACTIVE' ? 'warning' : status === 'SCHEDULED' ? 'info' : 'neutral'} label={statusLabel} /></div>
          <p className="text-sm leading-6 text-text-secondary">Pause new procurement while you are away. Choose the first and last day, and your store reopens on its own after the end date. Existing orders must still be fulfilled.</p>
        </div>
        <div className="flex flex-wrap gap-3">
          {status === 'OFF' ? <Button disabled={busy} onClick={openDialog}>Turn on Vacation Mode</Button> : <>
            <Button variant="secondary" disabled={busy} onClick={openDialog}>{endsOn ? 'Edit dates' : 'Set dates'}</Button>
            <Button variant="outline" disabled={busy} onClick={() => void turnOff()}>{busy ? 'Saving…' : status === 'SCHEDULED' ? 'Cancel Vacation Mode' : 'Turn off Vacation Mode'}</Button>
          </>}
        </div>
      </div>
      {status !== 'OFF' && <dl className="mt-5 grid gap-x-8 gap-y-4 border-t border-border-default pt-5 text-sm sm:grid-cols-2">
        <div><dt className="text-xs font-medium text-text-secondary">First day</dt><dd className="mt-1 font-semibold">{startsOn ? manilaDate(startsOn) : 'Not recorded'}</dd></div>
        <div><dt className="text-xs font-medium text-text-secondary">Last day</dt><dd className="mt-1 font-semibold">{endsOn ? manilaDate(endsOn) : 'No end date — turn it off when you are ready'}</dd></div>
      </dl>}
    </section>
    <div className="grid gap-4 md:grid-cols-2">
      <section aria-label="Paused while on" className="rounded-surface border border-border-default bg-surface-primary p-5"><h3 className="flex items-center gap-2 font-semibold"><Pause size={16} aria-hidden="true" className="text-status-warning" />Paused while Vacation Mode is on</h3><ul className="mt-3 space-y-2 text-sm text-text-secondary">{paused.map(item => <li key={item}>{item}</li>)}</ul></section>
      <section aria-label="Stays available" className="rounded-surface border border-border-default bg-surface-primary p-5"><h3 className="flex items-center gap-2 font-semibold"><Check size={16} aria-hidden="true" className="text-status-success" />Stays available</h3><ul className="mt-3 space-y-2 text-sm text-text-secondary">{available.map(item => <li key={item}>{item}</li>)}</ul></section>
    </div>
    <FormDialog open={dialogOpen} size="small" title={status === 'OFF' ? 'Set up Vacation Mode' : 'Edit Vacation Mode dates'} description="Dates use Philippine time. Vacation Mode begins at the start of the first day and ends after the last day." busy={busy} onClose={() => setDialogOpen(false)}
      footer={<div className="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end"><Button variant="secondary" disabled={busy} onClick={() => setDialogOpen(false)}>Cancel</Button><Button disabled={busy} onClick={() => void saveWindow()}>{busy ? 'Saving…' : status === 'OFF' ? 'Turn on Vacation Mode' : 'Save dates'}</Button></div>}>
      <div className="grid gap-5">
        {dialogError && <StatusMessage tone="error">{dialogError}</StatusMessage>}
        <Field label="First day" name="vacation_starts_on" type="date" required min={startsOn && startsOn < today ? startsOn : today} value={from} error={errors.from} onChange={event => { setFrom(event.target.value); setErrors({}) }} />
        <Field label="Last day" name="vacation_ends_on" type="date" required min={from > today ? from : today} value={to} error={errors.to} hint="New procurement reopens after this day." onChange={event => { setTo(event.target.value); setErrors({}) }} />
        {from && to && to >= from && <p className="rounded-control bg-surface-canvas px-3 py-2 text-sm text-text-secondary" role="status">New procurement is paused from {manilaDate(from)} to {manilaDate(to)}.</p>}
      </div>
    </FormDialog>
  </div>
}
