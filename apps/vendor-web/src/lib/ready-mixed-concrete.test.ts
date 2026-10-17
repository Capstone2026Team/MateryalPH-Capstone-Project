import { describe, expect, it } from 'vitest'
import { densityWarning, duplicateStrengths, isReadyMixed, mixerRecommendation, strengthLabel } from './ready-mixed-concrete'

describe('ready-mixed concrete listing helpers', () => {
  it('recognises ready-mixed concrete but never bagged cement', () => {
    expect(isReadyMixed('READY_MIXED_CONCRETE', null)).toBe(true)
    expect(isReadyMixed(null, 'READY_MIXED_CONCRETE')).toBe(true)
    expect(isReadyMixed('PORTLAND_CEMENT', 'CEMENT_AND_CONCRETE')).toBe(false)
  })

  it('labels strength classes and flags unusual densities or repeated PSI', () => {
    expect(strengthLabel('3000')).toBe('3,000 PSI')
    expect(strengthLabel('')).toBeNull()
    expect(densityWarning('2400')).toBeNull()
    expect(densityWarning('24')).toContain('unusual')
    expect([...duplicateStrengths([{ attributes: { compressive_strength_psi: '3000' } }, { attributes: { compressive_strength_psi: '4000' } }, { attributes: { compressive_strength_psi: '3000' } }])].sort()).toEqual([0, 2])
  })

  it('suggests the batch volume from available mixer trucks, capped by weight capacity', () => {
    const mixer = (patch: Record<string, unknown> = {}) => ({ vehicleType: 'CONCRETE_MIXER', name: 'Mixer A', active: true, available: true, numberAvailable: 2, capacityKg: 20000, mixerCapacityM3: 6, ...patch })
    const cargo = { vehicleType: 'DUMP_TRUCK', name: 'Dump', active: true, available: true, numberAvailable: 3, capacityKg: 10000, mixerCapacityM3: null }
    expect(mixerRecommendation([cargo], '2400')).toBeNull()
    expect(mixerRecommendation([mixer({ available: false }), mixer({ active: false })], '2400')).toBeNull()
    expect(mixerRecommendation([mixer(), cargo], '')).toMatchObject({ trucks: 2, perRoundM3: 12, largestLoadM3: 6, weightLimited: false })
    expect(mixerRecommendation([mixer(), mixer({ name: 'Mixer B', numberAvailable: 1, mixerCapacityM3: 8, capacityKg: 16000 })], '2400')).toMatchObject({ trucks: 3, perRoundM3: 18.66, largestLoadM3: 6.66, weightLimited: true })
  })
})
