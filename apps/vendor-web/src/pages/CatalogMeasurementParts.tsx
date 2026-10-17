import { AlertTriangle, CheckCircle2, Lightbulb, Ruler, X } from 'lucide-react'
import { useState, type ReactNode } from 'react'
import { Button, Field } from '@materyalph/web-ui'
import type { CatalogMaterial, CatalogTaxonomy } from '../lib/catalog-api'
import { addCustomTag, CUSTOM_TAG_MAX_LENGTH, type DetailsForm, type VariantRow } from '../lib/catalog-form'
import { categoryIcon } from '../lib/category-icons'
import { densityWarning, measurementSummary, measurementWarnings, suggestionApplied, type MeasureKey, type MeasurementSuggestion, type Measures } from '../lib/listing-measurements'
import { cubicMeterText, densityWarning as concreteDensityWarning, mixerRecommendation, TYPICAL_KG_PER_M3 } from '../lib/ready-mixed-concrete'
import type { FleetVehicle } from '../lib/inventory-api'

function CategoryBadge({ code }: { code: string | null | undefined }) {
  const Icon = categoryIcon(code)
  return <span className="grid h-11 w-11 shrink-0 place-items-center rounded-full bg-brand-orange-50 text-action-primary" aria-hidden="true"><Icon size={20} /></span>
}

export function AdvisoryText({ children }: { children: ReactNode }) {
  return <span className="inline-flex items-start gap-1.5 text-amber-900"><AlertTriangle size={15} className="mt-0.5 shrink-0" aria-hidden="true" /><span>{children}</span></span>
}

/**
 * The Buyer-facing category. A canonical material fixes it (the server rejects any other category);
 * an Other-label listing chooses from the same categories Buyers browse.
 */
export function CategorySection({ form, setForm, taxonomy, material, readOnly, error, onEditMaterial }: { form: DetailsForm; setForm: (form: DetailsForm) => void; taxonomy: CatalogTaxonomy; material: CatalogMaterial | null; readOnly: boolean; error?: string | undefined; onEditMaterial?: (() => void) | undefined }) {
  const current = taxonomy.categories.find(category => category.id === form.categoryId)
  return <section aria-labelledby="category-heading" className="grid gap-4">
    <div className="border-b border-border-default pb-2">
      <h3 id="category-heading" className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Category</h3>
      <p className="mt-1 text-sm text-text-secondary">Buyers browse these same categories in the MateryalPH app, and Technical details follow the category.</p>
    </div>
    {form.materialId !== null ? <>
      <div className="flex flex-wrap items-center gap-4 rounded-surface border border-border-default bg-surface-canvas p-4">
        <CategoryBadge code={current?.code} />
        <div className="min-w-0 flex-1">
          <p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Buyer category</p>
          <p className="text-base font-semibold text-text-strong">{current?.name ?? material?.categoryName ?? 'Loading category…'}</p>
          <p className="text-sm text-text-secondary">Material: <span className="font-semibold text-text-strong">{material?.name ?? '—'}</span> · set by the material you chose in Material selection.</p>
        </div>
        {onEditMaterial && !readOnly && <Button variant="secondary" onClick={onEditMaterial}>Change material</Button>}
      </div>
      {form.materialMatch === 'FUZZY_CONFIRMED' && material && <p className="flex items-start gap-2 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900"><AlertTriangle size={18} className="mt-0.5 shrink-0" aria-hidden="true" /><span>This listing uses a close match. Buyer Work Packages and Project vendor searches match on the material <strong>{material.name}</strong>, not on the display name. If you sell a different material, change it in Material selection.</span></p>}
    </> : <fieldset className="grid min-w-0 gap-3" disabled={readOnly}>
      <legend className="sr-only">Buyer category</legend>
      {error && <p className="text-sm text-status-error" role="alert">{error}</p>}
      <ul className="grid gap-2 sm:grid-cols-2 xl:grid-cols-3">
        {taxonomy.categories.map(category => {
          const selected = category.id === form.categoryId
          return <li key={category.id}><label className={`flex min-h-14 cursor-pointer items-center gap-3 rounded-control border px-3 py-2 transition-colors motion-reduce:transition-none ${selected ? 'border-action-primary bg-brand-orange-50' : 'border-border-default bg-surface-primary hover:border-brand-orange-300'}`}>
            <input type="radio" name="buyer_category" className="h-5 w-5 shrink-0 accent-action-primary" checked={selected} onChange={() => setForm({ ...form, categoryId: category.id, technicalAttributes: {} })} />
            <CategoryBadge code={category.code} />
            <span className="min-w-0 text-sm font-semibold text-text-strong">{category.name}</span>
          </label></li>
        })}
      </ul>
    </fieldset>}
  </section>
}

