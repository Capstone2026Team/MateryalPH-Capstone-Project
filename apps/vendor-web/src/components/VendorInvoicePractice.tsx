import { useState } from 'react'
import { Button, Field, FileSelectionField, FilterTabs, InvoiceDetailSummary, InvoiceListItem, InvoicePresetFields, InvoiceWorkspace, StatCard, StatusBadge, StatusMessage, TutorialPractice, manilaToday, type InvoicePresetValues, type PracticeStep } from '@materyalph/web-ui'
import { InvoiceDraftInvoiceTypeEnum, InvoiceDraftSourceSystemEnum, InvoiceDraftInvoicingMethodEnum, type InvoiceDraft, type InvoiceRecordView, type VendorOrderInvoices } from '@materyalph/api-client-ts'
import { sampleInvoice } from '../lib/vendor-tutorial-samples'
import { pesoInputToCentavos } from '../lib/orders-api'

const steps: PracticeStep[] = [
  { title: 'Find the invoice task', description: 'This fictional order lets you explore an invoice even when your store has none. Requests contains Buyer copy requests; No copy yet contains confirmed sales missing a sent copy; Uploaded contains sent copies; Mismatches contains returns and reconciliation issues.', target: '[aria-label="Sample invoice list"]' },
  { title: 'Prepare the invoice details', description: 'First issue your invoice through your registered process when legally due. Then enter its document type, issuer, source, method, number, date and amounts here. MateryalPH stores a copy; it does not assign official Vendor invoice numbers.', target: '[data-demo-invoice-fields]' },
  { title: 'Select a copy and save the draft', description: 'Choose Use sample invoice copy, or select a PDF, JPG or PNG from your device. In the real flow Upload copy saves a private editable draft after the safety check. It does not send anything to the Buyer. This practice keeps only a sample filename in memory.', target: '[data-demo-invoice-file]', nextLabel: 'Save sample draft' },
  { title: 'Review before sending', description: 'Compare the prepared invoice and accepted order breakdown. Accepted order amounts are saved order facts, not extracted invoice lines. VAT is included and Buyer processing fees are excluded. A mismatch requires explanation or correction; it never adds a Buyer charge.', target: '.mp-invoice-sheet' },
  { title: 'Try Send with the sample', description: 'Select Send sample copy below. A real Send freezes an invoice version, fulfills the applicable copy request and notifies the Buyer. Saving or merely opening the page does not complete that task. No notification is sent in this demo.', target: '[data-demo-invoice-send]' },
  { title: 'Understand corrections', description: 'Try the sample Buyer return below. A Buyer return or correction request permits a new corrected copy: prepare, upload, review and Send again. The previous sent version stays unchanged. Uploaded copies and Mismatches keep their separate purposes.', target: '[data-demo-invoice-correction]' },
]
const preset = { invoiceType: 'VENDOR_GOODS_INVOICE', issuerName: 'Demo Building Supply', sourceSystem: 'REGISTERED_CAS', invoicingMethod: 'COMPUTERIZED' } as const
export default function VendorInvoicePractice({ onClose, canPrepare = true }: { onClose: (completed: boolean) => void; canPrepare?: boolean }) {
  return canPrepare ? <InvoicePreparationPractice onClose={onClose} /> : <InvoiceReadingPractice onClose={onClose} />
}
function InvoiceReadingPractice({ onClose }: { onClose: (completed: boolean) => void }) {
  const [step, setStep] = useState(0)
  return <TutorialPractice title="Practice E-Invoices" steps={[{ ...steps[0]!, target: '.mp-invoice-sheet' }, { title: 'Review an invoice task', description: 'This sample shows the issuer, Buyer and accepted materials and totals. Your current role can view permitted invoice records. Preparing or sending real copies requires the store’s existing invoice permission.', target: '.mp-invoice-sheet' }]} step={step} onStep={setStep} onClose={onClose}>
    <section className="mp-invoice-sheet"><InvoiceDetailSummary data={sampleInvoice()} apiBasePath="" /></section>
  </TutorialPractice>
}
function InvoicePreparationPractice({ onClose }: { onClose: (completed: boolean) => void }) {
  const [step, setStep] = useState(0)
  const [view, setView] = useState('REQUESTS')
  const [business, setBusiness] = useState<InvoicePresetValues>(preset)
  const [number, setNumber] = useState('DEMO-INV-001')
  const [date, setDate] = useState(manilaToday)
  const [amount, setAmount] = useState('6800.00')
  const [file, setFile] = useState('')
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [draft, setDraft] = useState<InvoiceDraft | null>(null)
  const [records, setRecords] = useState<InvoiceRecordView[]>([])
  const [returned, setReturned] = useState(false)
  const data: VendorOrderInvoices = { ...sampleInvoice(), records, draft }
  const currentRecord = records.at(-1)
  const showRow = view === 'REQUESTS' ? !records.length || returned : view === 'DUE' ? !records.length : view === 'RECORDS' ? records.length > 0 : returned || currentRecord?.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED'
  function saveDraft() {
    if (records.length && !returned) return true
    const cents = pesoInputToCentavos(amount)
    const invoiceType = Object.values(InvoiceDraftInvoiceTypeEnum).find(value => value === business.invoiceType)
    const sourceSystem = Object.values(InvoiceDraftSourceSystemEnum).find(value => value === business.sourceSystem)
    const invoicingMethod = Object.values(InvoiceDraftInvoicingMethodEnum).find(value => value === business.invoicingMethod)
    if (!invoiceType || !sourceSystem || !invoicingMethod) return false
    if (!file || cents === null || !number.trim() || business.issuerName.trim() !== preset.issuerName || !/^\d{4}-\d{2}-\d{2}$/.test(date)) return false
    setDraft({ id: 'demo-draft', lockVersion: 1, invoiceType, sourceSystem, invoicingMethod, issuerName: business.issuerName, invoiceNumber: number, issuedOn: new Date(`${date}T00:00:00+08:00`), amountCentavos: cents, vatCentavos: 0, updatedAt: new Date(), fileName: file, ...(returned && currentRecord ? { amendsInvoiceRecordId: currentRecord.id } : {}), download: { url: '#demo-copy', expiresAt: new Date() } })
    return true
  }
  function send() {
    if (!draft) return
    setRecords(current => [...current, { id: `demo-sent-copy-${current.length + 1}`, invoiceType: draft.invoiceType, sourceSystem: draft.sourceSystem, invoicingMethod: draft.invoicingMethod, issuer: draft.issuerName, invoiceNumber: draft.invoiceNumber, issuedOn: date, amountCentavos: draft.amountCentavos, documentOrigin: 'DEMO_SAMPLE', originLabel: 'Tutorial demo', verificationState: 'UNVERIFIED', eInvoicingCoverage: 'REVIEW_REQUIRED', complianceNote: 'Tutorial example only; not an official tax invoice or proof of BIR compliance.', reconciliationState: draft.amountCentavos === 680000 ? 'MATCHED' : 'INVOICE_RECONCILIATION_REQUIRED', reconciliationDifferenceCentavos: draft.amountCentavos - 680000, canExplain: false, buyerTotalUnchanged: true, sentAt: new Date(), fileName: file, ...(draft.amendsInvoiceRecordId ? { amendsInvoiceRecordId: draft.amendsInvoiceRecordId } : {}) }])
    setDraft(null); setReturned(false); setView('RECORDS')
  }
  return <TutorialPractice title="Practice E-Invoices" steps={steps} step={step} onStep={setStep} onClose={onClose} onNext={() => step === 2 ? saveDraft() : step === 4 ? records.length > 0 : step === 1 ? Boolean(number.trim() && business.issuerName.trim() === preset.issuerName && pesoInputToCentavos(amount) !== null) : true} sampleAction={step === 2 ? <Button variant="secondary" onClick={() => setFile('DEMO-invoice-copy.pdf')}>Use sample invoice copy</Button> : undefined}>
    <InvoiceWorkspace summary={<><StatCard label="Buyer requests" value={records.length ? 0 : 1} /><StatCard label="No copy yet" value={records.length ? 0 : 1} /><StatCard label="Uploaded copies" value={records.length} /></>} list={<section aria-label="Sample invoice list" className="mp-card mp-card-padded grid min-w-0 gap-4"><h3 className="font-semibold">Sample invoice list</h3><FilterTabs label="Sample invoice view" appearance="tabs" value={view} onChange={setView} chips={[{ value: 'REQUESTS', label: 'Requests' }, { value: 'DUE', label: 'No copy yet' }, { value: 'RECORDS', label: 'Uploaded' }, { value: 'RECONCILIATION', label: 'Mismatches' }]} />{showRow ? <ul><InvoiceListItem title={currentRecord?.invoiceNumber ?? 'DEMO-ORDER-001'} reference="Example Buyer" metadata={[{ label: 'Sample task', value: returned ? 'Buyer correction request' : records.length ? 'Sent copy' : 'Copy requested' }]} status={<StatusBadge label={returned ? 'Returned for correction' : records.length ? 'Sent in demo' : 'No copy yet'} tone="neutral" />} selected onSelect={() => {}} /></ul> : <p className="py-5 text-sm text-text-secondary">No sample records in this view.</p>}<p className="text-xs text-text-secondary">One fictional order follows the steps of this example.</p></section>} detail={<section aria-label="Sample invoice details" className="mp-invoice-sheet grid min-w-0 gap-5">
      {(step === 1 || step === 2) ? <><div data-demo-invoice-fields className="grid min-w-0 gap-4"><h3 className="font-semibold">Upload invoice copy · Demo</h3><InvoicePresetFields value={business} onChange={setBusiness} registeredName="Demo Building Supply" invoiceTypes={data.invoiceTypes} sourceSystems={data.sourceSystems} invoicingMethods={data.invoicingMethods} issuerError={business.issuerName.trim() !== preset.issuerName ? 'Use Demo Building Supply for this sample registered issuer.' : undefined} /><Field id="demo-invoice-number" label="Invoice number" value={number} onChange={event => setNumber(event.target.value)} /><Field id="demo-invoice-date" label="Invoice date" type="date" value={date} onChange={event => setDate(event.target.value)} /><Field id="demo-invoice-amount" label="Invoice total (₱)" inputMode="decimal" value={amount} onChange={event => setAmount(event.target.value)} /></div>{step === 2 && <div data-demo-invoice-file className="grid gap-3"><FileSelectionField label="Invoice copy" accept="application/pdf,image/jpeg,image/png" hint="PDF, JPG or PNG. This practice keeps the selection local." file={selectedFile} onChange={selected => { setSelectedFile(selected); setFile(selected?.name ?? '') }} /><p className="text-xs text-text-secondary">{file ? `Selected for practice: ${file}` : 'Select a local file or use the sample copy.'}</p></div>}</>
        : <InvoiceDetailSummary data={data} {...(currentRecord ? { record: currentRecord } : {})} apiBasePath="" actions={step === 4 ? <Button data-demo-invoice-send disabled={!draft || records.length > 0} onClick={send}>Send sample copy</Button> : undefined} />}
      {records.length > 0 && <StatusMessage tone="success">Sample copy sent in this demo. No real invoice or Buyer notification was created.</StatusMessage>}
      {step === 5 && <section data-demo-invoice-correction className="grid gap-3"><Button variant="secondary" disabled={returned} onClick={() => { setReturned(true); setNumber('DEMO-INV-002'); setView('RECONCILIATION') }}>Simulate Buyer return</Button>{returned && <StatusMessage>The sample Buyer requested a correction. Prepare a new copy, review it and Send again. The previous copy remains in the sent history. Use Back to prepare and review a corrected sample copy.</StatusMessage>}</section>}
    </section>} />
  </TutorialPractice>
}
