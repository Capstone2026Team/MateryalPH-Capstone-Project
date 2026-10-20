import type { ReactNode } from 'react'
import './auth-layout.css'

/** Shared presentation for account verification, recovery and invitation forms. */
export function AuthLayout({ story, brand, title, description, notice, children, scrollPanel = false }: {
  story: ReactNode
  brand: ReactNode
  title: string
  description: string
  notice?: ReactNode
  children: ReactNode
  scrollPanel?: boolean
}) {
  return <main className={`auth-layout${scrollPanel ? ' auth-layout--scroll-panel' : ''}`}>
    <div className="auth-layout__story">{story}</div>
    <section className="auth-layout__panel" aria-label={title} tabIndex={scrollPanel ? 0 : undefined}>
      <div className="auth-layout__content">
        <div className="auth-layout__mobile-brand">{brand}</div>
        <div className="auth-layout__card">
          <header className="auth-layout__heading"><h1>{title}</h1><p>{description}</p></header>
          <div className="auth-layout__body">
            {notice && <div className="auth-layout__notice">{notice}</div>}
            {children}
          </div>
        </div>
      </div>
    </section>
  </main>
}
