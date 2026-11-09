import { useCallback } from 'react'
import { useNavigate } from 'react-router-dom'
import { AccountsApi, type VendorAccountDeletionBlockers, VendorAccountDeletionRequestConfirmationEnum } from '@materyalph/api-client-ts'
import { AccountDeletionSection, clearWebSessionTransport, createWebApiConfiguration, useAccountVerification, type AccountDeletionReview } from '@materyalph/web-ui'
import { readableApiError } from '../lib/auth-api'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new AccountsApi(createWebApiConfiguration(basePath))
const blockers: readonly { key: keyof VendorAccountDeletionBlockers; label: string; description: string; href: string }[] = [
  { key: 'activeOrders', label: 'Active orders', description: 'Complete or close every open order.', href: '/orders' },
  { key: 'pendingPayments', label: 'Pending payments', description: 'Wait for pending payments to finish and resolve uncertain payment results.', href: '/finance' },
  { key: 'unresolvedDisputes', label: 'Unresolved disputes', description: 'Resolve open cases, decisions and appeals.', href: '/disputes' },
  { key: 'pendingRefunds', label: 'Unresolved refunds', description: 'Complete pending refunds and resolve failed refund attempts.', href: '/finance' },
  { key: 'uncollectedPayments', label: 'Uncollected physical payments', description: 'Record or resolve outstanding Cash on Delivery and In-Store payments.', href: '/orders' },
  { key: 'outstandingStatements', label: 'Unpaid commission statements', description: 'Resolve draft statements and settle issued or partially paid statements.', href: '/finance' },
  { key: 'unbilledCommissions', label: 'Unbilled earned commission', description: 'Wait for earned commission to be billed, then settle the statement. Contact support if you need help.', href: '/finance' },
  { key: 'financeReviews', label: 'Open financial reviews', description: 'Resolve payment, refund or reconciliation reviews with support.', href: '/support/requests' },
]

async function loadReview(): Promise<AccountDeletionReview> {
  const { data } = await api().getVendorAccountDeletionPreview()
  if (!data.blockers || data.confirmationPhrase !== 'DELETE' || !Array.isArray(data.retainedRecords)
    || blockers.some(item => !Number.isSafeInteger(data.blockers[item.key]) || data.blockers[item.key] < 0)
    || data.canDelete !== blockers.every(item => data.blockers[item.key] === 0)) {
    throw new Error('The eligibility check could not be verified. Check again before continuing.')
  }
  return { ...data, blockers: blockers.map(item => ({ ...item, count: data.blockers[item.key] })) }
}

export function VendorAccountDeletion() {
  const navigate = useNavigate()
  const verification = useAccountVerification({ api, portal: 'vendors', explainError: readableApiError })
  const remove = useCallback(async () => {
    await api().deleteVendorAccount({ idempotencyKey: crypto.randomUUID(), vendorAccountDeletionRequest: { confirmation: VendorAccountDeletionRequestConfirmationEnum.Delete } })
    clearWebSessionTransport(basePath)
    navigate('/login?deleted=success', { replace: true })
  }, [navigate])
  return <><AccountDeletionSection loadReview={loadReview} deleteAccount={remove} verify={() => verification.verify('Verify account deletion')} explainError={readableApiError} />{verification.dialog}</>
}
