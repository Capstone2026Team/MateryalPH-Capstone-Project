import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { NotificationsWorkspace } from '@materyalph/web-ui'

afterEach(() => { cleanup(); vi.restoreAllMocks() })
const notice = { id: '01995000-0000-7000-8000-000000000001', category: 'SECURITY', title: 'Account update', body: 'Review current account access.', mandatory: true, readAt: null, createdAt: '2026-10-05T00:00:00Z' }
const required = { category: 'SECURITY', mandatory: true, explanation: 'Required for account safety.', inApp: true, email: true, push: true }

describe('notification workspace', () => {
  it('explains mandatory classes and updates optional preferences', async () => {
    vi.spyOn(NotificationsApi.prototype, 'listNotifications').mockResolvedValue({ data: [], meta: {}, errors: [] })
    vi.spyOn(NotificationsApi.prototype, 'getNotificationPreferences').mockResolvedValue({ data: [required, { ...required, category: 'MARKETING', mandatory: false }], meta: {}, errors: [] })
    const update = vi.spyOn(NotificationsApi.prototype, 'updateNotificationPreference').mockResolvedValue({ data: [required], meta: {}, errors: [] })
    render(<NotificationsWorkspace basePath="https://api.example.test/api/v1" audience="vendor" navigate={vi.fn()} />)
    await screen.findByText('You’re up to date')
    fireEvent.click(screen.getByRole('button', { name: 'Preferences' }))
    expect(await screen.findByText(/Always enabled/)).toBeVisible()
    expect(screen.getAllByRole('checkbox')).toHaveLength(3)
    fireEvent.click(screen.getByRole('checkbox', { name: 'Email' }))
    await waitFor(() => expect(update).toHaveBeenCalledWith(expect.objectContaining({ notificationPreferenceInput: expect.objectContaining({ category: 'MARKETING', email: false }) })))
  })
  it('shows an explicit permission message for revoked deep links without navigating', async () => {
    vi.spyOn(NotificationsApi.prototype, 'listNotifications').mockResolvedValue({ data: [notice], meta: {}, errors: [] })
    vi.spyOn(NotificationsApi.prototype, 'resolveNotification').mockRejectedValue({ response: new Response(JSON.stringify({ errors: [{ message: 'You no longer have permission to open this notification.' }] }), { status: 403 }) })
    const navigate = vi.fn()
    render(<NotificationsWorkspace basePath="https://api.example.test/api/v1" audience="vendor" navigate={navigate} />)
    fireEvent.click(await screen.findByRole('button', { name: /View details.*Account update/ }))
    expect(await screen.findByRole('alert')).toHaveTextContent('You no longer have permission')
    expect(navigate).not.toHaveBeenCalled()
  })
  it('retries an unavailable feed and resolves authorized destinations through the API', async () => {
    vi.spyOn(NotificationsApi.prototype, 'listNotifications').mockRejectedValueOnce(new Error('offline')).mockResolvedValue({ data: [notice], meta: {}, errors: [] })
    vi.spyOn(NotificationsApi.prototype, 'resolveNotification').mockResolvedValue({ data: { path: '/settings' }, meta: {}, errors: [] })
    vi.spyOn(NotificationsApi.prototype, 'readNotification').mockResolvedValue({ data: { read: true }, meta: {}, errors: [] })
    const navigate = vi.fn()
    render(<NotificationsWorkspace basePath="https://api.example.test/api/v1" audience="vendor" navigate={navigate} />)
    fireEvent.click(await screen.findByRole('button', { name: 'Retry' }))
    fireEvent.click(await screen.findByRole('button', { name: /View details.*Account update/ }))
    await waitFor(() => expect(navigate).toHaveBeenCalledWith('/settings'))
  })
})
