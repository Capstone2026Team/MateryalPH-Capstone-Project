import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { ResponseError } from '@materyalph/api-client-ts'
import { beforeEach, describe, expect, test, vi } from 'vitest'

import App from './App'

const { getSessionMock } = vi.hoisted(() => ({ getSessionMock: vi.fn() }))
vi.mock('./lib/auth-api', async (importOriginal) => ({
  ...await importOriginal<typeof import('./lib/auth-api')>(),
  getSession: getSessionMock,
}))
vi.mock('./pages/AdminDashboardPage', () => ({
  AdminDashboardPage: () => <h1>Dashboard</h1>,
  AdminAuditPage: () => <h1>Audit</h1>,
}))

describe('Admin authentication portal', () => {
  beforeEach(() => {
    window.history.replaceState({}, '', '/login')
    getSessionMock.mockReset()
    getSessionMock.mockRejectedValue(new ResponseError(new Response(null, { status: 401 })))
  })

  test('keeps Admin access invitation-only', async () => {
    render(<App />)

    await screen.findByRole('button', { name: /sign in securely/i })
    expect(screen.getByRole('heading', { name: 'Welcome back' })).toBeVisible()
    expect(screen.getByText(/invitation-only/i)).toBeVisible()
    expect(screen.queryByRole('link', { name: /register/i })).not.toBeInTheDocument()
    expect(screen.getByRole('button', { name: /sign in securely/i })).toBeEnabled()
  })

  test('password visibility is accessible without submitting the form', async () => {
    render(<App />)
    await screen.findByRole('button', { name: /sign in securely/i })
    const field = screen.getByLabelText(/^Password/i, { selector: 'input' })
    fireEvent.change(field, { target: { value: 'ExamplePassword123' } })
    fireEvent.click(screen.getByRole('button', { name: 'Show password' }))
    expect(field).toHaveAttribute('type', 'text')
    expect(field).toHaveValue('ExamplePassword123')
    expect(screen.getByRole('button', { name: 'Hide password' })).toHaveAttribute('aria-pressed', 'true')
  })

  test('connects password recovery to a real route', async () => {
    render(<App />)
    await screen.findByRole('button', { name: /sign in securely/i })
    fireEvent.click(screen.getByRole('link', { name: 'Forgot password?' }))

    expect(screen.getByRole('heading', { name: /recover admin access/i })).toBeVisible()
    expect(screen.getByRole('textbox', { name: /email address/i })).toBeRequired()
  })

  test.each(['/', '/login'])('returns an active Admin session from %s to the dashboard', async path => {
    window.history.replaceState({}, '', path)
    getSessionMock.mockResolvedValue({ data: { user: { accountType: 'ADMIN' } } })
    render(<App />)

    expect(screen.queryByRole('button', { name: /sign in securely/i })).not.toBeInTheDocument()
    await screen.findByRole('heading', { name: 'Dashboard' })
    expect(window.location.pathname).toBe('/dashboard')
  })

  test('keeps the sign-in form hidden until an unauthenticated response arrives', async () => {
    let rejectSession!: (error: unknown) => void
    getSessionMock.mockReturnValue(new Promise((_, reject) => { rejectSession = reject }))
    render(<App />)

    expect(screen.getByText('Checking your Admin session…')).toBeVisible()
    expect(screen.queryByRole('button', { name: /sign in securely/i })).not.toBeInTheDocument()
    rejectSession(new ResponseError(new Response(null, { status: 401 })))
    await screen.findByRole('button', { name: /sign in securely/i })
  })

  test('does not route another account type into the Admin dashboard', async () => {
    getSessionMock.mockResolvedValue({ data: { user: { accountType: 'VENDOR' } } })
    render(<App />)

    expect(await screen.findByRole('button', { name: 'Retry session check' })).toBeVisible()
    expect(window.location.pathname).toBe('/login')
  })

  test('offers a retry when the session service is unavailable', async () => {
    getSessionMock.mockRejectedValueOnce(new Error('Network unavailable'))
    render(<App />)

    fireEvent.click(await screen.findByRole('button', { name: 'Retry session check' }))
    await waitFor(() => expect(getSessionMock).toHaveBeenCalledTimes(2))
    await screen.findByRole('button', { name: /sign in securely/i })
  })
})
