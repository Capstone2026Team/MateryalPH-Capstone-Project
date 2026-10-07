import { NotificationsWorkspace, enableWebPush } from '@materyalph/web-ui'
import { useNavigate } from 'react-router-dom'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { VendorShell } from './PhaseThreeVendorPages'

export function VendorNotificationsPage() {
  const navigate = useNavigate()
  const { snapshot } = useOnboardingSnapshot()
  return <VendorShell activeHref="/notifications" accountLabel="Vendor" navigationData={snapshot}><NotificationsWorkspace basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" navigate={navigate} {...(import.meta.env.VITE_FIREBASE_PUSH_ENABLED === 'true' ? { enablePush: () => enableWebPush(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', 'vendor', { apiKey: import.meta.env.VITE_FIREBASE_API_KEY, appId: import.meta.env.VITE_FIREBASE_APP_ID, projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID, messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID }, import.meta.env.VITE_FIREBASE_VAPID_KEY) } : {})} /></VendorShell>
}

