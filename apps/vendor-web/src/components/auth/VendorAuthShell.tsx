import { BackNavigation, AuthLayout, LoginLayout, PortalBrand } from '@materyalph/web-ui'
import { FileCheck2, PackageCheck, ReceiptText, Star } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function VendorAuthShell({ title, description, children, scrollPanel = false, login = false, storyDescription = 'Create your Owner account, protect your access, and prepare your store for verification.' }: { title: string; description: string; children: ReactNode; scrollPanel?: boolean; login?: boolean; storyDescription?: string }) {
  const brand = <Link className="portal-brand-link inline-flex min-h-11 items-center rounded-control focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" to="/" aria-label="MateryalPH Vendor home"><PortalBrand portal="vendor" /></Link>
  if (login) return <LoginLayout
    portal="vendor"
    brand={brand}
    navigation={<nav aria-label="Vendor portal navigation"><BackNavigation><Link to="/" aria-label="Return to Vendor home" title="Return to Vendor home">Return</Link></BackNavigation></nav>}
    title={title}
    description={description}
  >{children}</LoginLayout>
  return <AuthLayout title={title} description={description} scrollPanel={scrollPanel} brand={brand} story={
    <section className="auth-story" aria-label="Vendor portal benefits">
      {brand}
      <div><h2>Your next chapter<br />starts here.</h2><p>{storyDescription}</p><ul><li><PackageCheck aria-hidden="true" /><span><strong>Structured demand</strong> Item orders and direct Work Package inquiries</span></li><li><ReceiptText aria-hidden="true" /><span><strong>Traceable payments</strong> Separate payment, refund, and fee records</span></li><li><Star aria-hidden="true" /><span><strong>Evidence-based reputation</strong> Versioned performance signals</span></li></ul></div>
      <small><FileCheck2 aria-hidden="true" /> Vendor activation is reviewed before publication.</small>
    </section>
  }>{children}</AuthLayout>
}
