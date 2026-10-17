/* No credentials or notification contents are persisted by this worker. */
self.addEventListener('push', event => {
  let payload
  try { payload = event.data.json() } catch { return }
  const id = payload?.data?.notification_id
  if (typeof id !== 'string' || !/^[0-9a-f-]{36}$/i.test(id)) return
  event.waitUntil(self.registration.showNotification('MateryalPH', {
    body: 'A new notification is available. Sign in to view it.', tag: id,
    data: { path: '/notifications?notice=' + encodeURIComponent(id) },
  }))
})
self.addEventListener('notificationclick', event => {
  event.notification.close()
  const path = event.notification.data?.path
  if (typeof path !== 'string' || !/^\/notifications\?notice=[0-9a-f-]{36}$/i.test(path)) return
  event.waitUntil(self.clients.openWindow(new URL(path, self.location.origin).href))
})
