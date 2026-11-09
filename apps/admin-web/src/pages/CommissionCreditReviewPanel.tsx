import { useState } from 'react'
import { Button, FinanceReviewValues, SidePanel, StatusMessage } from '@materyalph/web-ui'
import { approveFeeCredit, listReviewItems, type FinanceReviewItem } from '../lib/finance-api'
import { record } from '../lib/admin-format'
import { usePaged } from '../lib/operations-hooks'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { Paged } from '../components/OperationsKit'

/** Existing commission approval, scoped to commission credits rather than the removed tax workspace. */
export function CommissionCreditReviewPanel({ onClose, onChanged }: { onClose: () => void; onChanged: () => void }) {
  const credits = usePaged(page => listReviewItems(page, 'OPEN', 'FEE_CREDIT_PROPOSAL'), [])
  return <SidePanel open title="Commission credit review" description="A different finance reviewer must approve each proposed credit." onClose={onClose}>
    <Paged embedded state={credits} empty="No commission credits need review.">{items => <ul className="grid gap-6">{items.map(item => <CreditReview key={item.id} item={item} onSaved={() => { credits.reload(); onChanged() }} />)}</ul>}</Paged>
  </SidePanel>
}
function CreditReview({ item, onSaved }: { item: FinanceReviewItem; onSaved: () => void }) {
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  async function approve() {
    if (busy) return
    setBusy(true); setError('')
    try { await approveFeeCredit(item.id); onSaved() } catch (cause) { setError(await readableVerificationError(cause)) } finally { setBusy(false) }
  }
  return <li className="grid gap-4 border-b border-border-default pb-6">
    <h3 className="text-base font-semibold">{String(record(item.vendor).name ?? 'Vendor')}</h3>
    <p className="text-sm text-text-secondary">{item.summary}</p>
    <FinanceReviewValues expected={record(item.expected)} reported={record(item.reported)} />
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <Button className="w-fit" disabled={busy} onClick={() => void approve()}>{busy ? 'Approving…' : 'Approve credit (different reviewer)'}</Button>
  </li>
}
