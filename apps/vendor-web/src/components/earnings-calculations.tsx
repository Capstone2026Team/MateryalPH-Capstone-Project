import { formatPesoCentavos } from '@materyalph/web-ui'
import type { VendorEarnings } from '../lib/finance-api'

/** One explanation per figure, reused by its overview card, chart and calculation rows. */
export function earningsCalculations(data: VendorEarnings) {
  const comparison = <p>Dates use Asia/Manila. The comparison uses the preceding period of the same length; a percentage is unavailable when the previous total is zero.</p>
  return {
    commercialSales: <>
      <p>Earnings = materials − discounts + delivery − completed refunds. VAT is included. Cancelled and fully refunded sales contribute zero.</p>
      <p>Uses the order’s first confirmation date, exactly like Earnings on the Dashboard. The same dates show the same sales total. This is before platform commission charges and business costs.</p>
      <p>Includes Online, Cash on Delivery and In-Store sales. E-wallet transaction fees are excluded. The Gross-remittance threshold uses assessed online payments for the whole taxable year, so its starting payment total can differ.</p>
      {comparison}
    </>,
    productSales: <>
      <p>Product values are after discounts and include VAT, before partial refunds. Uses the same confirmed orders and dates as Earnings.</p>
      <p>Product sales value + delivery − completed refunds = earnings. Cancelled and fully refunded sales are left out.</p>
      <p>Product share is its sales value divided by total product sales value. A share is unavailable when the total is zero.</p>
    </>,
    onlineCollections: <>
      <p>Verified online payment principal − confirmed refunds of that principal, using the original payment date. E-wallet transaction fees are shown separately and are never store revenue.</p>
      <p>Refunded money is not counted as paid. Confirmed online refunds for these payment dates total <strong>{formatPesoCentavos(data.onlineRefundsCentavos)}</strong>, including refunded E-wallet transaction fees. Pending or failed refunds remain counted.</p>
      {comparison}
    </>,
    physicalCollections: <>
      <p>Cash on Delivery + In-Store Payment receipts recorded by your store, counted on the date received.</p>
      <p>Cash entered at delivery or pickup by the Owner, Store Manager or Store Staff counts at once. Cash reported by Fulfillment Staff counts once one of them confirms it.</p>
      <p>Cash still owed on delivered or picked-up orders is shown beside the recorded total and is never counted as collected. Cash receipts do not equal taxable income.</p>
      {comparison}
    </>,
    remittance: <>
      <p>Xendit cash revenue = retained online order payments − creditable withholding tax.</p>
      <p>Uses online payment assessments in the selected dates. Fully refunded payments are excluded and completed partial refunds are subtracted once. Pending or failed refunds are not treated as completed. Direct cash payments are shown under Physical collections.</p>
      <p>E-wallet transaction fees are paid separately by Buyers. The reconciled order-payment amount excludes that fee flow; these fees are not deducted from the Vendor’s order principal again.</p>
      <p>Platform commission charges are billed separately each month. This estimate uses TEST records and does not show available provider funds or a settlement date.</p>
      {comparison}
    </>,
    buyerFees: <>
      <p>E-wallet transaction fees paid by Buyers at the configured DEMO channel rate, without markup. They are separate from payment principal and are never store revenue.</p>
      <p>Uses original payment dates and excludes confirmed refunded E-wallet transaction fees. Pending or failed refunds remain counted.</p>
    </>,
    providerCharges: <>
      <p>Provider charges belong to the payment-fee reconciliation. Buyer-funded fees are separate from Vendor order principal and are never deducted from it again.</p>
      <p>Uses remittances assessed in the selected dates. A fully refunded collection contributes no provider charge to this estimate. Rounded provider postings can differ by a centavo or two.</p>
    </>,
    cwt: <>
      <p>Creditable withholding tax: <strong>{formatPesoCentavos(data.simulatedCwtCentavos)}</strong>. This tax amount is set aside from Xendit cash revenue estimates and recorded as a tax credit for the Vendor.</p>
      <p>The recorded assessment applies the relevant tax profile and annual threshold. It does not reduce Earnings and is separate from platform commission charges.</p>
      <p>Tax figures use TEST records and do not confirm actual tax payment or BIR filing.</p>
    </>,
    commission: <>
      <p>Platform commission charges are the Vendor’s fee for completed orders, after approved credits. The saved order rate applies to materials after discounts, excluding materials VAT and delivery.</p>
      <p>Billed monthly for every payment method. Charges are not deducted from the Xendit cash revenue estimate again. Estimated charges of <strong>{formatPesoCentavos(data.estimatedCommissionCentavos)}</strong> relate to orders not yet completed.</p>
      <p>Uses recorded commission events in the selected dates. Issued unpaid statements are shown separately.</p>
    </>,
    salesChart: <>
      <p>Earnings use the order’s first confirmation date, matching the Dashboard. Online collections use the verified payment date; physical collections use the recorded receipt date.</p>
      <p>Sales and collections can fall on different days. They are separate measures and must not be added together. Online collections exclude confirmed refunded principal and E-wallet transaction fees.</p>
      {comparison}
    </>,
    deductionsChart: <>
      <p>Creditable withholding tax is recorded against Xendit cash revenue estimates. Platform commission charges are billed separately each month. Buyer-paid transaction fees belong to a separate payment-fee flow.</p>
      <p>Charges and tax use their recorded assessment dates. Platform commission charges use completion and approved-credit dates. These charges are not subtracted from Earnings.</p>
    </>,
  }
}
