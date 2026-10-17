import { useCallback } from 'react'
import { useNavigationRefresh, usePortalResource } from '@materyalph/web-ui'
import { chatApi } from './messaging-api'

/** Reading a badge never acknowledges messages or refreshes the surrounding order form. */
export function useFulfillmentUnreadCount(conversationId: string | null | undefined) {
  const load = useCallback(async () => {
    if (!conversationId) return 0
    const { conversation } = await chatApi.get(conversationId)
    return conversation.purpose === 'FULFILLMENT' ? conversation.unreadCount : 0
  }, [conversationId])
  const { data, synchronize } = usePortalResource(`vendor-fulfillment-unread:${conversationId ?? ''}`, load, Boolean(conversationId))
  useNavigationRefresh(() => { if (conversationId) void synchronize() })
  return conversationId ? data ?? 0 : 0
}
