import { initializeApp, getApps, type FirebaseOptions } from '@firebase/app'
import { getMessaging, getToken, isSupported, deleteToken } from '@firebase/messaging'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'

export async function enableWebPush(basePath: string, audience: 'vendor' | 'admin', options: FirebaseOptions, vapidKey: string): Promise<void> {
  const api = new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
  const settings = await api.getNotificationPreferences({ audience })
  if (settings.meta.web_push_approved !== true || !await isSupported()) throw new Error('Web push is unavailable')
  if (await Notification.requestPermission() !== 'granted') throw new Error('Notification permission was not granted')
  const app = getApps().find(value => value.name === audience) ?? initializeApp(options, audience)
  const registration = await navigator.serviceWorker.register('/notification-worker.js')
  const messaging = getMessaging(app)
  const token = await getToken(messaging, { vapidKey, serviceWorkerRegistration: registration })
  try { await api.registerNotificationDevice({ audience, notificationDeviceInput: { platform: 'WEB', token } }) }
  catch (error) { await deleteToken(messaging); throw error }
}
