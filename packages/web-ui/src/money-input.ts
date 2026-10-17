function groupDigits(value: string): string {
  return value.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
}

/** Convert decimal peso text into an exact, safely representable integer amount. */
export function parsePesoInput(value: string): number | null {
  const text = value.trim().replaceAll(',', '')
  if (!/^(?:\d+(?:\.\d{0,2})?|\.\d{1,2})$/.test(text)) return null
  const [whole = '0', fraction = ''] = text.split('.')
  const centavos = Number(`${whole || '0'}${fraction.padEnd(2, '0')}`)
  return Number.isSafeInteger(centavos) ? centavos : null
}

/** Retain incomplete decimal input and format only its whole-peso part. */
export function formatPesoInput(value: string): string {
  const text = value.replaceAll(',', '')
  if (!/^\d*(?:\.\d{0,2})?$/.test(text)) return value
  const [whole = '', fraction = ''] = text.split('.')
  const grouped = groupDigits(whole.replace(/^0+(?=\d)/, ''))
  return text.includes('.') ? `${grouped}.${fraction}` : grouped
}

export function pesoInputFromCentavos(centavos: number | null): string {
  if (centavos === null || !Number.isSafeInteger(centavos) || centavos < 0) return ''
  const digits = String(centavos).padStart(3, '0')
  return `${groupDigits(digits.slice(0, -2))}.${digits.slice(-2)}`
}

/** Keep the insertion point beside the same digit when grouping adds a comma. */
export function pesoInputCaret(raw: string, position: number, formatted: string): number {
  if (raw === formatted) return position
  const count = raw.slice(0, position).replaceAll(',', '').length
  if (count === 0) return 0
  let seen = 0
  for (let index = 0; index < formatted.length; index += 1) {
    if (formatted[index] !== ',') seen += 1
    if (seen === count) return index + 1
  }
  return formatted.length
}
