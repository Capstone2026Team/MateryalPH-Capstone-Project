import { AuthLayout, LoginLayout, PortalBrand } from '@materyalph/web-ui'
import { FileCheck2, LockKeyhole, ShieldCheck } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function AdminAuthShell({ title, description, children, login = false }: { title: string; description: string; children: ReactNode; login?: boolean }) {
  const brand = <Link className="portal-brand-link inline-flex min-h-11 items-center rounded-control focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" to="/" aria-label="MateryalPH Admin home"><PortalBrand portal="admin" /></Link>
  if (login) return <LoginLayout portal="admin" brand={brand} title={title} description={description}>{children}</LoginLayout>
  return <AuthLayout title={title} description={description} brand={brand} story={
    <section className="admin-story" aria-label="Admin portal safeguards">{brand}<div><h2>Careful decisions.<br />Lasting trust.</h2><p>Review marketplace evidence, enforce approved workflows, and keep high-impact decisions traceable.</p><ul><li><ShieldCheck aria-hidden="true" /><span><strong>Deny-by-default access</strong> Role and assignment checks remain server-side.</span></li><li><FileCheck2 aria-hidden="true" /><span><strong>Reasoned review</strong> Decisions preserve evidence, actor, state, and reason.</span></li><li><LockKeyhole aria-hidden="true" /><span><strong>Immutable audit trail</strong> Sensitive actions are correlated and append-only.</span></li></ul></div><small>Private operations surface · Authorized staff only</small></section>
  }>{children}</AuthLayout>
}
