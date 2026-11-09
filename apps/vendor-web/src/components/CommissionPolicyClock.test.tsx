import { PublicFinanceApi, type PublicCommissionPolicy } from '@materyalph/api-client-ts'
import { act, render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { useCommissionPolicy } from '@materyalph/web-ui'

function Rate() {
  const policy = useCommissionPolicy('https://example.invalid/api/v1')
  return <span>{policy.data?.current?.rateLabel ?? 'Loading'}</span>
}

afterEach(() => { vi.useRealTimers(); vi.restoreAllMocks() })

test('an open rate display refreshes at the scheduled effective instant without a scheduler flip', async () => {
  vi.useFakeTimers()
  const effective = new Date(Date.now() + 2000)
  const current = { id: 'policy-1', version: 1, commissionBasisPoints: 200, rateLabel: '2.00%', effectiveFrom: new Date(0), status: 'CURRENT' as const }
  const next = { ...current, id: 'policy-2', version: 2, commissionBasisPoints: 300, rateLabel: '3.00%', effectiveFrom: effective, status: 'SCHEDULED' as const }
  let data: PublicCommissionPolicy = { current, next }
  const read = vi.spyOn(PublicFinanceApi.prototype, 'getPublicCommissionPolicy').mockImplementation(async () => ({ data, meta: {}, errors: [] }))
  await act(async () => { render(<Rate />) })
  expect(screen.getByText('2.00%')).toBeVisible()
  data = { current: { ...next, status: 'CURRENT' }, next: null }
  await act(async () => { vi.advanceTimersByTime(2100) })
  expect(read).toHaveBeenCalledTimes(2)
  expect(screen.getByText('3.00%')).toBeVisible()
})

test('a rate display never substitutes the launch rate for an unavailable policy', async () => {
  vi.spyOn(PublicFinanceApi.prototype, 'getPublicCommissionPolicy').mockRejectedValue(new Error('Synthetic network failure'))
  function FailedRate() {
    const result = useCommissionPolicy('https://example.invalid/api/v1')
    return <span>{result.error ?? result.data?.current?.rateLabel ?? 'Loading'}</span>
  }
  await act(async () => { render(<FailedRate />) })
  expect(screen.getByText(/commission policy is unavailable/)).toBeVisible()
  expect(screen.queryByText('2.00%')).not.toBeInTheDocument()
})

test('a response arriving just after its scheduled change refreshes immediately', async () => {
  const current = { id: 'policy-1', version: 1, commissionBasisPoints: 200, rateLabel: '2.00%', effectiveFrom: new Date(0), status: 'CURRENT' as const }
  const next = { ...current, id: 'policy-2', version: 2, commissionBasisPoints: 300, rateLabel: '3.00%', effectiveFrom: new Date(Date.now() - 1000), status: 'SCHEDULED' as const }
  const read = vi.spyOn(PublicFinanceApi.prototype, 'getPublicCommissionPolicy')
    .mockResolvedValueOnce({ data: { current, next }, meta: {}, errors: [] })
    .mockResolvedValue({ data: { current: { ...next, status: 'CURRENT' }, next: null }, meta: {}, errors: [] })
  await act(async () => { render(<Rate />) })
  expect(read).toHaveBeenCalledTimes(2)
  expect(screen.getByText('3.00%')).toBeVisible()
})
