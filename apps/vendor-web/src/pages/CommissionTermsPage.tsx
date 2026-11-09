import { DemoLabel, PageHeader, PublishedAgreementText, RequestErrorState, AsyncLoading, StatusMessage, formatManilaDateTime, useCommissionPolicy } from '@materyalph/web-ui'
import { Link, useSearchParams } from 'react-router-dom'
import { BrandHeader } from '../components/BrandHeader'
import { SiteFooter } from '../components/SiteFooter'

export function CommissionTermsPage() {
  const [params] = useSearchParams()
  const policy = useCommissionPolicy(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', params.get('policy') ?? undefined)
  const current = policy.data?.current
  const selected = policy.data?.selected ?? current
  const next = policy.data?.next
  return <><BrandHeader /><main id="main-content" className="mx-auto grid w-full max-w-4xl gap-6 px-4 py-10 sm:px-8">
    <PageHeader eyebrow="Finance" title="Commission Terms" description="Versioned Vendor-paid commission, billing and credits." /><DemoLabel>TEST/DEMO — No automatic debit, real funds or BIR filing</DemoLabel>
    {policy.error ? <RequestErrorState message={policy.error} onRetry={policy.reload} /> : !policy.data ? <AsyncLoading label="Loading Commission Terms…" /> : <>
      {next && <StatusMessage tone="info">Upcoming change effective {formatManilaDateTime(next.effectiveFrom)}: {next.rateLabel}. Existing transactions keep their saved rate. <Link className="underline" to={`?policy=${next.id}`}>Read upcoming terms</Link></StatusMessage>}
      {selected && <article className="mp-card mp-card-padded grid gap-4" aria-label="Published Commission Terms">
        <p className="text-sm font-semibold">Policy v{selected.version} · Terms v{selected.termsVersion} · {selected.rateLabel} · {selected.status.toLowerCase()}</p>
        <p className="text-sm text-text-secondary">Effective {formatManilaDateTime(selected.effectiveFrom)}</p>
        <PublishedAgreementText content={selected.termsContent ?? 'The published terms are unavailable.'} />
        {selected.id !== current?.id && <Link className="text-action-primary underline" to="/commission-terms">View current terms</Link>}
      </article>}
      {!selected && <p>No published commission policy is available.</p>}
      <p className="text-sm text-text-secondary">Owner acceptance remains in Finance or Store Verification.</p>
      <Link className="button button--secondary" to="/finance/commissions">Open Vendor Finance</Link>
    </>}
  </main><SiteFooter /></>
}
