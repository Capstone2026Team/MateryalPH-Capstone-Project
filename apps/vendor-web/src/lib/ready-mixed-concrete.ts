/**
 * Ready-Mixed Concrete listing rules (approved by the project owner on 2026-10-16), mirrored for the wizard; the
 * server's listing readiness stays authoritative. Ready-mixed concrete is sold per cubic meter, one variant per
 * Required PSI class with its own price, and is delivered only by a Concrete Mixer Truck / Transit Mixer, so it
 * has a weight per m³ (for payload) but no cargo dimensions. Bagged cement is not ready-mixed concrete.
 */
export const READY_MIXED_CONCRETE = 'READY_MIXED_CONCRETE'

export const STRENGTH_ATTRIBUTE = 'compressive_strength_psi'

/** Plain-language help under a ready-mixed concrete technical field, keyed by attribute code. */
export const ATTRIBUTE_DESCRIPTIONS: Record<string, string> = {
  maximum_aggregate_size_mm: 'The largest stone or gravel piece in the mix, in millimeters. Optional. Common sizes are 10, 20 and 25 mm — smaller stone suits thin slabs and pumping, larger stone suits foundations and heavy structural pours.',
}

/** Typical density of fresh normal-weight concrete, offered as a suggestion only. */
export const TYPICAL_KG_PER_M3 = '2400'

export function isReadyMixed(materialCode: string | null | undefined, categoryCode: string | null | undefined): boolean {
  return materialCode === READY_MIXED_CONCRETE || categoryCode === READY_MIXED_CONCRETE
}

/** "3000 PSI" from a variant's strength class, for the variant label. */
export function strengthLabel(psi: string | undefined): string | null {
  return psi && /^\d+$/.test(psi) ? `${Number(psi).toLocaleString('en-PH')} PSI` : null
}

/** Advisory: a weight per m³ far from normal-weight concrete usually means the wrong unit was entered. */
export function densityWarning(weightKg: string): string | null {
  const value = Number(weightKg)
  if (!weightKg.trim() || !Number.isFinite(value) || value <= 0) return null
  if (value < 1500 || value > 3000) return `${value.toLocaleString('en-PH')} kg per cubic meter is unusual for ready-mixed concrete (normally 2,200–2,500 kg). Check the weight.`
  return null
}

export type MixerRecommendation = {
  /** Concrete Mixer Trucks that are active and available to dispatch. */
  trucks: number
  /** Cubic meters the whole mixer fleet carries in one round of trips, never above a drum or its weight capacity. */
  perRoundM3: number
  /** The biggest load one truck carries, in m³. */
  largestLoadM3: number
  /** "2 × Isuzu (6 m³)" lines for the explanation. */
  parts: string[]
  /** True when a mixer's Maximum Weight Capacity, not its drum, limits what it can carry. */
  weightLimited: boolean
}

type MixerFleetRow = { vehicleType: string; name: string; active: boolean; available: boolean; numberAvailable: number; capacityKg: number; mixerCapacityM3?: number | null }

export const cubicMeterText = (value: number) => Number(value.toFixed(2)).toString()

/**
 * Volume suggestion for a ready-mixed concrete variant from the Vendor's listed Concrete Mixer Trucks: every available
 * truck carries its drum, capped by Maximum Weight Capacity ÷ weight per m³ when that weight is known.
 * Null when no mixer truck is listed.
 */
export function mixerRecommendation(vehicles: MixerFleetRow[], weightKgPerM3: string): MixerRecommendation | null {
  const weight = Number(weightKgPerM3)
  const mixers = vehicles.filter(vehicle => vehicle.vehicleType === 'CONCRETE_MIXER' && vehicle.active && vehicle.available && vehicle.numberAvailable > 0 && Number(vehicle.mixerCapacityM3) > 0)
  if (!mixers.length) return null
  let weightLimited = false
  let total = 0
  let largestLoadM3 = 0
  const parts = mixers.map(vehicle => {
    const drum = Number(vehicle.mixerCapacityM3)
    const byWeight = Number.isFinite(weight) && weight > 0 && vehicle.capacityKg > 0 ? vehicle.capacityKg / weight : Infinity
    const carried = Math.floor(Math.min(drum, byWeight) * 100) / 100
    if (carried < drum) weightLimited = true
    total += carried * vehicle.numberAvailable
    largestLoadM3 = Math.max(largestLoadM3, carried)
    return `${vehicle.numberAvailable} × ${vehicle.name} (${cubicMeterText(carried)} m³)`
  })
  return { trucks: mixers.reduce((sum, vehicle) => sum + vehicle.numberAvailable, 0), perRoundM3: Number(total.toFixed(2)), largestLoadM3, parts, weightLimited }
}

/** Each strength class should appear once; duplicates would offer the Buyer two prices for the same PSI. */
export function duplicateStrengths(rows: { attributes: Record<string, string> }[]): Set<number> {
  const seen = new Map<string, number>()
  const duplicates = new Set<number>()
  rows.forEach((row, index) => {
    const psi = row.attributes[STRENGTH_ATTRIBUTE]
    if (!psi) return
    if (seen.has(psi)) { duplicates.add(index); duplicates.add(seen.get(psi)!) } else seen.set(psi, index)
  })
  return duplicates
}

/** "2026-10-20T09:30" in Philippine time as an ISO instant with its +08:00 offset, for scheduling a site inspection. */
export function manilaInstant(local: string): string | null {
  return /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(local) ? `${local}:00+08:00` : null
}
