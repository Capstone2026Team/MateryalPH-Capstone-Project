import { AsyncLoading } from './async-state'
import { useEffect, useState, type ReactNode } from 'react'
import type { VendorThresholdPayments } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Pagination } from './filter-controls'
import { formatManilaDateTime } from './stock-ledger'
import { formatPesoCentavos } from './order-patterns'
import { FinanceCalculationBreakdown, FinanceWithholdingCalculation } from './finance-patterns'

export type AssessedPaymentPage = { data: VendorThresholdPayments; hasMore: boolean; total: number }

/** Load private annual source records when the authorized remittance view is shown. */
export function AssessedPaymentBreakdown({ load, readError, historyLink }: {
  load: (page: number) => Promise<AssessedPaymentPage>; readError: (cause: unknown) => Promise<string>; historyLink?: ReactNode
}) {
  const [page, setPage] = useState(1)
  const [attempt, setAttempt] = useState(0)
  const [result, setResult] = useState<AssessedPaymentPage | null>(null)
  const [error, setError] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setResult(null)
    setError(null)
    load(page).then(value => { if (active) setResult(value) }).catch(async cause => {
      const message = await readError(cause)
      if (active) setError(message)
    })
    return () => { active = false }
  }, [page, attempt, load, readError])
  const totals = result?.data.totals
  const other = result?.data.otherStoreTotals
  const showTotal = result && (result.hasMore || page > 1 || Boolean(other))
  return <section className="mp-assessed-payments" aria-label="Annual retained online payments">
    <header><h3>Annual retained online payments{totals ? ` (${totals.assessedPayments})` : ''}</h3></header>
    <div className="mp-assessed-payment-content" aria-busy={!result && !error}>
      {error ? <div role="alert"><p>{error}</p><Button variant="secondary" onClick={() => setAttempt(value => value + 1)}>Retry payment breakdown</Button></div>
        : !result ? <AsyncLoading compact label="Loading assessed payments…" /> : <>
          <p className="mp-assessed-payment-context">Taxable year {result.data.taxableYear} · Completed refunds excluded · Buyer-paid fees separate</p>
          <p className="mp-assessed-payment-context">Full taxable year, regardless of the selected Xendit cash revenue or Transactions dates.</p>
          {result.data.payments.length > 0 ? <ol className="mp-assessed-payment-list" aria-label="Retained online payment sources">{result.data.payments.map(row => <li key={row.id}>
            <article className="mp-assessed-payment" aria-label={row.orderReference}>
              <header className="mp-assessed-payment-heading">
                <div className="mp-assessed-payment-order"><h4>{row.orderReference}</h4><p>Assessed {formatManilaDateTime(row.assessedAt)}</p></div>
                <dl className="mp-assessed-payment-retained"><div><dt>Order amount after refunds</dt><dd>{formatPesoCentavos(row.paymentPrincipalCentavos)}</dd></div></dl>
              </header>
              <div className="mp-assessed-payment-calculation">
                <section aria-label={`Recorded tax basis · ${row.orderReference}`}>
                  <h5>Recorded tax basis</h5>
                  <FinanceCalculationBreakdown caption={`Tax basis · ${row.orderReference}`} rows={[
                    { key: 'payment', label: 'Online payment at assessment', amountCentavos: row.assessedPaymentCentavos },
                    { key: 'delivery', label: 'Delivery', amountCentavos: row.deliveryCentavos, deduction: true },
                    { key: 'vat', label: 'Material VAT', amountCentavos: row.materialVatCentavos, deduction: true },
                  ]} totalLabel="Tax basis" totalCentavos={row.grossBasisCentavos} />
                </section>
                <section className="mp-assessed-payment-withholding" aria-label={`Recorded withholding · ${row.orderReference}`}>
                  <h5>Withholding calculation</h5>
                  <FinanceWithholdingCalculation basisCentavos={row.grossBasisCentavos} rateBasisPoints={row.rateBasisPoints} withheldCentavos={row.withheldCentavos} />
                  <p className="mp-assessed-payment-context">Rounded per payment to the nearest centavo.</p>
                </section>
              </div>
            </article>
          </li>)}</ol> : <p>No retained online payments from this store.</p>}
          {(result.hasMore || page > 1) && <Pagination page={page} total={result.total} hasMore={result.hasMore} onChange={setPage} />}
          {other && <div className="mp-assessed-payment-other"><span>Other stores under this taxpayer ({other.assessedPayments} {other.assessedPayments === 1 ? 'payment' : 'payments'})</span><div className="mp-assessed-payment-other-amounts"><strong>{formatPesoCentavos(other.paymentPrincipalCentavos)} order amount</strong><span>{formatPesoCentavos(other.withheldCentavos)} withholding tax</span></div></div>}
          {showTotal && totals && <div className="mp-assessed-payment-total"><span>All {totals.assessedPayments} retained payments</span><strong>{formatPesoCentavos(totals.paymentPrincipalCentavos)}</strong></div>}
          {totals && <dl className="mp-assessed-payment-tax-total"><div><dt>Total withholding tax</dt><dd>{formatPesoCentavos(totals.withheldCentavos)}</dd></div></dl>}
          <p className="mp-assessed-payment-context">Recorded tax for all retained payments this taxable year, including other stores. Each payment is rounded separately.</p>
          <p className="mp-assessed-payment-context">Fully refunded payments are omitted. Partial refunds reduce the order amounts above. Posted tax assessments and a crossed annual threshold remain unchanged.</p>
          {historyLink}
        </>}
    </div>
  </section>
}