const MEASURE_FIELDS: { key: MeasureKey; label: string; field: string }[] = [
  { key: 'weightKg', label: 'Weight (kg)', field: 'weight_kg' }, { key: 'lengthCm', label: 'Length (cm)', field: 'length_cm' },
  { key: 'widthCm', label: 'Width (cm)', field: 'width_cm' }, { key: 'heightCm', label: 'Height (cm)', field: 'height_cm' },
]

const valueText = (key: MeasureKey, value: string) => `${Number(value).toLocaleString('en-PH', { maximumFractionDigits: key === 'weightKg' ? 3 : 2 })} ${key === 'weightKg' ? 'kg' : 'cm'}`

/** One variant's weight and dimensions with the suggestion from Technical details, consistency warnings and a measuring guide. */
export function MeasurementFields({ row, index, unit, suggestion, guideTip, readOnly, rowError, onChange }: { row: VariantRow; index: number; unit: string; suggestion: MeasurementSuggestion | null; guideTip: string | null; readOnly: boolean; rowError: (field: string) => string | undefined; onChange: (patch: Partial<VariantRow>) => void }) {
  const measures: Measures = { weightKg: row.weightKg, lengthCm: row.lengthCm, widthCm: row.widthCm, heightCm: row.heightCm }
  const unitLabel = unit || 'sale unit'
  const warnings = measurementWarnings(measures, suggestion, unitLabel)
  const density = densityWarning(measures)
  const summary = measurementSummary(measures)
  const applied = suggestion !== null && suggestionApplied(suggestion, measures)
  const headingId = `variant-${index}-measurements`
  const remaining = suggestion?.measureYourself.map(key => MEASURE_FIELDS.find(item => item.key === key)!.label.replace(/ \(.+\)$/, '').toLowerCase()) ?? []
  return <section aria-labelledby={headingId} className="grid gap-4 rounded-control border border-border-default p-4">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div className="min-w-0">
        <h4 id={headingId} className="text-sm font-semibold text-text-strong">Weight and dimensions</h4>
        <p className="text-sm text-text-secondary">One {unitLabel} as the Buyer receives it. Used to pick a delivery vehicle that fits.</p>
      </div>
      {summary && <p className="rounded-pill border border-border-default bg-surface-canvas px-3 py-1 text-sm font-semibold tabular-nums text-text-strong"><span className="sr-only">Entered size: </span>{summary}</p>}
    </div>
    {suggestion && !applied && <div className="flex flex-wrap items-center gap-3 rounded-control border border-brand-orange-300 bg-brand-orange-50 p-3 text-sm" role="status">
      <Lightbulb size={20} className="shrink-0 text-action-primary" aria-hidden="true" />
      <div className="min-w-0 flex-1 basis-64">
        <p className="font-semibold text-text-strong">Suggested from Technical details</p>
        <p className="tabular-nums text-text-strong">{MEASURE_FIELDS.filter(item => suggestion.values[item.key]).map(item => `${item.label.replace(/ \(.+\)$/, '')} ${valueText(item.key, suggestion.values[item.key]!)}`).join(' · ')}</p>
        <p className="text-text-secondary">{suggestion.basis}{remaining.length ? ` Measure the ${remaining.join(' and ')} yourself.` : ''}</p>
      </div>
      {!readOnly && <Button variant="outline" onClick={() => onChange(suggestion.values)}>Apply suggestion</Button>}
    </div>}
    {applied && <p className="flex items-center gap-2 text-sm font-semibold text-status-success"><CheckCircle2 size={16} aria-hidden="true" />Matches the Technical details.</p>}
    <div className="grid items-start gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {MEASURE_FIELDS.map(item => <Field key={item.key} label={item.label} name={`variants.${index}.${item.field}`} value={row[item.key]} inputMode="decimal" disabled={readOnly} error={rowError(item.field)}
        hint={warnings[item.key] ? <AdvisoryText>{warnings[item.key]}</AdvisoryText> : undefined} onChange={event => onChange({ [item.key]: event.target.value })} />)}
    </div>
    {density && <p className="flex items-start gap-2 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900" role="status"><AlertTriangle size={18} className="mt-0.5 shrink-0" aria-hidden="true" />{density}</p>}
    <MeasuringGuide unit={unitLabel} tip={guideTip} />
  </section>
}

