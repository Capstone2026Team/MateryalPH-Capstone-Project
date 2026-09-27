import { PublishedAgreementReader } from '@materyalph/web-ui'
import { Link, useParams } from 'react-router-dom'
import { BrandHeader } from '../components/BrandHeader'
import { SiteFooter } from '../components/SiteFooter'

const documents: Record<string, { title: string; code: string }> = {
  'terms-of-service': { title: 'Terms of Service', code: 'TERMS_OF_SERVICE' },
  'privacy-notice': { title: 'Privacy Notice', code: 'PRIVACY_NOTICE' },
}

export function VendorLegalPage() {
  const { document = '' } = useParams()
  const selected = Object.hasOwn(documents, document) ? documents[document] : undefined
  return <>
    <BrandHeader />
    <main id="main-content" className="mx-auto w-full max-w-3xl px-4 py-12 sm:px-8 sm:py-16">
      <h1 className="mb-8 text-3xl font-semibold tracking-tight sm:text-4xl">{selected?.title ?? 'Document not found'}</h1>
      {selected ? <PublishedAgreementReader key={selected.code} basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} code={selected.code} /> : <p>The requested legal document is not available.</p>}
      <p className="mt-8 border-t border-border-default pt-6 text-sm text-text-secondary">If you opened this page from sign-up, close this tab to return to your form.</p>
      <Link className="button button--secondary mt-4" to="/register">Go to registration</Link>
    </main>
    <SiteFooter />
  </>
}
