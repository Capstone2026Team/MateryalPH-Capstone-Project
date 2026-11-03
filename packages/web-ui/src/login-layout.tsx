import type { ReactNode } from 'react'
import { FileCheck2, LockKeyhole, PackageCheck, ShieldCheck } from 'lucide-react'
import './login-layout.css'

/** Presentation only; each portal retains ownership of its authentication flow. */
export function LoginLayout({ portal, brand, navigation, title, description, children }: {
  portal: 'admin' | 'vendor'
  brand: ReactNode
  navigation?: ReactNode
  title: string
  description: string
  children: ReactNode
}) {
  const admin = portal === 'admin'
  return <main className={`login-layout login-layout--${portal}${navigation ? ' login-layout--with-navigation' : ''}`}>
    {navigation ? <header className="login-layout__navigation">{navigation}</header> : null}
    <div className="login-layout__frame">
      <div className="login-layout__introduction">
      <div className="login-layout__introduction-brand">{brand}</div>
      <section className="login-layout__story" aria-label={admin ? 'Admin portal safeguards' : 'Vendor portal benefits'}>
        <span className="login-layout__eyebrow">{admin ? 'Marketplace administration' : 'Your vendor workspace'}</span>
        <h2>{admin ? <>Careful decisions.<br />Lasting trust.</> : <>Your store.<br />Your next chapter.</>}</h2>
        <p>{admin ? 'Review marketplace evidence and keep every decision accountable.' : 'Access your store, manage your team, and prepare for what comes next.'}</p>
        <ul>
          <li>{admin ? <ShieldCheck aria-hidden="true" /> : <PackageCheck aria-hidden="true" />}<div><strong>{admin ? 'Authorized access' : 'One connected workspace'}</strong><span>{admin ? 'Role-based access for invited Admin accounts.' : 'Orders, inquiries, and store operations in one place.'}</span></div></li>
          <li><FileCheck2 aria-hidden="true" /><div><strong>{admin ? 'Traceable decisions' : 'A trusted storefront'}</strong><span>{admin ? 'Evidence and audit history support every review.' : 'Store activation is reviewed before publication.'}</span></div></li>
        </ul>
        <p className="login-layout__note"><LockKeyhole aria-hidden="true" />{admin ? 'Private portal · Authorized staff only' : 'For Vendor Owners and their teams'}</p>
      </section>
      </div>
      <section className="login-layout__card" aria-label={title}>
        <header className="login-layout__card-heading">
          <div className="login-layout__heading-copy"><h1>{title}</h1><p className="login-layout__description">{description}</p></div>
        </header>
        {children}
      </section>
    </div>
  </main>
}
