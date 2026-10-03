import { MessagingApi, type ChatDraftContent } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
export { readableOnboardingError as readableChatError } from './onboarding-api'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new MessagingApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const scope = { messagingPortal: 'vendor' as const }
export const chatApi = {
  list: async (page = 1) => (await api().listConversations({ ...scope, page })).data,
  get: async (conversationId: string, before?: string, page = 1, legacyPage = 1) => (await api().getConversation({ ...scope, conversationId, ...(before ? { before } : {}), page, legacyPage })).data,
  send: (conversationId: string, body: string, clientMessageId: string, productId?: string) => api().sendChatMessage({ ...scope, conversationId, chatSend: { ...(body ? { body } : {}), clientMessageId, ...(productId ? { productId } : {}) } }),
  products: async (conversationId: string, q = '', page = 1) => (await api().listChatProducts({ ...scope, conversationId, q, page })).data,
  typing: (conversationId: string, typing: boolean) => api().sendChatTyping({ ...scope, conversationId, chatTyping: { typing } }),
  read: (conversationId: string, throughMessageId: string) => api().readChatMessages({ ...scope, conversationId, chatRead: { throughMessageId } }),
  handlers: (conversationId: string, page = 1) => api().listChatHandlers({ ...scope, conversationId, page }),
  transfer: (conversationId: string, handlerUserId: number, lockVersion: number, reason: string) => api().transferChatHandler({ ...scope, conversationId, chatTransfer: { handlerUserId, lockVersion, reason } }),
  draft: async (conversationId: string, lockVersion: number, draft: ChatDraftContent) => (await api().saveChatQuotationDraft({ ...scope, conversationId, chatDraftSave: { lockVersion, draft } })).data,
  publish: (conversationId: string, lockVersion: number, idempotencyKey: string) => api().publishChatQuotation({ ...scope, conversationId, idempotencyKey, chatPublish: { lockVersion } }),
  startQuotation: (conversationId: string, lockVersion: number, idempotencyKey: string) => api().startNextChatQuotation({ ...scope, conversationId, idempotencyKey, chatPublish: { lockVersion } }),
  withdraw: (conversationId: string, versionId: string, idempotencyKey: string) => api().decideChatQuotation({ ...scope, conversationId, idempotencyKey, action: 'withdraw', chatDecision: { versionId } }),
  upload: (conversationId: string, file: Blob, clientMessageId: string) => api().uploadChatAttachment({ ...scope, conversationId, file, clientMessageId }),
  download: (conversationId: string, attachmentId: string) => api().downloadChatAttachment({ ...scope, conversationId, attachmentId }),
}
export async function loadChatAvatar(path: string): Promise<Blob> {
  const match = /^\/conversations\/([0-9a-f-]+)\/avatars\/(\d+)$/i.exec(path)
  if (!match?.[1]) throw new Error('Avatar unavailable')
  return api().getChatAvatar({ ...scope, conversationId: match[1], userId: Number(match[2]) })
}

/** Existing Reverb viewer channels; reconnect reauthorizes and synchronizes missed activity. */
export async function watchConversation(channel: string | null, refresh: () => void, onTyping?: (typing: boolean, at: number) => void, changeEvents: readonly string[] = ['conversation.changed', 'inbox.changed'], onLive?: (live: boolean) => void): Promise<() => void> {
  let closed = false
  let live = false
  let socket: WebSocket | undefined
  let retry: ReturnType<typeof setTimeout> | undefined
  let handshake: ReturnType<typeof setTimeout> | undefined
  let delay = 1000
  // Callers poll quickly while the subscription is not established, so a blocked Reverb port never needs a manual refresh.
  function setLive(value: boolean) { if (live === value || closed) return; live = value; onLive?.(value) }
  function reconnect() {
    clearTimeout(handshake)
    setLive(false)
    if (closed || retry) return
    if (socket) { socket.onclose = null; socket.onerror = null; socket.close() }
    retry = setTimeout(() => { retry = undefined; void connect() }, delay)
    delay = Math.min(delay * 2, 30000)
  }
  async function connect() {
    try {
      const config = (await api().getChatRealtime(scope)).data
      if (closed) return
      const target = channel ?? config.inboxChannel
      if (!config.enabled || !config.key || !config.host || !target) { delay = 30000; reconnect(); return }
      const current = new WebSocket(`${config.scheme === 'https' ? 'wss' : 'ws'}://${config.host}:${config.port}/app/${encodeURIComponent(config.key)}?protocol=7&client=materyalph&version=1.0`)
      socket = current
      handshake = setTimeout(reconnect, 15000)
      current.onclose = reconnect
      current.onerror = reconnect
      current.onmessage = event => {
        void (async () => {
          if (closed || socket !== current) return
          const message: { event?: string; data?: string | Record<string, unknown> } = JSON.parse(String(event.data))
          const data: Record<string, unknown> = typeof message.data === 'string' ? JSON.parse(message.data) : message.data ?? {}
          if (message.event === 'pusher:connection_established' && typeof data.socket_id === 'string') {
            const signature = await api().authorizeChatChannel({ ...scope, chatChannelAuth: { socketId: data.socket_id, channelName: `private-${target}` } })
            if (!closed && socket === current && current.readyState === WebSocket.OPEN) current.send(JSON.stringify({ event: 'pusher:subscribe', data: { channel: `private-${target}`, auth: signature.auth } }))
          } else if (message.event === 'pusher:ping') current.send(JSON.stringify({ event: 'pusher:pong', data: {} }))
          else if (message.event === 'pusher_internal:subscription_succeeded') { clearTimeout(handshake); delay = 1000; setLive(true); refresh() }
          else if (message.event && changeEvents.includes(message.event)) refresh()
          else if (message.event === 'conversation.typing' && typeof data.typing === 'boolean' && typeof data.at === 'number') onTyping?.(data.typing, data.at)
          else if (message.event === 'pusher:error') reconnect()
        })().catch(reconnect)
      }
    } catch { reconnect() }
  }
  const online = () => { refresh(); if (socket?.readyState !== WebSocket.OPEN) reconnect() }
  const visible = () => { if (document.visibilityState === 'visible') online() }
  window.addEventListener('online', online)
  document.addEventListener('visibilitychange', visible)
  void connect()
  return () => { closed = true; clearTimeout(retry); clearTimeout(handshake); socket?.close(); window.removeEventListener('online', online); document.removeEventListener('visibilitychange', visible) }
}
