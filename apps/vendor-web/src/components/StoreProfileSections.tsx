import { useEffect, useState, type ReactNode } from 'react'
import { Button, ProfileDetails, ProfileSplitPanel, PrivateEvidenceButton, StatusBadge, StatusMessage } from '@materyalph/web-ui'
import { getVendorPrivateFileUrl, readableOnboardingError, saveVendorSetupDraft, type VendorOnboardingSnapshot } from '../lib/onboarding-api'
import { VendorAddressMapSelector } from './VendorAddressMapSelector'

function data(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return {}
  return Object.fromEntries(Object.entries(value).map(([key, item]) => [key.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase()), item]))
}
const text = (value: unknown, fallback = 'Not recorded'): string => typeof value === 'string' && value ? value : fallback
const label = (value: unknown) => text(value).replaceAll('_', ' ').toLowerCase().replace(/^./, c => c.toUpperCase())
const list = (value: unknown): Record<string, unknown>[] => Array.isArray(value) ? value.map(data) : []
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
  const classification = data(verification.classification)
  const documents = list(verification.documents).filter(doc => !doc.supersededAt)
  const keys = ['identity_evidence', 'identity_back_evidence', 'representative_identity', 'representative_identity_back', 'authority_to_act', 'bir_cor', 'tax_relief_evidence', 'business_registration', 'lgu_permit', 'optional_certification']
  const requirements = snapshot.sections.STORE_VERIFICATION?.steps.filter(step => keys.includes(step.key) && step.status !== 'NOT_APPLICABLE') ?? []
  if (editing && verification.status !== 'PENDING_VERIFICATION') return <div className="space-y-5"><h2 className="text-xl font-semibold">Update business information and documents</h2><p className="text-sm text-text-secondary">Submit changes for Admin review. Previous evidence is retained. Critical changes may restrict store capabilities until approved.</p>{renderEditor()}</div>
  return <div className="space-y-8"><div className="flex flex-wrap items-start justify-between gap-4"><div><h2 className="text-xl font-semibold">Business information</h2><p className="mt-2 text-sm text-text-secondary">Private registration details and evidence for your store.</p></div><div className="flex flex-wrap items-center gap-3"><StatusBadge label={label(verification.status)} /><Button disabled={verification.status === 'PENDING_VERIFICATION'} onClick={() => setEditing(true)}>Update information or documents</Button></div></div>
    <ProfileSplitPanel details={<>
      <ProfileDetails title="Business registration" items={[["Store name", text(org.storeName)], ["Business type", label(org.businessType)], ["Legal business name", text(org.legalBusinessName, text(org.legalName))], ["Company registered name", text(identity.companyRegisteredName, text(org.registeredName))], ["Established", text(org.dateEstablished)], ["Registered individual", [identity.firstName, identity.middleName, identity.surname, identity.suffix].filter(Boolean).join(' ')]]} />
      <ProfileDetails title="Store contacts and representative" items={[["Store email", text(org.storeEmail)], ["Store phone", text(org.storePhone)], ["Representative", text(representative.fullName)], ["Relationship", label(representative.relationship)], ["Authority review", label(authority.decision)], ["Approved authority scope", label(authority.scope)]]} />
      <ProfileDetails title="Registered location" items={[["Complete address", text(address.formattedAddress, [address.unit, address.street, address.barangay, address.cityMunicipality, address.province, address.postalCode].filter(Boolean).join(', '))], ["Address review", label(address.reviewState)], ["Government ID type", label(identity.idType)], ["ID number (last four digits)", identity.idNumberLast4 ? `•••• ${text(identity.idNumberLast4)}` : 'Not recorded']]} />
      <ProfileDetails title="Supplier classification" items={[["Supplier type", label(classification.supplierType)], ["Niches", joined(classification.niches)], ["Custom classifications", joined(classification.customLabels)]]} />
      <ProfileDetails title="Tax registration" items={[["TIN (last four digits)", tax.tinLast4 ? `•••• ${text(tax.tinLast4)}` : 'Not recorded'], ["Declared VAT status", label(tax.vatCategory)], ["Admin-verified VAT status", label(tax.vatVerifiedCategory)], ["BIR COR reference", text(tax.birCorReference)], ["Tax profile status", label(tax.status)], ["Evidence environment", text(tax.environment)], ["Registration category", label(tax.registrationCategory)], ["Owner attestation", tax.ownerAttested === true ? 'Attested' : 'Not attested'] ]} />
    </>} documents={<><h2 className="text-lg font-semibold">Documents and Admin review</h2><p className="text-sm text-text-secondary">Private evidence. Verified dates and remarks come from Admin review.</p>{requirements.length === 0 && <p className="text-sm text-text-secondary">No document requirements are available.</p>}{requirements.map(requirement => {
      const doc = documents.find(item => item.requirementKey === requirement.key)
      const review = data(doc?.review)
      return <section key={requirement.key} className="space-y-3 border-t border-border-default pt-5"><h3 className="font-semibold">{requirement.label}</h3><StatusBadge label={label(requirement.status)} />{requirement.reason && <p className="text-sm text-text-secondary">{requirement.reason}</p>}{doc && <><p className="break-all text-sm">{text(doc.originalName)} · Version {String(doc.version)}</p><PrivateEvidenceButton apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loadUrl={() => getVendorPrivateFileUrl(text(doc.fileId))}>View document</PrivateEvidenceButton><dl className="grid gap-3 text-sm">{[['Verified document number', text(review.verifiedDocumentNumber, 'Not verified')], ['Issue date', text(review.verifiedIssueDate, 'Not verified')], ['Expiration date', review.expirationKind === 'NO_EXPIRATION' ? 'Not applicable' : text(review.verifiedExpirationDate, 'Not verified')], ['Evidence source', text(review.evidenceSource, 'Not verified')], ['Admin remarks', text(review.remarks, text(review.reason, 'No remarks'))]].map(([name, value]) => <div key={name}><dt className="text-text-secondary">{name}</dt><dd className="mt-1 break-words">{value}</dd></div>)}</dl></>}</section>
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
  const enabled = data(snapshot.setup).vacationMode === true
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  async function toggle() {
    setBusy(true); setMessage(null)
    try {
      onSaved(await saveVendorSetupDraft({ organizationLockVersion: Number(data(snapshot.organization).lockVersion), vacationMode: !enabled }))
      setMessage({ tone: 'success', text: enabled ? 'Vacation Mode turned off.' : 'Vacation Mode turned on.' })
    } catch (error) { setMessage({ tone: 'error', text: await readableOnboardingError(error) }) } finally { setBusy(false) }
  }
  return <div className="space-y-6"><div className="flex flex-wrap items-center justify-between gap-4"><div className="space-y-2"><h2 className="text-xl font-semibold">Vacation Mode</h2><StatusBadge label={enabled ? 'On — new procurement paused' : 'Off'} /></div><Button disabled={busy} onClick={() => void toggle()}>{busy ? 'Saving…' : enabled ? 'Turn off Vacation Mode' : 'Turn on Vacation Mode'}</Button></div><p className="max-w-3xl text-sm leading-6 text-text-secondary">Pause new Item-Based orders, Project-Based inquiries and quotation acceptance while you are away. Existing orders must still be fulfilled. Existing work and messaging remain available.</p><p className="text-sm text-text-secondary">Your regular operating hours stay unchanged. Turn Vacation Mode off when you are ready to receive new procurement.</p>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}</div>
}
