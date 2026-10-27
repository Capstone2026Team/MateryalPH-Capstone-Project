import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError, type OperationFailure, type OperationRetryResult } from '@materyalph/api-client-ts'
import * as operations from '../lib/operations-api'
import { BulkOperationRetryPanel } from './BulkOperationRetryPanel'

vi.mock('../lib/operations-api', async original => ({ ...await original<typeof import('../lib/operations-api')>(), operationRetryPreview: vi.fn(), retryOperation: vi.fn() }))
const failure = (reference: string, retryable = true): OperationFailure => ({ kind: 'OUTBOX_EVENT', reference, label: `Delivery ${reference}`, queue: 'notifications', failure: 'Delivery exhausted', failedAt: new Date(), retryable, retryNote: retryable ? null : 'Payment work uses its own reconciliation.' })
const queued = (reference: string): OperationRetryResult => ({ targetType: 'OUTBOX_EVENT', reference, label: `Delivery ${reference}`, outcome: 'QUEUED', correlationId: `correlation-${reference}` })
const reason = 'Mail provider recovered after the outage.'
function open(kind: 'OUTBOX' | 'JOBS' = 'OUTBOX') {
  const onChanged = vi.fn(), onClose = vi.fn()
  render(<MemoryRouter><BulkOperationRetryPanel kind={kind} onClose={onClose} onChanged={onChanged} onReview={vi.fn()} /></MemoryRouter>)
  return { onChanged, onClose }
}
async function start() {
  await screen.findByRole('button', { name: 'Retry 2 deliveries' })
  fireEvent.change(screen.getByLabelText(/^Reason/), { target: { value: reason } })
  fireEvent.click(screen.getByRole('button', { name: 'Retry 2 deliveries' }))
}
beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(operations.operationRetryPreview).mockResolvedValue([failure('one'), failure('two'), failure('payment', false)])
  vi.mocked(operations.retryOperation).mockImplementation(async input => ({ ...queued(input.reference), targetType: input.targetType }))
})

test('a reason is required and only eligible work is retried with distinct idempotency keys and audited results', async () => {
  const { onChanged } = open()
  fireEvent.click(await screen.findByRole('button', { name: 'Retry 2 deliveries' }))
  expect(operations.retryOperation).not.toHaveBeenCalled()
  await start()
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(1))
  expect(operations.retryOperation).toHaveBeenCalledTimes(2)
  expect(operations.retryOperation).toHaveBeenNthCalledWith(1, { targetType: 'OUTBOX_EVENT', reference: 'one', reason }, expect.any(String))
  expect(operations.retryOperation).toHaveBeenNthCalledWith(2, { targetType: 'OUTBOX_EVENT', reference: 'two', reason }, expect.any(String))
  expect(vi.mocked(operations.retryOperation).mock.calls[0]?.[1]).not.toBe(vi.mocked(operations.retryOperation).mock.calls[1]?.[1])
  expect(screen.getByText('Correlation ID correlation-one')).toBeInTheDocument()
  expect(screen.getByText(/Queued work still needs to run successfully/)).toBeInTheDocument()
})

test('stop waits for the in-flight request and resume skips work already queued', async () => {
  let finish: (result: OperationRetryResult) => void = () => undefined
  vi.mocked(operations.retryOperation).mockImplementationOnce(() => new Promise(resolve => { finish = resolve }))
  const { onChanged, onClose } = open()
  await start()
  expect(screen.getByRole('button', { name: 'Close panel' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Stop after current request' }))
  await act(async () => { finish(queued('one')) })
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(1))
  expect(operations.retryOperation).toHaveBeenCalledTimes(1)
  expect(onClose).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Retry unfinished work (1)' }))
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(2))
  expect(operations.retryOperation).toHaveBeenCalledTimes(2)
  expect(vi.mocked(operations.retryOperation).mock.calls[1]?.[0].reference).toBe('two')
})

test.each([0, 503])('an uncertain response (%s) stops the batch and reuses the original key and reason when resumed', async status => {
  vi.mocked(operations.retryOperation).mockRejectedValueOnce(status === 0 ? new TypeError('Connection interrupted') : new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [] }), { status }), 'Service unavailable'))
  const { onChanged } = open()
  await start()
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(1))
  expect(operations.retryOperation).toHaveBeenCalledTimes(1)
  fireEvent.click(screen.getByRole('button', { name: 'Retry unfinished work (2)' }))
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(2))
  const calls = vi.mocked(operations.retryOperation).mock.calls
  expect(calls).toHaveLength(3)
  expect(calls[1]).toEqual(calls[0])
  expect(calls[2]?.[0].reference).toBe('two')
})

test('lost retry permission stops further requests and leaves the failure visible', async () => {
  vi.mocked(operations.retryOperation).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'Retry permission was removed.' }] }), { status: 403 }), 'Forbidden'))
  const { onChanged } = open()
  await start()
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(1))
  expect(operations.retryOperation).toHaveBeenCalledTimes(1)
  expect(screen.getByText('Retry permission was removed.')).toBeInTheDocument()
})

test('non-retryable work never exposes an executable batch', async () => {
  vi.mocked(operations.operationRetryPreview).mockResolvedValue([failure('payment', false)])
  open()
  expect(await screen.findByText(/No eligible deliveries are available/)).toBeInTheDocument()
  expect(screen.queryByRole('form')).not.toBeInTheDocument()
  expect(operations.retryOperation).not.toHaveBeenCalled()
})

test('a preview failure can be retried without sending any work for execution', async () => {
  vi.mocked(operations.operationRetryPreview).mockRejectedValueOnce(new TypeError('Connection interrupted')).mockResolvedValueOnce([])
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Try again' }))
  expect(await screen.findByText(/No eligible deliveries are available/)).toBeInTheDocument()
  expect(operations.retryOperation).not.toHaveBeenCalled()
})

test('a job batch uses FAILED_JOB targets and keeps stale or refused entries in its results', async () => {
  vi.mocked(operations.operationRetryPreview).mockResolvedValue([{ ...failure('gone'), kind: 'FAILED_JOB' }, { ...failure('safe'), kind: 'FAILED_JOB' }])
  vi.mocked(operations.retryOperation).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'RETRY_TARGET_NOT_FOUND', message: 'This failed job is no longer listed.' }] }), { status: 404 }), 'Not found'))
  const { onChanged } = open('JOBS')
  await screen.findByRole('button', { name: 'Retry 2 jobs' })
  fireEvent.change(screen.getByLabelText(/^Reason/), { target: { value: reason } })
  fireEvent.click(screen.getByRole('button', { name: 'Retry 2 jobs' }))
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(1))
  expect(operations.retryOperation).toHaveBeenNthCalledWith(2, { targetType: 'FAILED_JOB', reference: 'safe', reason }, expect.any(String))
  expect(screen.getByText('This failed job is no longer listed.')).toBeInTheDocument()
})
