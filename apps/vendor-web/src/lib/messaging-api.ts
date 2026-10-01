import { MessagingApi, type ChatDraftContent } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
export { readableOnboardingError as readableChatError } from './onboarding-api'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new MessagingApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const scope = { messagingPortal: 'vendor' as const }
export const chatApi = {
  list: async (page = 1) => (await api().listConversations({ ...scope, page })).data,
  get: async (conversationId: string, before?: string, page = 1) => (await api().getConversation({ ...scope, conversationId, ...(before ? { before } : {}), page })).data,
  send: (conversationId: string, body: string, clientMessageId: string) => api().sendChatMessage({ ...scope, conversationId, chatSend: { body, clientMessageId } }),
  read: (conversationId: string, throughMessageId: string) => api().readChatMessages({ ...scope, conversationId, chatRead: { throughMessageId } }),
  handlers: (conversationId: string, page = 1) => api().listChatHandlers({ ...scope, conversationId, page }),
  transfer: (conversationId: string, handlerUserId: number, lockVersion: number, reason: string) => api().transferChatHandler({ ...scope, conversationId, chatTransfer: { handlerUserId, lockVersion, reason } }),
  draft: async (conversationId: string, lockVersion: number, draft: ChatDraftContent) => (await api().saveChatQuotationDraft({ ...scope, conversationId, chatDraftSave: { lockVersion, draft } })).data,
  publish: (conversationId: string, lockVersion: number, idempotencyKey: string) => api().publishChatQuotation({ ...scope, conversationId, idempotencyKey, chatPublish: { lockVersion } }),
  withdraw: (conversationId: string, versionId: string, idempotencyKey: string) => api().decideChatQuotation({ ...scope, conversationId, idempotencyKey, action: 'withdraw', chatDecision: { versionId } }),
  upload: (conversationId: string, file: Blob, clientMessageId: string) => api().uploadChatAttachment({ ...scope, conversationId, file, clientMessageId }),
  download: (conversationId: string, attachmentId: string) => api().downloadChatAttachment({ ...scope, conversationId, attachmentId }),
}
export async function loadChatAvatar(path: string): Promise<Blob> {
  const match = /^\/conversations\/([0-9a-f-]+)\/avatars\/(\d+)$/i.exec(path)
  if (!match?.[1]) throw new Error('Avatar unavailable')
  return api().getChatAvatar({ ...scope, conversationId: match[1], userId: Number(match[2]) })
}

/** Native Pusher protocol: invalidations only; payloads always come through authenticated REST. */
export async function watchConversation(channel: string, refresh: () => void): Promise<() => void> {
  const config = (await api().getChatRealtime(scope)).data
  if (!config.enabled || !config.key || !config.host) return () => undefined
  const socket = new WebSocket(`${config.scheme === 'https' ? 'wss' : 'ws'}://${config.host}:${config.port}/app/${encodeURIComponent(config.key)}?protocol=7&client=materyalph&version=1.0`)
  let closed = false
  socket.onmessage = event => {
    void (async () => {
      const message: { event?: string; data?: string | { socket_id?: string } } = JSON.parse(String(event.data))
      if (message.event === 'pusher:connection_established') {
        const data: { socket_id?: string } = typeof message.data === 'string' ? JSON.parse(message.data) : message.data ?? {}
        if (!data.socket_id) return
        const signature = await api().authorizeChatChannel({ ...scope, chatChannelAuth: { socketId: data.socket_id, channelName: `private-${channel}` } })
        if (!closed && socket.readyState === WebSocket.OPEN) socket.send(JSON.stringify({ event: 'pusher:subscribe', data: { channel: `private-${channel}`, auth: signature.auth } }))
      } else if (message.event === 'pusher:ping') socket.send(JSON.stringify({ event: 'pusher:pong', data: {} }))
      else if (message.event === 'conversation.changed') refresh()
    })().catch(() => socket.close())
  }
  return () => { closed = true; socket.close() }
}
