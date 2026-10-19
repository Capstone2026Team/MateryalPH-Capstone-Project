import type { ChatMessage, ChatQuotationVersion } from '@materyalph/api-client-ts'

type TimelineEntry = { id: string; timestamp: string } & (
  { kind: 'message'; message: ChatMessage } | { kind: 'quotation'; quotation: ChatQuotationVersion }
)

/** Status changes never move the immutable published terms out of their place in the thread. */
export function conversationTimeline(messages: ChatMessage[], versions: ChatQuotationVersion[]): TimelineEntry[] {
  return [
    ...messages.map((message): TimelineEntry => ({ id: `message-${message.id}`, timestamp: message.sentAt, kind: 'message', message })),
    ...versions.map((quotation): TimelineEntry => ({ id: `quotation-${quotation.id}`, timestamp: quotation.publishedAt, kind: 'quotation', quotation })),
  ].sort((a, b) => Date.parse(a.timestamp) - Date.parse(b.timestamp) || a.id.localeCompare(b.id))
}
