import { readFileSync, writeFileSync } from 'node:fs'

// Additive reporting fields; payment and refund state families remain independent.
const file = new URL('../openapi.yaml', import.meta.url)
const original = readFileSync(file, 'utf8')
let source = original.replaceAll('\r\n', '\n')
for (const name of ['VendorEarnings', 'VendorEarningsTrendFigures', 'VendorEarningsTrendPoint', 'VendorEarningsTrendChange']) {
  const pattern = new RegExp(`(    "${name}":\\n)([\\s\\S]*?)(?=\\n    "[^"\\n]+":|$)`)
  source = source.replace(pattern, (match, heading, body) => {
    if (!body.includes('"online_refunds_centavos"')) {
      body = body.replace('        - "online_collections_centavos"', '        - "online_collections_centavos"\n        - "online_refunds_centavos"')
      const property = name === 'VendorEarningsTrendChange'
        ? '        "online_refunds_centavos":\n          "type": ["number", "null"]\n'
        : '        "online_refunds_centavos":\n          "type": "integer"\n          "minimum": 0\n          "description": "Confirmed online refunds, including their refunded Buyer fees, attributed to the original payment date. Pending and failed refunds do not reduce collections."\n'
      body = body.replace('        "buyer_processing_fees_centavos":', property + '        "buyer_processing_fees_centavos":')
    }
    if (name !== 'VendorEarningsTrendChange') {
      body = body.replace(/("online_collections_centavos":\n          "type": "integer"\n          "minimum": 0)(?!\n          "description")/, '$1\n          "description": "Verified online principal less confirmed refunded principal, attributed to the original payment date; fully refunded principal contributes zero."')
    }
    return heading + body
  })
}
source = source.replace('Owner-only FIN-11 Earnings with separate sales, collections, charges, simulated CWT and commission.',
  'Owner-only FIN-11 Earnings with separate sales, confirmed online refunds, net online collections, charges, simulated CWT and commission. Confirmed refunds adjust the original payment and assessment date buckets; pending and failed refunds leave collections unchanged. Posted provider charges, CWT and FIN-04A thresholds remain unchanged; estimated remittance cash deducts confirmed refunds without deducting refunds already included in the assessment twice.')
source = source.replace(/(    "FinanceTransactionListEnvelope":\n      "type": "object"\n)(?!      "description")/,
  '$1      "description": "Owner-only paginated transaction rows. PAYMENTS rows preserve the original payment status and gross/Buyer-fee amounts and additionally return refund_state (NOT_REQUESTED, REFUND_PENDING, REFUND_FAILED, PARTIALLY_REFUNDED or REFUNDED), refunded_centavos (confirmed refunds only) and net_collected_centavos (verified gross less confirmed refunds; zero for unpaid attempts). Refunds are aggregated per original payment, never inferred from order cancellation."\n')
writeFileSync(file, original.includes('\r\n') ? source.replaceAll('\n', '\r\n') : source)
console.log('Authored payment refund reporting contract.')
