import type { QuantityPolicy } from '@materyalph/api-client-ts'
import { Field, type FieldProps } from './field'

export function sellingQuantityLabel(code: string, dimension?: string): string {
  const symbols: Record<string, string> = { CUM: 'm³', SQM: 'm²', US_GAL: 'US gal', M: 'm', KG: 'kg' }
  const dimensions: Record<string, string> = { CUM: 'VOLUME', L: 'VOLUME', US_GAL: 'VOLUME', KG: 'MASS', M: 'LENGTH', SQM: 'AREA' }
  const names: Record<string, string> = { VOLUME: 'Volume', MASS: 'Weight', LENGTH: 'Length', AREA: 'Area' }
  const kind = names[dimension ?? dimensions[code] ?? '']
  const counts: Record<string, string> = { GAL: 'Gallon cans', BAG: 'Bags', BOX: 'Boxes', ROLL: 'Rolls', COIL: 'Coils', SHEET: 'Sheets', PC: 'Pieces' }
  return kind ? `${kind} (${symbols[code] ?? code})` : counts[code] ?? `Quantity (${code})`
}

export function validSellingQuantity(value: string, precision: number): boolean {
  if (!/^\d{1,14}(\.\d{1,4})?$/.test(value.trim())) return false
  return (value.trim().split('.')[1] ?? '').replace(/0+$/, '').length <= precision
}

/** One quantity input for stock, quotation and ordering forms. No rounding on edits. */
export function QuantityField({ policy, unitCode, label, ...props }: Omit<FieldProps, 'label'> & { unitCode: string; policy?: QuantityPolicy | undefined; label?: string | undefined }) {
  const counted = ['PC', 'BAG', 'BOX', 'ROLL', 'SHEET', 'COIL', 'GAL'].includes(unitCode)
  const precision = policy?.precision ?? (counted ? 0 : 3)
  return <Field {...props} label={label ?? sellingQuantityLabel(unitCode, policy?.dimension)} inputMode={precision === 0 ? 'numeric' : 'decimal'} step={policy?.step ?? (precision === 0 ? '1' : '0.001')} error={props.error ?? (typeof props.value === 'string' && props.value.trim() && !validSellingQuantity(props.value, precision) ? (precision === 0 ? 'Enter a whole number for this selling unit.' : `Use up to ${precision} decimal places.`) : undefined)} />
}