/** Ready-mixed concrete has no cargo dimensions: the mixer carries the volume, limited by payload at this weight. */
/** Search tags the Vendor types for this listing only; they sit beside the approved tags and need no Admin approval. */
export function CustomTagField({ tags, readOnly, error, onChange }: { tags: string[]; readOnly: boolean; error?: string | undefined; onChange: (tags: string[]) => void }) {
  const [draft, setDraft] = useState('')
  const [problem, setProblem] = useState<string | null>(null)
  const add = () => {
    const result = addCustomTag(tags, draft)
    setProblem(result.error)
    if (!result.error) { setDraft(''); if (result.tags !== tags) onChange(result.tags) }
  }
  return <div className="grid gap-2">
    {!readOnly && <div className="grid items-start gap-2 sm:grid-cols-[minmax(0,24rem)_auto]">
      <Field label="Your own tags" name="custom_tag" value={draft} maxLength={CUSTOM_TAG_MAX_LENGTH} autoComplete="off" error={problem ?? error ?? ''} hint="Type a word buyers might search for, such as “rebar 10mm”, then press Enter or Add. Add as many as you need."
        onChange={event => { setDraft(event.target.value); setProblem(null) }}
        onKeyDown={event => { if (event.key === 'Enter' || event.key === ',') { event.preventDefault(); add() } }} onBlur={() => { if (draft.trim()) add() }} />
      <Button variant="secondary" className="sm:mt-7" disabled={!draft.trim()} onClick={add}>Add tag</Button>
    </div>}
    {readOnly && tags.length === 0 && <p className="text-sm text-text-secondary">No custom tags.</p>}
    {tags.length > 0 && <ul className="flex flex-wrap gap-2" aria-label="Your own search tags">{tags.map(tag => <li key={tag} className="inline-flex min-h-11 items-center gap-1 rounded-pill border border-action-primary bg-brand-orange-50 pl-4 pr-1 text-sm font-semibold text-action-primary">
      {tag}
      {!readOnly && <button type="button" className="inline-flex h-9 w-9 items-center justify-center rounded-pill hover:bg-brand-orange-100" aria-label={`Remove tag ${tag}`} onClick={() => onChange(tags.filter(item => item !== tag))}><X size={16} aria-hidden="true" /></button>}
    </li>)}</ul>}
  </div>
}

/** Suggests the batch volume from the Vendor's listed Concrete Mixer Trucks; `fleet` is null while it loads or cannot be read. */
export function MixerVolumeSuggestion({ fleet, row, readOnly, onUse }: { fleet: FleetVehicle[] | null; row: VariantRow; readOnly: boolean; onUse: (volume: string) => void }) {
  if (!fleet) return null
  const recommendation = mixerRecommendation(fleet, row.weightKg)
  if (!recommendation) return <AdvisoryText>No available Concrete Mixer Truck is listed under Vehicles. Buyers cannot order this concrete until you add one.</AdvisoryText>
  const { perRoundM3, largestLoadM3, trucks, parts, weightLimited } = recommendation
  const entered = Number(row.quantityOnHand)
  const current = row.quantityOnHand.trim() !== '' && Number.isFinite(entered) ? entered : null
  return <div className="grid gap-1 rounded-control bg-surface-canvas p-3 text-sm text-text-secondary">
    <p className="flex items-start gap-2"><Lightbulb size={16} className="mt-0.5 shrink-0 text-action-primary" aria-hidden="true" /><span><strong className="font-semibold text-text-primary">Suggested from your {trucks === 1 ? 'mixer truck' : `${trucks} mixer trucks`}:</strong> {cubicMeterText(perRoundM3)} m³ per round of trips — {parts.join(' + ')}.</span></p>
    {weightLimited && <p>A truck’s Maximum Weight Capacity limits its load at {row.weightKg} kg per m³, so it carries less than its full drum.</p>}
    {current !== null && current > 0 && current < largestLoadM3 &&<AdvisoryText>This is less than one full truck load, so every order would need a part-load.</AdvisoryText>}
    {!readOnly && current !== perRoundM3 && <Button variant="outline" className="w-fit" onClick={() => onUse(cubicMeterText(perRoundM3))}>Use {cubicMeterText(perRoundM3)} m³</Button>}
  </div>
}

