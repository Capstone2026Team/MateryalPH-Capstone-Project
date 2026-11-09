import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { EnforcementNoticePopup } from '../../../../packages/web-ui/src/enforcement-notice-popup'
import * as realtime from '../../../../packages/web-ui/src/notification-realtime'

vi.mock('../../../../packages/web-ui/src/notification-realtime', () => ({ watchNotificationUpdates: vi.fn().mockResolvedValue(() => undefined) }))
const notice = { id: 'notice-1', category: 'SUSPENSION', title: 'Account warning', body: 'A warning was recorded. Reason: repeated missed pickups. No access changes.', mandatory: true, readAt: null, createdAt: '2026-11-08T02:00:00Z' }
beforeEach(() => { vi.restoreAllMocks(); vi.mocked(realtime.watchNotificationUpdates).mockClear() })

test('an enforcement notice opens automatically and acknowledgement marks only that notice read', async () => {
  const list = vi.spyOn(NotificationsApi.prototype, 'listNotifications').mockResolvedValue({ data: [notice], meta: {}, errors: [] })
  const read = vi.spyOn(NotificationsApi.prototype, 'readNotification').mockImplementation(async () => {
    list.mockResolvedValue({ data: [], meta: {}, errors: [] })
    return { data: { id: notice.id, readAt: '2026-11-08T02:01:00Z' }, meta: {}, errors: [] } as never
  })
  render(<EnforcementNoticePopup basePath="https://api.example.test/api/v1" />)
  expect(await screen.findByRole('dialog', { name: 'Account warning' })).toBeInTheDocument()
  expect(screen.getByText(/repeated missed pickups/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Acknowledge' }))
  await waitFor(() => expect(read).toHaveBeenCalledWith({ audience: 'vendor', noticeId: notice.id }))
  await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
})

test('session revocation clears a popup immediately and a late response cannot restore it', async () => {
  vi.spyOn(NotificationsApi.prototype, 'listNotifications').mockResolvedValue({ data: [notice], meta: {}, errors: [] })
  render(<EnforcementNoticePopup basePath="https://api.example.test/api/v1" />)
  await screen.findByRole('dialog')
  act(() => window.dispatchEvent(new Event('materyalph:session-cleared')))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('ordinary order notices do not open the enforcement popup', async () => {
  vi.spyOn(NotificationsApi.prototype, 'listNotifications').mockResolvedValue({ data: [{ ...notice, category: 'ORDERS' }], meta: {}, errors: [] })
  render(<EnforcementNoticePopup basePath="https://api.example.test/api/v1" />)
  await waitFor(() => expect(realtime.watchNotificationUpdates).toHaveBeenCalledOnce())
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('a pending acknowledgement from a previous session cannot dismiss the current account notice', async () => {
  const list = vi.spyOn(NotificationsApi.prototype, 'listNotifications').mockResolvedValue({ data: [notice], meta: {}, errors: [] })
  let complete: (value: never) => void = () => undefined
  vi.spyOn(NotificationsApi.prototype, 'readNotification').mockImplementation(() => new Promise(resolve => { complete = resolve }))
  const view = render(<EnforcementNoticePopup basePath="https://api.example.test/api/v1" />)
  await screen.findByRole('dialog', { name: 'Account warning' })
  fireEvent.click(screen.getByRole('button', { name: 'Acknowledge' }))
  act(() => window.dispatchEvent(new Event('materyalph:session-cleared')))
  view.rerender(<EnforcementNoticePopup basePath="https://api.example.test/api/v1" enabled={false} />)
  list.mockResolvedValue({ data: [{ ...notice, id: 'notice-2', title: 'Temporary Restriction ended' }], meta: {}, errors: [] })
  view.rerender(<EnforcementNoticePopup basePath="https://api.example.test/api/v1" />)
  await screen.findByRole('dialog', { name: 'Temporary Restriction ended' })
  await act(async () => { complete({ data: { read: true }, meta: {}, errors: [] } as never) })
  expect(screen.getByRole('dialog', { name: 'Temporary Restriction ended' })).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Acknowledge' })).toBeEnabled()
})
