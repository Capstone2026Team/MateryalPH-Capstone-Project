import { useRef, useState } from 'react'
import { Button, CommissionEmailBadge, CommissionStatementBadge, DenseLedgerTable, DocumentExportButton, FilterTabs, FinanceBreakdownPanel, FinanceDetails, Pagination, SidePanel, StatusMessage, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import { getCommissionStatement, resendCommissionEmail } from '../lib/finance-api'
import { record, records } from '../lib/admin-format'
import { useLoad } from '../lib/operations-hooks'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

export function CommissionStatementDrawer({ id, onClose, onChanged }: { id: string; onClose: () => void; onChanged: () => void }) {
  const [tab, setTab] = useState('summary')
  const [page, setPage] = useState(1)
  const [paymentsPage, setPaymentsPage] = useState(1)
  const detail = useLoad(() => getCommissionStatement(id, page, paymentsPage), [id, page, paymentsPage])
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const intent = useRef<{ id: string; key: string } | null>(null)
  const data = detail.data
  const emails = records(data?.emails)
  async function resend(eventId: string) {
    setBusy(true); setError(null); setMessage(null)
    if (intent.current?.id !== eventId) intent.current = { id: eventId, key: crypto.randomUUID() }
    try { await resendCommissionEmail(eventId, intent.current.key); intent.current = null; setMessage('Statement email queued. Delivery status updates after the worker sends it.'); detail.retry(); onChanged() }
    catch (cause) { setError(await readableVerificationError(cause)) }
    finally { setBusy(false) }
  }
  return <SidePanel open title="Commission statement" description={data ? `${String(data.reference)} · ${String(data.vendor_name)}` : 'Loading statement details…'} onClose={onClose}>
    <div className="mp-commission-statement-detail grid gap-4">
      <FilterTabs label="Statement detail" appearance="tabs" chips={[{ value: 'summary', label: 'Summary' }, { value: 'charges', label: 'Charges and credits' }, { value: 'payments', label: 'Payments' }, { value: 'activity', label: 'Activity and emails' }]} value={tab} onChange={setTab} />
      {error && <StatusMessage tone="error">{error}</StatusMessage>}{message && <StatusMessage tone="success">{message}</StatusMessage>}
      {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !data ? <LoadingState /> : <>
        <div className="flex flex-wrap items-center justify-between gap-2"><CommissionStatementBadge state={String(data.state)} overdue={Boolean(data.overdue)} />{data.can_export === true && <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="admin" types={['FEE_STATEMENT']} resourceId={id} title={String(data.reference)} />}</div>
        {tab === 'summary' && <>
          <FinanceDetails items={[[ 'Vendor', String(data.vendor_name) ], [ 'Statement', String(data.reference) ], [ 'Period', `${String(data.period_start)} – ${String(data.period_end)}` ], [ 'Due date', data.state === 'DRAFT' ? 'Set on issuance' : `${String(data.due_on)} · end of day, Asia/Manila` ]]} />
          <FinanceBreakdownPanel title="Commission statement" caption="Statement calculation" rows={[
            { key: 'before', label: 'Commission before credits', amount: formatPesoCentavos(Number(data.charges_centavos)) },
            { key: 'credits', label: 'Credits applied', amount: formatPesoCentavos(-Number(data.credits_centavos)) },
            { key: 'after', label: 'Commission after credits', amount: formatPesoCentavos(Math.max(0, Number(data.charges_centavos) - Number(data.credits_centavos))), total: true },
            { key: 'paid', label: 'Paid before refunds', amount: formatPesoCentavos(Number(data.paid_centavos)) },
            { key: 'due', label: 'Amount due', amount: Number(data.outstanding_centavos) === 0 ? 'Paid in full' : formatPesoCentavos(Number(data.outstanding_centavos)), total: true },
          ]} />
          <div className="grid gap-2 border-t border-border-default pt-3"><h3 className="text-sm font-semibold">Email activity</h3>{emails.length === 0 ? <p className="text-sm text-text-secondary">No tracked issue email. Earlier deliveries remain in notification history.</p> : emails.map(email => <div key={String(email.id)} className="flex flex-wrap items-center gap-2"><CommissionEmailBadge state={String(email.state)} /><span className="text-xs text-text-secondary">{email.sent_at ? formatManilaDateTime(String(email.sent_at)) : 'Waiting for delivery'}</span></div>)}</div>
        </>}
        {tab === 'charges' && <>
          <h3 className="text-sm font-semibold">Saved rates applied</h3>
          <DenseLedgerTable caption="Statement rates" compact rows={records(data.rate_breakdown)} rowKey={row => String(row.rate_label)} columns={[
            { key: 'rate', header: 'Rate', cell: row => String(row.rate_label) },
            { key: 'basis', header: 'Eligible materials', className: 'text-right tabular-nums', headerClassName: 'text-right', cell: row => formatPesoCentavos(Number(row.basis_centavos)) },
            { key: 'commission', header: 'Commission', className: 'text-right tabular-nums', headerClassName: 'text-right', cell: row => formatPesoCentavos(Number(row.commission_centavos)) },
          ]} />
          <p className="text-xs text-text-secondary">Each line uses its saved order rate. Eligible materials are after discounts and exclude materials VAT.</p>
          <DenseLedgerTable caption="Statement charges and credits" compact rows={records(record(data.lines).items)} rowKey={row => String(row.id)} columns={[
            { key: 'description', header: 'Charge / credit', cell: row => <div className="grid gap-1"><span>{String(row.description)}</span><span className="text-xs text-text-secondary">{String(row.order_reference ?? '')}</span></div> },
            { key: 'amount', header: 'Amount', className: 'text-right tabular-nums', headerClassName: 'text-right', cell: row => formatPesoCentavos((['CREDIT', 'CREDIT_TRANSFER'].includes(String(row.type)) ? -1 : 1) * Number(row.amount_centavos)) },
          ]} />
          <Pagination page={page} hasMore={record(record(data.lines).meta).has_more === true} onChange={setPage} />
        </>}
        {tab === 'payments' && <>
          <DenseLedgerTable caption="Statement payments" compact rows={records(record(data.payments).items)} rowKey={row => String(row.id)} emptyText="No payment attempts for this bill." columns={[
            { key: 'state', header: 'Status / channel', cell: row => <div className="grid gap-1"><strong>{String(row.status ?? row.state)}</strong><span className="text-xs text-text-secondary">{String(row.channel_name ?? row.channel_code ?? 'Channel pending')} · TEST</span></div> },
            { key: 'paid', header: 'Paid date', cell: row => formatManilaDateTime(row.paid_at as string | null) },
            { key: 'total', header: 'Gross', className: 'text-right tabular-nums', cell: row => formatPesoCentavos(Number(row.total_centavos)) },
          ]} />
          <Pagination page={paymentsPage} hasMore={record(record(data.payments).meta).has_more === true} onChange={setPaymentsPage} />
        </>}
        {tab === 'activity' && <>
          <FinanceDetails items={[[ 'Issued', formatManilaDateTime(data.issued_at as string | null) ], [ 'Origin', data.issuance_origin === 'SYSTEM' ? 'Automatic monthly billing' : 'Authorized manual recovery' ], [ 'Version', String(data.lock_version) ]]} />
          <h3 className="text-sm font-semibold">Activity and emails</h3>
          {emails.length === 0 && <p className="text-sm text-text-secondary">No tracked email for this statement.</p>}
          {emails.map(email => <div key={String(email.id)} className="grid gap-3 rounded-control border border-border-default p-4"><CommissionEmailBadge state={String(email.state)} /><p className="text-sm">{String(email.type).replaceAll('_', ' ').toLowerCase()} · {Number(email.attempts)} delivery attempts</p><p className="text-xs text-text-secondary">Created {formatManilaDateTime(String(email.created_at))}{email.sent_at ? ` · Sent ${formatManilaDateTime(String(email.sent_at))}` : ''}</p>{Boolean(email.last_error) && <p className="text-xs">{String(email.last_error).replaceAll('_', ' ').toLowerCase()}</p>}{data.can_resend === true && ['SENT', 'FAILED'].includes(String(email.state)) && <Button variant="secondary" disabled={busy} onClick={() => void resend(String(email.id))}>{busy ? 'Queueing…' : 'Resend email'}</Button>}</div>)}
        </>}
        <p className="border-t border-border-default pt-3 text-xs text-text-secondary">TEST/DEMO billing. No automatic Vendor debit, real funds or BIR filing.</p>
      </>}
    </div>
  </SidePanel>
}
