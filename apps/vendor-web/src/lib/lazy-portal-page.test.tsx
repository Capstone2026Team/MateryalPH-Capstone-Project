import { startTransition, useState } from 'react'
import { act, fireEvent, render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { lazyPortalPage, PortalPageLoading } from '../../../../packages/web-ui/src/lazy-portal-page'

afterEach(() => vi.restoreAllMocks())

test('does not load an unselected page and shows progress on its first visit', async () => {
  let resolve!: (module: { default: () => React.JSX.Element }) => void
  const load = vi.fn(() => new Promise<{ default: () => React.JSX.Element }>(done => { resolve = done }))
  const Page = lazyPortalPage(load)
  const { rerender } = render(<PortalPageLoading><h1>Current page</h1></PortalPageLoading>)
  expect(load).not.toHaveBeenCalled()

  rerender(<PortalPageLoading><Page /></PortalPageLoading>)
  expect(screen.getByRole('status')).toHaveTextContent('Opening page…')
  await act(async () => resolve({ default: () => <h1>Requested page</h1> }))
  expect(screen.getByRole('heading', { name: 'Requested page' })).toBeVisible()
  expect(load).toHaveBeenCalledOnce()
})

test('retries a failed page download with a new loader', async () => {
  vi.spyOn(console, 'error').mockImplementation(() => {})
  const load = vi.fn()
    .mockRejectedValueOnce(new Error('Download unavailable'))
    .mockResolvedValueOnce({ default: () => <h1>Recovered page</h1> })
  const Page = lazyPortalPage(load)
  const { rerender } = render(<PortalPageLoading><Page /></PortalPageLoading>)

  expect(await screen.findByRole('alert')).toHaveTextContent('Unable to open this page')
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(await screen.findByRole('heading', { name: 'Recovered page' })).toBeVisible()
  rerender(<PortalPageLoading><h1>Another page</h1></PortalPageLoading>)
  rerender(<PortalPageLoading><Page /></PortalPageLoading>)
  expect(await screen.findByRole('heading', { name: 'Recovered page' })).toBeVisible()
  expect(load).toHaveBeenCalledTimes(2)
})

test('keeps the current navigation and entered values visible during a page transition', async () => {
  let resolve!: (module: { default: () => React.JSX.Element }) => void
  const Page = lazyPortalPage(() => new Promise(done => { resolve = done }))
  function Portal() {
    const [next, setNext] = useState(false)
    return <PortalPageLoading>{next ? <Page /> : <>
      <nav>Current navigation</nav><input aria-label="Current filter" defaultValue="Cement" />
      <button onClick={() => startTransition(() => setNext(true))}>Open page</button>
    </>}</PortalPageLoading>
  }
  render(<Portal />)
  fireEvent.click(screen.getByRole('button', { name: 'Open page' }))
  expect(screen.getByRole('navigation')).toHaveTextContent('Current navigation')
  expect(screen.getByRole('textbox', { name: 'Current filter' })).toHaveValue('Cement')
  expect(screen.queryByText('Opening page…')).not.toBeInTheDocument()
  await act(async () => resolve({ default: () => <h1>Next page</h1> }))
  expect(screen.getByRole('heading', { name: 'Next page' })).toBeVisible()
})
