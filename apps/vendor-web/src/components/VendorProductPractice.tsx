import { useEffect, useRef, useState } from 'react'
import { Button, Field, StatusMessage, TutorialPractice, type PracticeStep } from '@materyalph/web-ui'
import { pesoToCentavos, type CatalogListing, type CatalogMaterial } from '../lib/catalog-api'
import { formFromListing, rowsFromListing, variantClientErrors } from '../lib/catalog-form'
import { sampleMaterial, sampleMaterialMatch, sampleProduct, sampleTaxonomy } from '../lib/vendor-tutorial-samples'
import { MaterialStep, ProductInformationStep, ProductPhotosStep, ReviewStep } from '../pages/CatalogListingSteps'

const steps: PracticeStep[] = [
  { title: 'Start a product draft', description: 'Add product starts with a material name, the display name Buyers see and your own unique Vendor SKU. This sample uses plywood. Create the sample draft to continue.', target: '[data-demo-identity]', nextLabel: 'Create sample draft' },
  { title: 'Choose the material and search tags', description: 'Select the matching material to apply its category and certification rules. Search tags help Buyers find your listing. Choose at least one tag. Other labels describe only your own listing.', target: '[aria-labelledby="material-search-heading"]' },
  { title: 'Describe the product', description: 'Enter a clear description, brand and manufacturer details. Technical fields depend on the selected material. This plywood example is unregulated; a regulated material must complete the real PS/ICC process before publication.', target: '[aria-labelledby="core-details-heading"]' },
  { title: 'Set variants, prices and stock', description: 'A variant has its own SKU, sale unit, pack quantity, price, counted stock, weight and dimensions. The sample sells one sheet for ₱650. Tax options on a real listing follow your reviewed VAT classification. Optional volume tiers need higher quantities and lower prices.', target: '[aria-labelledby="pricing-heading"]' },
  { title: 'Add a public product image', description: 'Use the sample illustration or select a local JPG, PNG or WebP. Here it stays in this practice session. In your real listing, upload clear product photos; private permits and PS/ICC evidence belong in their separate sections.', target: '[aria-labelledby="photos-heading"]' },
  { title: 'Review and try publishing', description: 'Review the listing preview, price, stock and readiness checks. Select Publish listing below to simulate the last action. A real draft saves while you work; publishing is a separate action checked by the server. This example never appears to Buyers.', target: '[aria-labelledby="preview-heading"]' },
]
const materialLookup = { matches: [sampleMaterialMatch], resolve: async () => sampleMaterial }

