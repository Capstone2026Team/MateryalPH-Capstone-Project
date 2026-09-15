import { AccountsApi, ResponseError, VendorOnboardingApi, type AccountProfile, type VendorReadiness } from '@materyalph/api-client-ts'
import { useCallback, useEffect, useMemo, useState } from 'react'
import { Button } from './button'
import { StatusMessage } from './status-message'
import { createWebApiConfiguration } from './web-api-session'

type Props = { basePath: string; loginPath: string; accountPath: string; onboardingPath: string }
const label = (value: string) => value.replaceAll('_', ' ').toLowerCase().replace(/^./, character => character.toUpperCase())

export function VendorDashboardWorkspace({ basePath, loginPath, accountPath, onboardingPath }: Props) {
  const [profile, setProfile] = useState<AccountProfile | null>(null)
  const [readiness, setReadiness] = useState<VendorReadiness | null>(null)
  const [busy, setBusy] = useState(true)
  const [error, setError] = useState('')
  const configuration = useMemo(() => createWebApiConfiguration(basePath, { refreshSession: true }), [basePath])
  const load = useCallback(async () => {
    setBusy(true); setError('')
    try {
      const account = (await new AccountsApi(configuration).getAccountProfile({ accountPortal: 'vendors' })).data
      setProfile(account)
      if (account.organizationId) setReadiness((await new VendorOnboardingApi(configuration).getVendorReadiness({ organization: account.organizationId })).data)
    } catch (failure) {
      if (failure instanceof ResponseError && failure.response.status === 401) setError('Your session expired. Sign in again.')
      else if (failure instanceof ResponseError && failure.response.status === 429) setError('Dashboard requests are temporarily rate limited. Wait a moment and retry.')
      else setError('The Dashboard could not be loaded. Check your connection and retry.')
    } finally { setBusy(false) }
  }, [configuration])
  useEffect(() => { void load() }, [load])
  const active = readiness?.activationStatus === 'ACTIVE'
  const discoverable = readiness?.discoverabilityStatus === 'DISCOVERABLE'
  const completion = readiness ? Math.round(readiness.checklist.filter(item => ['APPROVED', 'COMPLETED', 'NOT_APPLICABLE'].includes(item.status)).length / Math.max(readiness.checklist.length, 1) * 100) : 0

  return <main className="min-h-screen bg-surface-canvas text-text-strong"><header className="border-b border-border-default bg-surface-primary px-5 py-5"><div className="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-4"><div><p className="text-sm font-semibold text-action-primary">MateryalPH Vendor Portal</p><h1 className="text-2xl font-bold">{readiness?.storeName || 'Vendor Dashboard'}</h1></div><div className="flex gap-4"><a className="py-3 font-semibold text-action-primary" href={accountPath}>Account &amp; security</a>{!profile && !busy && <a className="py-3 font-semibold text-action-primary" href={loginPath}>Sign in</a>}</div></div></header><div className="mx-auto grid max-w-7xl gap-6 px-5 py-6 lg:grid-cols-[220px_minmax(0,1fr)]"><nav aria-label="Vendor workspace" className="space-y-2"><a className="block min-h-11 rounded-control bg-action-primary px-4 py-3 font-semibold text-white" href="/dashboard" aria-current="page">Dashboard</a><a className="block min-h-11 rounded-control border border-border-default bg-surface-primary px-4 py-3 font-semibold" href={onboardingPath}>Vendor Onboarding</a>{['Products', 'Orders', 'Procurement', 'Fulfillment', 'Payments'].map(item => active ? <a key={item} className="block min-h-11 rounded-control border border-border-default bg-surface-primary px-4 py-3 font-semibold" href={`/${item.toLowerCase()}`}>{item}</a> : <span key={item} aria-disabled="true" className="block min-h-11 cursor-not-allowed rounded-control border border-border-default bg-surface-secondary px-4 py-3 text-text-muted">{item} · after activation</span>)}</nav><section className="space-y-6" aria-busy={busy}>{busy && <p role="status">Loading Dashboard…</p>}{error && <StatusMessage tone="error">{error}</StatusMessage>}{readiness && !active && <StatusMessage tone="info">Your Vendor Portal account is active, but Store Activation is pending. The limited Dashboard remains available while onboarding progress is saved.</StatusMessage>}{readiness && <><div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4"><Card title="Onboarding progress" value={`${completion}%`} detail={label(readiness.onboardingStatus)} /><Card title="Store Verification" value={label(readiness.storeVerificationStatus)} detail="Manual Admin review" /><Card title="Store Setup" value={label(readiness.storeSetupStatus)} detail="Independent progress" /><Card title="Store Activation" value={label(readiness.activationStatus)} detail={discoverable ? 'Marketplace discoverable' : 'Discoverability separate'} /></div><div className="rounded-card border border-border-default bg-surface-primary p-6"><h2 className="text-xl font-bold">{active ? 'Store management' : 'Complete Vendor Onboarding'}</h2><p className="mt-2">{active ? 'Product publication, inventory and product compliance determine Marketplace Discoverability.' : 'Store Verification and Store Setup can progress independently after verification submission. Team Accounts are optional.'}</p><a className="mt-4 inline-flex min-h-12 items-center rounded-control bg-action-primary px-5 font-semibold text-white" href={onboardingPath}>{active ? 'Review onboarding record' : 'Continue onboarding'}</a></div>{active && !discoverable && <StatusMessage tone="info">An active Store with zero eligible active listings is not shown in marketplace discovery. Regulated products still require approved PS Mark or ICC Sticker evidence.</StatusMessage>}</>}{!busy && <Button variant="secondary" onClick={() => void load()}>Refresh Dashboard</Button>}</section></div></main>
}

function Card({ title, value, detail }: { title: string; value: string; detail: string }) { return <article className="rounded-card border border-border-default bg-surface-primary p-5"><p className="text-sm font-semibold text-action-primary">{title}</p><p className="mt-2 text-xl font-bold">{value}</p><p className="mt-1 text-sm text-text-muted">{detail}</p></article> }
