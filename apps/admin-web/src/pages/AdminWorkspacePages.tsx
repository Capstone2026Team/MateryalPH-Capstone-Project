import { AccountWorkspace, BackNavigation } from '@materyalph/web-ui'
import { QRCodeSVG } from 'qrcode.react'
import { Link } from 'react-router-dom'
import { AdminShell } from './PhaseThreeAdminPages'

export function AdminAccountWorkspacePage() {
  return <AdminShell activeHref="/workspace"><AccountWorkspace embedded portal="admin" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loginPath="/login" renderQr={uri => <QRCodeSVG value={uri} title="Authenticator setup QR code" />} /></AdminShell>
}

export function AdminNotFoundPage() {
  return <AdminShell activeHref=""><h1 className="text-2xl font-semibold">Page not found</h1><BackNavigation><Link to="/vendor-verification">Return to verification queue</Link></BackNavigation></AdminShell>
}
