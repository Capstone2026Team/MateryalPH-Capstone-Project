import { expect, test } from 'vitest'
import { densityWarning, measurementSummary, measurementWarnings, suggestMeasurements, suggestedVariantLabel, suggestionApplied, technicalWarnings } from './listing-measurements'

const bar = { materialCode: 'REROLLED_STEEL_BAR', categoryCode: 'STEEL_AND_REINFORCEMENT', unitCode: 'PC', packQuantity: '1', attributes: { diameter_mm: '12', length_m: '6', grade: 'Grade 230' } }

test('a steel bar sold per piece gets its standard mass and true size from Technical details', () => {
  const suggestion = suggestMeasurements(bar)
  // 12² ÷ 162 × 6 m = 5.333 kg; 6 m = 600 cm; 12 mm = 1.2 cm across.
  expect(suggestion?.values).toEqual({ lengthCm: '600', weightKg: '5.333', widthCm: '1.2', heightCm: '1.2' })
  expect(suggestion?.measureYourself).toEqual([])
  expect(suggestMeasurements({ ...bar, packQuantity: '10' })?.values).toEqual({ lengthCm: '600', weightKg: '53.333' })
})

test('angle bars get only the size, and unrelated units get no suggestion', () => {
  expect(suggestMeasurements({ ...bar, materialCode: 'EQUAL_LEG_ANGLE_BAR' })).toMatchObject({ values: { lengthCm: '600', widthCm: '1.2', heightCm: '1.2' }, measureYourself: ['weightKg'] })
  expect(suggestMeasurements({ ...bar, unitCode: 'KG' })).toBeNull()
})

test('bags, hollow blocks, plywood sheets and tiles derive what their Technical details state', () => {
  expect(suggestMeasurements({ materialCode: 'PORTLAND_CEMENT', categoryCode: 'CEMENT_AND_CONCRETE', unitCode: 'BAG', packQuantity: '1', attributes: { bag_weight_kg: '40' } })).toMatchObject({ values: { weightKg: '40' }, measureYourself: ['lengthCm', 'widthCm', 'heightCm'] })
  expect(suggestMeasurements({ materialCode: 'CONCRETE_HOLLOW_BLOCK', categoryCode: 'MASONRY', unitCode: 'PC', packQuantity: '1', attributes: { thickness_mm: '100' } })?.values).toEqual({ lengthCm: '40', widthCm: '10', heightCm: '20' })
  expect(suggestMeasurements({ materialCode: 'PLYWOOD', categoryCode: 'WOOD_AND_LUMBER', unitCode: 'SHEET', packQuantity: '1', attributes: { thickness_mm: '12' } })?.values).toEqual({ lengthCm: '244', widthCm: '122', heightCm: '1.2' })
  expect(suggestMeasurements({ materialCode: 'CERAMIC_TILE', categoryCode: 'FLOORING_MATERIALS', unitCode: 'PC', packQuantity: '1', attributes: { work_size_mm: '300 x 600' } })?.values).toEqual({ lengthCm: '60', widthCm: '30' })
})

test('entered values that disagree with Technical details or a truck bed are flagged per field', () => {
  const suggestion = suggestMeasurements({ ...bar, attributes: { diameter_mm: '15', length_m: '12' } })!
  const stored = { weightKg: '20', lengthCm: '231', widthCm: '323', heightCm: '123123' }
  const warnings = measurementWarnings(stored, suggestion, 'piece')
  expect(warnings.lengthCm).toBe('Technical details point to about 1,200 cm for the length.')
  expect(warnings.heightCm).toMatch(/longer than any delivery truck bed/)
  expect(warnings.weightKg).toMatch(/about 16.667 kg/)
  expect(densityWarning(stored)).toMatch(/lighter than packing foam/)
  expect(suggestionApplied(suggestion, stored)).toBe(false)
  const corrected = { weightKg: '16.7', lengthCm: '1200', widthCm: '1.5', heightCm: '1.5' }
  expect(measurementWarnings(corrected, suggestion, 'piece')).toEqual({})
  expect(suggestionApplied(suggestion, corrected)).toBe(true)
  expect(densityWarning(corrected)).toBeNull()
  expect(measurementSummary(corrected)).toBe('12 m × 1.5 cm × 1.5 cm · 16.7 kg')
})

test('Technical details that look like a unit mistake are flagged and labels are suggested', () => {
  const definitions = [{ code: 'length_m', unitCode: 'm' }, { code: 'diameter_mm', unitCode: 'mm' }]
  expect(technicalWarnings('STEEL_AND_REINFORCEMENT', { length_m: '120', diameter_mm: '15' }, definitions)).toEqual({ length_m: expect.stringMatching(/6 to 12 m/) })
  expect(technicalWarnings('STEEL_AND_REINFORCEMENT', { length_m: '12', diameter_mm: '16' }, definitions)).toEqual({})
  expect(suggestedVariantLabel('STEEL_AND_REINFORCEMENT', { length_m: '7.5', diameter_mm: '16' })).toBe('16 mm × 7.5 m')
  expect(suggestedVariantLabel('CEMENT_AND_CONCRETE', { bag_weight_kg: '40' })).toBe('40 kg')
  expect(suggestedVariantLabel('AGGREGATES', {})).toBeNull()
})