export function ReadyMixedWeightField({ row, index, readOnly, error, onChange }: { row: VariantRow; index: number; readOnly: boolean; error: string | undefined; onChange: (patch: Partial<VariantRow>) => void }) {
  const headingId = `variant-${index}-concrete-weight`
  const warning = concreteDensityWarning(row.weightKg)
  return <section aria-labelledby={headingId} className="grid gap-3 rounded-control border border-border-default p-4">
    <div className="min-w-0">
      <h4 id={headingId} className="text-sm font-semibold text-text-strong">Weight per cubic meter</h4>
      <p className="text-sm text-text-secondary">Checked against each mixer’s Maximum Weight Capacity. Cargo length, width and height do not apply to ready-mixed concrete.</p>
    </div>
    <div className="grid items-start gap-3 sm:grid-cols-[minmax(0,16rem)_auto] sm:items-end">
      <Field label="Weight of 1 m³ (kg)" name={`variants.${index}.weight_kg`} value={row.weightKg} inputMode="decimal" disabled={readOnly} error={error}
        hint={warning ? <AdvisoryText>{warning}</AdvisoryText> : 'Normal-weight concrete is about 2,400 kg.'} onChange={event => onChange({ weightKg: event.target.value, lengthCm: '', widthCm: '', heightCm: '' })} />
      {!readOnly && !row.weightKg.trim() && <Button variant="outline" className="w-fit" onClick={() => onChange({ weightKg: TYPICAL_KG_PER_M3, lengthCm: '', widthCm: '', heightCm: '' })}>Use 2,400 kg</Button>}
    </div>
  </section>
}

function MeasuringGuide({ unit, tip }: { unit: string; tip: string | null }) {
  const steps: [string, string][] = [
    ['Measure one sale unit', `One ${unit} exactly as handed over, including its sack, wrapping, strap or crate. If you sell bundles or boxes, measure the whole bundle or box.`],
    ['Name the sides consistently', 'Length is the longest side, width the next and height the shortest. Lay bags, sheets and boards flat before measuring.'],
    ['Weigh it', 'Use a platform or hanging scale and round up to the nearest 0.1 kg. For small items, weigh ten and divide by ten.'],
    ['Long products', 'For bars, pipes and lumber, length is the cut length; width and height are the thickness of one piece.'],
  ]
  return <details className="group rounded-control bg-surface-canvas">
    <summary className="flex min-h-11 cursor-pointer items-center gap-2 px-3 py-2 text-sm font-semibold text-action-primary"><Ruler size={16} aria-hidden="true" />How to measure one {unit}</summary>
    <div className="grid gap-4 px-3 pb-4 text-sm">
      <ol className="grid gap-3 sm:grid-cols-2">
        {steps.map(([title, body], position) => <li key={title} className="flex gap-3">
          <span className="grid h-6 w-6 shrink-0 place-items-center rounded-full bg-surface-primary text-xs font-semibold text-text-strong ring-1 ring-border-default" aria-hidden="true">{position + 1}</span>
          <span><span className="block font-semibold text-text-strong">{title}</span><span className="text-text-secondary">{body}</span></span>
        </li>)}
      </ol>
      {tip && <p className="rounded-control border border-border-default bg-surface-primary p-3 text-text-strong"><span className="font-semibold">For this material: </span>{tip}</p>}
      <dl className="grid gap-x-6 gap-y-1 text-text-secondary sm:grid-cols-2">
        <div className="flex gap-2"><dt className="font-semibold text-text-strong">Units</dt><dd>Enter centimetres and kilograms.</dd></div>
        <div className="flex gap-2"><dt className="font-semibold text-text-strong">Convert</dt><dd>1 m = 100 cm · 1 in = 2.54 cm · 1 ft = 30.48 cm · 1 lb = 0.454 kg</dd></div>
      </dl>
      <p className="text-text-secondary">These values are compared with each delivery vehicle's payload and cargo bed. Values that are too large block delivery estimates; values that are too small can send a vehicle that cannot carry the order.</p>
    </div>
  </details>
}