export default function VendorProductPractice({ onClose }: { onClose: (completed: boolean) => void }) {
  const [step, setStep] = useState(0)
  const [form, setForm] = useState(() => formFromListing(sampleProduct()))
  const [rows, setRows] = useState(() => rowsFromListing(sampleProduct()))
  const [material, setMaterial] = useState<CatalogMaterial | null>(sampleMaterial)
  const [media, setMedia] = useState<CatalogListing['media']>([])
  const [previews, setPreviews] = useState<Record<string, string>>({})
  const [published, setPublished] = useState(false)
  const [errors, setErrors] = useState<Record<string, string>>({})
  const urls = useRef<string[]>([])
  const photoSequence = useRef(0)
  useEffect(() => () => urls.current.forEach(url => URL.revokeObjectURL(url)), [])
  const product = sampleProduct()
  const listing: CatalogListing = { ...product, ...form, material, materialMatch: form.materialId ? form.materialMatch : 'UNMATCHED', materialCategoryId: form.categoryId,
    variants: rows.map((row, index) => ({ ...product.variants[0]!, id: row.id ?? `demo-variant-${index}`, sku: row.sku, label: row.label, unitId: row.unitId, unitCode: 'SHEET', packQuantity: row.packQuantity, attributes: row.attributes, weightKg: row.weightKg, lengthCm: row.lengthCm, widthCm: row.widthCm, heightCm: row.heightCm, price: { ...product.variants[0]!.price!, amountCentavos: pesoToCentavos(row.price) ?? 0, taxCategory: 'NON_VAT' }, inventory: { ...product.variants[0]!.inventory!, quantityOnHand: row.quantityOnHand, availableToSell: row.quantityOnHand } })), media,
    blockers: media.length ? [] : [{ key: 'media', step: 'media', reason: 'Add a sample product image.' }],
  }
  function addPhoto(file?: File, replaces?: string | null) {
    const id = `demo-photo-${++photoSequence.current}`
    const url = file ? URL.createObjectURL(file) : '/tutorial/plywood.svg'
    if (file) urls.current.push(url)
    setMedia(current => {
      const old = current.find(item => item.id === replaces)
      const photo: CatalogListing['media'][number] = { id, fileId: id, altText: 'Tutorial sample image', status: 'READY', version: (old?.version ?? 0) + 1, contentType: file?.type ?? 'image/png', byteSize: file?.size ?? 0, scanState: 'DEMO_ONLY' }
      return old ? current.map(item => item.id === old.id ? photo : item) : [...current, photo]
    })
    setPreviews(current => ({ ...current, [id]: url }))
    setPublished(false)
  }
  function next() {
    if (step === 0) return form.displayName.trim().length >= 2 && Boolean(form.vendorSku.trim())
    if (step === 1) return Boolean(form.materialId || form.otherLabel.trim() && form.categoryId) && Boolean(form.tagIds.length || form.customTags.length)
    if (step === 2) return Boolean(form.displayName.trim() && form.description.trim() && form.vendorSku.trim())
    if (step === 3) { const invalid = variantClientErrors(rows); setErrors(invalid); return Object.keys(invalid).length === 0 }
    if (step === 4) return media.length > 0
    return published
  }
  return <TutorialPractice title="Practice adding a product" steps={steps} step={step} onStep={index => { setStep(index); setErrors({}) }} onNext={next} onClose={onClose} sampleAction={step === 4 ? <Button variant="secondary" disabled={media.length >= 8} onClick={() => addPhoto()}>Use sample product image</Button> : undefined}>
    <div className="grid min-w-0 gap-5" data-product-practice>
      <p className="text-xs font-semibold text-action-primary">DEMO · {form.displayName}</p>
      {step === 0 && <section data-demo-identity className="mp-card mp-card-padded grid gap-4"><h3 className="text-lg font-semibold">New product listing</h3><Field id="demo-material" label="Material name" value="Plywood" readOnly hint="The next step demonstrates matching this sample material." /><Field id="demo-display" label="Display name" value={form.displayName} onChange={event => setForm({ ...form, displayName: event.target.value })} /><Field id="demo-sku" label="Vendor SKU" value={form.vendorSku} onChange={event => setForm({ ...form, vendorSku: event.target.value })} /></section>}
      {step === 1 && <MaterialStep form={form} setForm={setForm} taxonomy={sampleTaxonomy} material={material} setMaterial={setMaterial} errors={errors} readOnly={false} materialLookup={materialLookup} />}
      {(step === 2 || step === 3) && <ProductInformationStep listing={listing} form={form} setForm={value => { setForm(value); setPublished(false) }} rows={rows} setRows={value => { setRows(value); setPublished(false) }} taxonomy={sampleTaxonomy} material={material} errors={errors} busy={false} setBusy={() => {}} readOnly={false} onEditMaterial={() => setStep(1)} onComplianceSubmitted={() => {}} beforeComplianceSubmit={async () => { throw new Error('Compliance submissions are unavailable in this sample.') }} />}
      {step === 4 && <ProductPhotosStep listing={listing} taxonomy={sampleTaxonomy} busy={false} readOnly={false} previews={previews} onUpload={(file, replaces) => addPhoto(file, replaces)} onRemove={id => { setMedia(current => current.filter(item => item.id !== id)); setPublished(false) }} mediaError={null} />}
      {step === 5 && <>{published && <StatusMessage tone="success">Sample publication completed. Your store has not changed.</StatusMessage>}<ReviewStep listing={listing} taxonomy={sampleTaxonomy} previews={previews} busy={false} readOnly={published} onGoTo={index => setStep(index === 1 ? 2 : index === 2 ? 4 : 1)} onPublish={() => setPublished(true)} onDeactivate={() => {}} /></>}
    </div>
  </TutorialPractice>
}
