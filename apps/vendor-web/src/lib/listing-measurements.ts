/**
 * Advisory checks that keep a listing's Technical details and its per-variant weight and dimensions describing
 * the same physical product. Nothing here blocks saving: the server stays authoritative, and delivery vehicle
 * checks read the saved per-sale-unit weight and dimensions.
 */

export type MeasureKey = 'weightKg' | 'lengthCm' | 'widthCm' | 'heightCm'
export type Measures = Record<MeasureKey, string>

export type MeasurementContext = {
  materialCode: string | null
  categoryCode: string | null
  unitCode: string | null
  packQuantity: string
  attributes: Record<string, string>
}

export type MeasurementSuggestion = {
  values: Partial<Measures>
  /** What the suggestion is derived from, in the Vendor's terms. */
  basis: string
  /** Measurements the suggestion cannot derive and the Vendor still has to measure. */
  measureYourself: MeasureKey[]
}

const STEEL_BARS = ['DEFORMED_STEEL_BAR', 'REROLLED_STEEL_BAR']
const LABELS: Record<MeasureKey, string> = { weightKg: 'weight', lengthCm: 'length', widthCm: 'width', heightCm: 'height' }
/** Relative difference tolerated between an entered value and the value implied by Technical details. */
const TOLERANCE: Record<MeasureKey, number> = { weightKg: 0.1, lengthCm: 0.05, widthCm: 0.25, heightCm: 0.25 }

function positive(value: string | undefined): number | null {
  if (value === undefined || value.trim() === '') return null
  const number = Number(value)
  return Number.isFinite(number) && number > 0 ? number : null
}

function fixed(value: number, decimals: number): string {
  return String(Number(value.toFixed(decimals)))
}

const grouped = (value: number, decimals = 2) => value.toLocaleString('en-PH', { maximumFractionDigits: decimals })

/** Reads "600 x 600" or "300×600 mm" into two millimetre sides. */
function workSize(value: string | undefined): [number, number] | null {
  const match = value?.match(/(\d+(?:\.\d+)?)\s*(?:x|×|by)\s*(\d+(?:\.\d+)?)/i)
  return match ? [Number(match[1]), Number(match[2])] : null
}

/** Weight and dimensions of one sale unit implied by Technical details, or null when nothing can be derived. */
export function suggestMeasurements(context: MeasurementContext): MeasurementSuggestion | null {
  const { materialCode, categoryCode, unitCode, attributes } = context
  const pack = positive(context.packQuantity) ?? 1
  const single = pack === 1
  const diameter = positive(attributes.diameter_mm)
  const lengthM = positive(attributes.length_m)
  if (unitCode === 'PC' && categoryCode === 'STEEL_AND_REINFORCEMENT' && lengthM !== null) {
    const bar = materialCode !== null && STEEL_BARS.includes(materialCode) && diameter !== null
    const values: Partial<Measures> = { lengthCm: fixed(lengthM * 100, 2) }
    if (bar) values.weightKg = fixed((diameter * diameter) / 162 * lengthM * pack, 3)
    if (single && diameter !== null) Object.assign(values, { widthCm: fixed(diameter / 10, 2), heightCm: fixed(diameter / 10, 2) })
    const basis = bar
      ? `${grouped(diameter)} mm bar, ${grouped(lengthM)} m long. Standard steel bar mass is diameter² ÷ 162 kg per metre${single ? '' : `, times ${grouped(pack, 4)} pieces per pack`}.`
      : `${grouped(lengthM)} m length${diameter !== null ? ` and ${grouped(diameter)} mm size` : ''} from Technical details.`
    return { values, basis, measureYourself: (['weightKg', 'widthCm', 'heightCm'] as MeasureKey[]).filter(key => !values[key]) }
  }
  const bagMass = positive(attributes.bag_weight_kg)
  if (unitCode === 'BAG' && bagMass !== null) {
    return { values: { weightKg: fixed(bagMass * pack, 3) }, basis: `${grouped(bagMass)} kg per bag from Technical details${single ? '' : `, times ${grouped(pack, 4)} bags per pack`}.`, measureYourself: ['lengthCm', 'widthCm', 'heightCm'] }
  }
  const thickness = positive(attributes.thickness_mm)
  if (single && unitCode === 'PC' && materialCode === 'CONCRETE_HOLLOW_BLOCK' && thickness !== null) {
    return { values: { lengthCm: '40', widthCm: fixed(thickness / 10, 2), heightCm: '20' }, basis: `Standard hollow block face of 40 × 20 cm with the ${grouped(thickness)} mm thickness from Technical details.`, measureYourself: ['weightKg'] }
  }
  if (single && unitCode === 'SHEET' && materialCode === 'PLYWOOD' && thickness !== null) {
    return { values: { lengthCm: '244', widthCm: '122', heightCm: fixed(thickness / 10, 2) }, basis: `Standard 4 × 8 ft (244 × 122 cm) sheet with the ${grouped(thickness)} mm thickness from Technical details. Change it if you sell cut sizes.`, measureYourself: ['weightKg'] }
  }
  const tile = workSize(attributes.work_size_mm)
  if (single && unitCode === 'PC' && tile !== null) {
    const [first, second] = [Math.max(...tile), Math.min(...tile)]
    return { values: { lengthCm: fixed(first / 10, 2), widthCm: fixed(second / 10, 2) }, basis: `${tile[0]} × ${tile[1]} mm work size from Technical details.`, measureYourself: ['weightKg', 'heightCm'] }
  }
  const nailLength = positive(attributes.length_mm)
  if (single && unitCode === 'PC' && nailLength !== null) {
    const values: Partial<Measures> = { lengthCm: fixed(nailLength / 10, 2) }
    if (diameter !== null) Object.assign(values, { widthCm: fixed(diameter / 10, 2), heightCm: fixed(diameter / 10, 2) })
    return { values, basis: `${grouped(nailLength)} mm length${diameter !== null ? ` and ${grouped(diameter)} mm diameter` : ''} from Technical details.`, measureYourself: (['weightKg', 'widthCm', 'heightCm'] as MeasureKey[]).filter(key => !values[key]) }
  }
  return null
}

