import { useRef, useState } from 'react'
import { CheckCircle2, CreditCard } from 'lucide-react'
import { Button } from './button'
import { StatusBadge } from './portal-shell'

export interface XenditConnectionProps {
  status: string
  canConfigure: boolean
  lastError?: string
  providerStatus?: string
  accountSuffix?: string
  connect: () => Promise<unknown>
  reconcile?: () => Promise<unknown>
  describeError: (error: unknown) => Promise<string>
}

export function XenditConnection({ status, canConfigure, lastError, providerStatus, accountSuffix, connect, reconcile, describeError }: XenditConnectionProps) {
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const running = useRef(false)
  const connected = status === 'CONNECTED_TEST'
  const pending = status === 'PENDING'
  const suspended = pending && providerStatus === 'SUSPENDED'
  const uncertain = !connected && !pending && (status === 'CONNECTING' || lastError === 'PROVIDER_ONBOARDING_UNCERTAIN')

  async function start(action: () => Promise<unknown>) {
    if (running.current) return
    running.current = true
    setBusy(true)
    setMessage(null)
    try { await action() }
    catch (error) { setMessage(await describeError(error)) }
    finally { running.current = false; setBusy(false) }
  }

  return <section aria-label="Xendit connection" className="grid min-w-0 gap-6">
    <p className="max-w-3xl text-sm leading-6 text-text-secondary">Xendit is MateryalPH’s payment service provider. Connect your store to a dedicated Xendit TEST sub-account for marketplace payment testing.</p>
    <div className="flex flex-wrap items-center justify-between gap-4 border-y border-border-default py-5">
      <div className="flex min-w-0 items-center gap-3">
        {connected ? <CheckCircle2 className="shrink-0 text-status-success" size={22} aria-hidden="true" /> : <CreditCard className="shrink-0 text-action-primary" size={22} aria-hidden="true" />}
        <StatusBadge label={connected ? 'Xendit — Connected' : suspended ? 'Account suspended' : pending ? 'Account pending' : uncertain ? 'Confirmation needed' : 'Not Connected'} tone={connected ? 'success' : suspended ? 'error' : pending || uncertain ? 'warning' : 'neutral'} />
      </div>
      {!connected && !uncertain && canConfigure && <Button type="button" disabled={busy || (pending && !reconcile)} onClick={() => void start(pending ? reconcile ?? connect : connect)}>{busy ? 'Checking Xendit...' : pending ? 'Check account status' : status === 'CONNECTION_FAILED' ? 'Try again' : 'Connect Xendit'}</Button>}
    </div>
    <div aria-live="polite">
      {connected ? <p className="text-sm font-semibold leading-6">The xenPlatform TEST sub-account is connected. You can now proceed to the next step.</p> : suspended ? <p className="max-w-3xl text-sm leading-6 text-text-secondary">Xendit suspended this TEST account. Store Activation remains blocked.</p> : pending ? <p className="max-w-3xl text-sm leading-6 text-text-secondary">Xendit created the TEST account. Check its status here; Store Activation waits until Xendit confirms it is LIVE. TEST accounts do not require a separate Vendor login.</p> : uncertain ? <p className="max-w-3xl text-sm leading-6 text-text-secondary">MateryalPH did not receive a conclusive result from Xendit. Another creation is blocked until the first attempt is checked for an existing account.</p> : <p className="max-w-3xl text-sm leading-6 text-text-secondary">Select Connect Xendit to create a dedicated TEST account for simulated payments. Xendit will not send a Vendor registration invitation in TEST.</p>}
      <p className="mt-3 text-sm text-text-secondary">Environment: <strong>TEST</strong>{(connected || pending) && accountSuffix ? ` · Account: ••••••${accountSuffix}` : ''}</p>
      {!connected && !canConfigure && <p className="mt-3 text-sm text-text-secondary">Only the Vendor Owner with the required authority can connect Xendit.</p>}
    </div>
    {!connected && !busy && (message || (lastError && lastError !== 'PROVIDER_ONBOARDING_UNSUPPORTED')) && <p role="alert" className="text-sm leading-6 text-status-error">{message ?? (lastError === 'PROVIDER_ACCOUNT_ACCESS_REQUIRED' ? 'Xendit denied TEST account creation. Check the TEST master key’s Account Write permission and xenPlatform access.' : lastError === 'PROVIDER_ACCOUNT_CONFLICT' ? 'Xendit reported an account conflict. Check whether the verified Store Email or Owner email is already used by Xendit before retrying.' : uncertain ? 'The previous Xendit request needs investigation before another TEST account can be created.' : 'MateryalPH could not connect your store to Xendit. Please try again.')}</p>}
    <p className="max-w-3xl text-xs leading-5 text-text-secondary"><strong>DEMO — No real funds or BIR filing.</strong> This connection is for TEST payment functionality only. It does not activate live payments or establish production KYC, BIR registration, statutory withholding compliance, or government approval.</p>
  </section>
}
