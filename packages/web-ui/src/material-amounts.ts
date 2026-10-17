export type MaterialAmountLine = { id: string; quantity: string; unitPriceCentavos: number }

export function materialQuantity(value: string): bigint | null {
  if (!/^\d{1,10}(\.\d{1,4})?$/.test(value)) return null
  const [whole = '0', fraction = ''] = value.split('.')
  return BigInt(`${whole}${fraction.padEnd(4, '0')}`)
}

/** Advisory FIN-02 amounts: half-up lines and largest-remainder discounts, tied by stable line ID. */
export function materialPayablePreview(lines: MaterialAmountLine[], discountCentavos: number, allowZeroQuantity = false):
  | { valid: false; message: string }
  | { valid: true; grossCentavos: number; payableCentavos: number; linePayableCentavos: Record<string, number> } {
  const invalid = (message: string) => ({ valid: false as const, message })
  if (!lines.length) return invalid('Add materials to see their payable values.')
  const gross = new Map<string, bigint>()
  for (const line of lines) {
    const quantity = materialQuantity(line.quantity)
    if (quantity === null || (!allowZeroQuantity && quantity === 0n) || !Number.isSafeInteger(line.unitPriceCentavos) || line.unitPriceCentavos < 1 || gross.has(line.id)) return invalid('Enter valid material quantities and unit prices.')
    gross.set(line.id, (quantity * BigInt(line.unitPriceCentavos) + 5000n) / 10000n)
  }
  const total = [...gross.values()].reduce((sum, amount) => sum + amount, 0n)
  if (total <= 0n) return invalid('Materials must have a positive subtotal.')
  if (total > BigInt(Number.MAX_SAFE_INTEGER)) return invalid('The amount exceeds the supported display range.')
  if (!Number.isSafeInteger(discountCentavos) || discountCentavos < 0 || BigInt(discountCentavos) >= total) return invalid('The materials discount must leave a positive subtotal.')
  const discount = BigInt(discountCentavos)
  const shares = [...gross].map(([id, amount]) => ({ id, amount, deduction: discount * amount / total, remainder: discount * amount % total }))
  let leftover = discount - shares.reduce((sum, share) => sum + share.deduction, 0n)
  shares.sort((a, b) => a.remainder === b.remainder ? (a.id < b.id ? -1 : a.id > b.id ? 1 : 0) : a.remainder > b.remainder ? -1 : 1)
  for (const share of shares) {
    if (leftover === 0n) break
    share.deduction += 1n
    leftover -= 1n
  }
  return { valid: true, grossCentavos: Number(total), payableCentavos: Number(total - discount), linePayableCentavos: Object.fromEntries(shares.map(share => [share.id, Number(share.amount - share.deduction)])) }
}