/** True when every suggested value is already entered within tolerance. */
export function suggestionApplied(suggestion: MeasurementSuggestion, measures: Measures): boolean {
  return (Object.keys(suggestion.values) as MeasureKey[]).every(key => withinTolerance(key, measures[key], suggestion.values[key]))
}

function withinTolerance(key: MeasureKey, entered: string, expected: string | undefined): boolean {
  const actual = positive(entered)
  const target = positive(expected)
  if (actual === null || target === null) return actual === target
  return Math.abs(actual - target) / target <= TOLERANCE[key]
}

/** Field-level warnings for entered values that disagree with Technical details or are physically unlikely. */
export function measurementWarnings(measures: Measures, suggestion: MeasurementSuggestion | null, unit: string): Partial<Record<MeasureKey, string>> {
  const warnings: Partial<Record<MeasureKey, string>> = {}
  for (const key of ['lengthCm', 'widthCm', 'heightCm'] as const) {
    const value = positive(measures[key])
    if (value !== null && value > 1500) warnings[key] = `${grouped(value / 100)} m is longer than any delivery truck bed. Check that this is in centimetres.`
  }
  const weight = positive(measures.weightKg)
  if (weight !== null && weight > 2000) warnings.weightKg = `${grouped(weight)} kg for one ${unit || 'unit'} is unusually heavy. Check that this is the weight of one sale unit in kilograms.`
  if (suggestion) {
    for (const key of Object.keys(suggestion.values) as MeasureKey[]) {
      if (warnings[key] || positive(measures[key]) === null || withinTolerance(key, measures[key], suggestion.values[key])) continue
      const expected = Number(suggestion.values[key])
      warnings[key] = key === 'weightKg'
        ? `Technical details point to about ${grouped(expected, 3)} kg. Check the scale reading or the Technical details.`
        : `Technical details point to about ${grouped(expected)} cm for the ${LABELS[key]}.`
    }
  }
  return warnings
}

/** A whole-unit warning when weight and size cannot both be right, for example 20 kg filling hundreds of cubic metres. */
export function densityWarning(measures: Measures): string | null {
  const [weight, length, width, height] = [positive(measures.weightKg), positive(measures.lengthCm), positive(measures.widthCm), positive(measures.heightCm)]
  if (weight === null || length === null || width === null || height === null) return null
  const volume = (length * width * height) / 1_000_000
  const density = weight / volume
  if (volume > 0.001 && density < 5) return `${grouped(weight, 3)} kg spread over ${grouped(volume, 3)} m³ is lighter than packing foam. One of the measurements is probably in the wrong unit.`
  if (density > 9000) return `${grouped(weight, 3)} kg in ${grouped(volume, 4)} m³ would be denser than solid steel. Check the weight or the dimensions.`
  return null
}

