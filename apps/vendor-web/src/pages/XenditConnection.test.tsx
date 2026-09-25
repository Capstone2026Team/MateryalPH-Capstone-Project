import { XenditConnection, type XenditConnectionProps } from '@materyalph/web-ui'
import { act, cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'

afterEach(() => { cleanup(); vi.restoreAllMocks() })
function props(overrides: Partial<XenditConnectionProps> = {}): XenditConnectionProps {
  return { status: 'NOT_CONNECTED', canConfigure: true, connect: vi.fn().mockResolvedValue({}), describeError: async () => 'MateryalPH could not connect your store to Xendit. Please try again.', ...overrides }
}
test('explains the TEST account API without manual fields or invitation', () => {
  render(<XenditConnection {...props({ lastError: 'PROVIDER_ONBOARDING_UNSUPPORTED' })} />)
  expect(screen.getByText(/Xendit will not send a Vendor registration invitation/)).toBeInTheDocument()
  expect(screen.queryByRole('heading')).not.toBeInTheDocument()
  expect(screen.queryByRole('textbox')).not.toBeInTheDocument()
  expect(screen.queryByRole('alert')).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Connect Xendit' })).toBeEnabled()
})
test('loading blocks repeated clicks and successful saved state updates without opening a tab', async () => {
  const open = vi.spyOn(window, 'open')
  let finish!: () => void
  const input = props({ connect: vi.fn(() => new Promise<void>(resolve => { finish = resolve })) })
  const view = render(<XenditConnection {...input} />)
  fireEvent.click(screen.getByRole('button', { name: 'Connect Xendit' }))
  const loading = screen.getByRole('button', { name: 'Checking Xendit...' })
  expect(loading).toBeDisabled()
  fireEvent.click(loading)
  expect(input.connect).toHaveBeenCalledOnce()
  await act(async () => finish())
  view.rerender(<XenditConnection {...input} status="CONNECTED_TEST" accountSuffix="8763" />)
  expect(screen.getByText('Xendit — Connected')).toBeInTheDocument()
  expect(screen.getByText('The xenPlatform TEST sub-account is connected. You can now proceed to the next step.')).toBeInTheDocument()
  expect(screen.getByText(/••••••8763/)).toBeInTheDocument()
  expect(screen.queryByRole('button')).not.toBeInTheDocument()
  expect(open).not.toHaveBeenCalled()
})
test('failure stays disconnected and offers retry without a new tab', async () => {
  const open = vi.spyOn(window, 'open')
  render(<XenditConnection {...props({ connect: vi.fn().mockRejectedValue(new Error('failure')) })} />)
  fireEvent.click(screen.getByRole('button', { name: 'Connect Xendit' }))
  await waitFor(() => expect(screen.getByRole('alert')).toHaveTextContent('Please try again.'))
  expect(screen.getByText('Not Connected')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Connect Xendit' })).toBeEnabled()
  expect(open).not.toHaveBeenCalled()
})

test('reloaded account-access denial explains how to recover', () => {
  render(<XenditConnection {...props({ status: 'CONNECTION_FAILED', lastError: 'PROVIDER_ACCOUNT_ACCESS_REQUIRED' })} />)
  expect(screen.getByRole('alert')).toHaveTextContent('Account Write permission')
  expect(screen.getByRole('button', { name: 'Try again' })).toBeEnabled()
})

test('explicit rejection can retry once through the backend without a registration tab', async () => {
  const connect = vi.fn().mockResolvedValue({})
  const open = vi.spyOn(window, 'open')
  render(<XenditConnection {...props({ status: 'CONNECTION_FAILED', lastError: 'PROVIDER_ACCOUNT_CONFLICT', connect })} />)
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  await waitFor(() => expect(connect).toHaveBeenCalledOnce())
  expect(open).not.toHaveBeenCalled()
})
test('uncertain create cannot be submitted again from the Vendor screen', () => {
  const connect = vi.fn().mockResolvedValue({})
  render(<XenditConnection {...props({ status: 'CONNECTION_FAILED', lastError: 'PROVIDER_ONBOARDING_UNCERTAIN', connect })} />)
  expect(screen.getByText('Confirmation needed')).toBeInTheDocument()
  expect(screen.getByText(/Another creation is blocked/)).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Connect Xendit' })).not.toBeInTheDocument()
  expect(connect).not.toHaveBeenCalled()
})
test('in-flight reservation remains visibly blocked after reload', () => {
  render(<XenditConnection {...props({ status: 'CONNECTING' })} />)
  expect(screen.getByText('Confirmation needed')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Connect Xendit' })).not.toBeInTheDocument()
})
test('pending account offers a status check without creating another account', async () => {
  const connect = vi.fn().mockResolvedValue({})
  const reconcile = vi.fn().mockResolvedValue({})
  render(<XenditConnection {...props({ status: 'PENDING', accountSuffix: '8763', connect, reconcile })} />)
  expect(screen.getByText('Account pending')).toBeInTheDocument()
  expect(screen.getByText(/Store Activation waits until Xendit confirms/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Check account status' }))
  await waitFor(() => expect(reconcile).toHaveBeenCalledOnce())
  expect(connect).not.toHaveBeenCalled()
})
test('suspended provider account never appears connected', () => {
  render(<XenditConnection {...props({ status: 'PENDING', providerStatus: 'SUSPENDED', reconcile: vi.fn() })} />)
  expect(screen.getByText('Account suspended')).toBeInTheDocument()
  expect(screen.getByText(/Store Activation remains blocked/)).toBeInTheDocument()
  expect(screen.queryByText('Xendit — Connected')).not.toBeInTheDocument()
})
test('unprivileged members cannot initiate', () => {
  render(<XenditConnection {...props({ canConfigure: false })} />)
  expect(screen.queryByRole('button')).not.toBeInTheDocument()
})
test('reloaded confirmed state remains connected without calling provider', () => {
  const input = props({ status: 'CONNECTED_TEST' })
  render(<XenditConnection {...input} />)
  expect(screen.getByText('Xendit — Connected')).toBeInTheDocument()
  expect(input.connect).not.toHaveBeenCalled()
})
