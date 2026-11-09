import { act, fireEvent, render, screen } from '@testing-library/react'
import { AsyncLoading, ConnectionNotice, RequestErrorState } from '@materyalph/web-ui'
import { afterEach, expect, test, vi } from 'vitest'

afterEach(() => vi.restoreAllMocks())

test('connection changes keep drafts and request errors mounted and never retry an action automatically', () => {
  const online = vi.spyOn(navigator, 'onLine', 'get').mockReturnValue(true)
  const retry = vi.fn()
  render(<><ConnectionNotice /><label>Draft<input defaultValue="Unsaved message" /></label><RequestErrorState message="You do not have permission to view this record." onRetry={retry} /></>)
  const draft = screen.getByRole('textbox', { name: 'Draft' })
  const failure = screen.getByRole('alert')
  expect(screen.queryByText("You're offline")).not.toBeInTheDocument()
  online.mockReturnValue(false)
  act(() => { window.dispatchEvent(new Event('offline')) })
  expect(screen.getByRole('status')).toHaveTextContent("You're offline")
  expect(screen.getByRole('textbox', { name: 'Draft' })).toBe(draft)
  expect(draft).toHaveValue('Unsaved message')
  expect(screen.getByRole('alert')).toBe(failure)
  expect(failure).toHaveTextContent('You do not have permission')
  online.mockReturnValue(true)
  act(() => { window.dispatchEvent(new Event('online')) })
  expect(screen.queryByText("You're offline")).not.toBeInTheDocument()
  expect(retry).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(retry).toHaveBeenCalledTimes(1)
})

test('loading announces the affected section without an empty state or a fabricated count', () => {
  const view = render(<AsyncLoading label="Loading orders…" framed />)
  expect(screen.getByRole('status')).toHaveTextContent('Loading orders…')
  expect(screen.queryByRole('alert')).not.toBeInTheDocument()
  expect(screen.queryByText(/no orders|0 orders/i)).not.toBeInTheDocument()
  view.rerender(<AsyncLoading label="Updating orders…" compact />)
  expect(screen.getByRole('status')).toHaveTextContent('Updating orders…')
})

test('an offline retry card keeps its specific cause and only retries on demand', () => {
  const retry = vi.fn()
  render(<RequestErrorState kind="offline" message="Reconnect to load your orders." onRetry={retry} />)
  expect(screen.getByRole('alert')).toHaveTextContent("You're offline")
  expect(retry).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(retry).toHaveBeenCalledTimes(1)
})