/** "12 m × 1.6 cm × 1.6 cm · 18.963 kg" in the units people check by eye. */
export function measurementSummary(measures: Measures): string | null {
  const sides = (['lengthCm', 'widthCm', 'heightCm'] as const).map(key => positive(measures[key]))
  const weight = positive(measures.weightKg)
  if (sides.every(side => side === null) && weight === null) return null
  const side = (value: number | null) => value === null ? '—' : value >= 100 ? `${grouped(value / 100)} m` : `${grouped(value)} cm`
  return `${sides.map(side).join(' × ')}${weight === null ? '' : ` · ${grouped(weight, 3)} kg`}`
}

/** Technical detail values that look like a unit mistake, keyed by attribute code. */
export function technicalWarnings(categoryCode: string | null, attributes: Record<string, string>, definitions: { code: string; unitCode?: string | null }[]): Record<string, string> {
  const warnings: Record<string, string> = {}
  for (const definition of definitions) {
    const value = positive(attributes[definition.code])
    if (value === null) continue
    if (categoryCode === 'STEEL_AND_REINFORCEMENT' && definition.code === 'length_m' && value > 12) warnings[definition.code] = 'Steel bars and angles are usually supplied 6 to 12 m long. Check that this is in metres.'
    else if (categoryCode === 'STEEL_AND_REINFORCEMENT' && definition.code === 'diameter_mm' && value > 75) warnings[definition.code] = 'Bar diameters and angle legs are usually 6 to 75 mm. Check that this is in millimetres.'
    else if (definition.code === 'bag_weight_kg' && value > 100) warnings[definition.code] = 'Cement bags are usually 25 to 50 kg. Check that this is in kilograms.'
    else if (definition.unitCode === 'mm' && value > 1000) warnings[definition.code] = 'Over 1,000 mm. Check that this is in millimetres.'
    else if (definition.unitCode === 'm' && value > 20) warnings[definition.code] = 'Over 20 m. Check that this is in metres.'
  }
  return warnings
}

/** A measuring tip for the material or category, or null when there is nothing specific to add. */
export function measuringTip(materialCode: string | null, categoryCode: string | null): string | null {
  if (materialCode !== null && STEEL_BARS.includes(materialCode)) return 'Steel bar weight per metre is diameter² ÷ 162. A 12 mm × 6 m bar weighs about 5.33 kg.'
  if (categoryCode === 'CEMENT_AND_CONCRETE') return 'Weigh a full, sealed bag. Measure it lying flat; the height is its thickness.'
  if (materialCode === 'CONCRETE_HOLLOW_BLOCK') return 'Measure the face (length × height) and the thickness of one block. Weigh a dry block.'
  if (categoryCode === 'WOOD_AND_LUMBER') return 'Measure one sheet or board lying flat. Moisture changes weight, so weigh stock as it is stored.'
  if (categoryCode === 'PLUMBING_AND_SANITARY' || categoryCode === 'DRAINAGE_AND_SEPTIC') return 'Use the outside diameter of the pipe for width and height, not the nominal size.'
  return null
}

/** A variant label from Technical details, such as "16 mm × 6 m" or "40 kg". */
export function suggestedVariantLabel(categoryCode: string | null, attributes: Record<string, string>): string | null {
  const diameter = positive(attributes.diameter_mm)
  const lengthM = positive(attributes.length_m)
  if (categoryCode === 'STEEL_AND_REINFORCEMENT' && diameter !== null && lengthM !== null) return `${grouped(diameter)} mm × ${grouped(lengthM)} m`
  const bagMass = positive(attributes.bag_weight_kg)
  if (bagMass !== null) return `${grouped(bagMass)} kg`
  const thickness = positive(attributes.thickness_mm)
  if (thickness !== null) return `${grouped(thickness)} mm`
  const size = positive(attributes.nominal_size_mm) ?? positive(attributes.size_mm)
  if (size !== null) return `${grouped(size)} mm`
  return attributes.work_size_mm?.trim() ? `${attributes.work_size_mm.trim()} mm` : null
}
