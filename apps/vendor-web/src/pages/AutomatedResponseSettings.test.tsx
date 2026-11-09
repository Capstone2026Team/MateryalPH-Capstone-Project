import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { AutomatedResponseSettingsDialog } from '@materyalph/web-ui'

afterEach(cleanup)

test('settings save the master toggle and up to three exact button responses', async () => {
  const load = vi.fn().mockResolvedValue({ enabled: false, welcomeMessage: '', options: [], lockVersion: 0 })
  const save = vi.fn().mockResolvedValue({})
  const close = vi.fn()
  render(<AutomatedResponseSettingsDialog load={load} save={save} onClose={close} />)
  fireEvent.click(await screen.findByRole('switch', { name: 'Automated responses' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Welcome message' }), { target: { value: 'Welcome to our store.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Add quick reply' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Button label' }), { target: { value: 'Store hours' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Exact response' }), { target: { value: 'Open 8 AM to 5 PM.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Add quick reply' }))
  fireEvent.click(screen.getByRole('button', { name: 'Add quick reply' }))
  expect(screen.queryByRole('button', { name: 'Add quick reply' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Remove quick reply 3' }))
  fireEvent.click(screen.getByRole('button', { name: 'Remove quick reply 2' }))
  fireEvent.click(screen.getByRole('button', { name: 'Save Changes' }))
  await waitFor(() => expect(save).toHaveBeenCalledWith({ enabled: true, welcomeMessage: 'Welcome to our store.', options: [{ label: 'Store hours', response: 'Open 8 AM to 5 PM.' }], lockVersion: 0 }, expect.any(String)))
  expect(close).toHaveBeenCalledOnce()
})

test('cancel discards edits and a failed save preserves text for retry', async () => {
  const load = vi.fn().mockResolvedValue({ enabled: true, welcomeMessage: 'Saved welcome', options: [], lockVersion: 4 })
  const save = vi.fn().mockRejectedValue(new Error('Offline. Please retry.'))
  const close = vi.fn()
  render(<AutomatedResponseSettingsDialog load={load} save={save} onClose={close} />)
  fireEvent.change(await screen.findByRole('textbox', { name: 'Welcome message' }), { target: { value: 'Keep my changes' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save Changes' }))
  await screen.findByText('Offline. Please retry.')
  expect(close).not.toHaveBeenCalled()
  expect(screen.getByRole('textbox', { name: 'Welcome message' })).toHaveValue('Keep my changes')
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(close).toHaveBeenCalledOnce()
})
