import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as operations from '../lib/operations-api'
import { RecordActionDialog } from './EnforcementPages'

vi.mock('../lib/operations-api', async original => ({ ...await original<typeof import('../lib/operations-api')>(), getSubject: vi.fn(), searchSubjects: vi.fn(), uploadEnforcementEvidence: vi.fn(), recordEnforcement: vi.fn() }))
const subject = { subjectType: 'BUYER', subjectId: 'buyer-1', displayName: 'Maria S. · Buyer …123456', accountStatus: 'ACTIVE', openOrders: 0, disputesOpen: 0, disputesTotal: 1, sanctions: [], recordableActions: ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION'] }
beforeEach(() => { vi.clearAllMocks(); vi.mocked(operations.getSubject).mockResolvedValue(subject as never) })

test.each(['BUYER', 'VENDOR_ORGANIZATION'] as const)('profile dialog loads the exact %s without searching', async type => {
  render(<MemoryRouter><RecordActionDialog initialType={type} initialSubjectId="subject-id" lockType onClose={vi.fn()} /></MemoryRouter>)
  const dialog = screen.getByRole('dialog', { name: 'Record enforcement action' })
  await within(dialog).findByRole('button', { name: 'Record warning & notify' })
  expect(operations.getSubject).toHaveBeenCalledWith(type, 'subject-id')
  expect(within(dialog).queryByRole('search')).not.toBeInTheDocument()
  expect(operations.searchSubjects).not.toHaveBeenCalled()
  expect(within(dialog).getByText('Proof attachments')).toBeInTheDocument()
  expect(within(dialog).getByText(/queues an email and in-app notification/)).toBeInTheDocument()
  expect(within(dialog).queryByRole('option', { name: 'Permanent Ban' })).not.toBeInTheDocument()
})

test('a failed decision retains the proof and reuses the uploaded file and idempotency key on retry', async () => {
  const recorded = vi.fn()
  vi.mocked(operations.uploadEnforcementEvidence).mockResolvedValue({ id: 'file-1', name: 'proof.pdf', contentType: 'application/pdf', byteSize: 10 })
  vi.mocked(operations.recordEnforcement).mockRejectedValueOnce(new Error('Network offline')).mockResolvedValueOnce({ id: 'action-1' } as never)
  render(<MemoryRouter><RecordActionDialog initialType="BUYER" initialSubjectId="buyer-1" lockType onClose={vi.fn()} onRecorded={recorded} /></MemoryRouter>)
  await screen.findByLabelText('Action')
  const proof = new File(['%PDF-1.4'], 'proof.pdf', { type: 'application/pdf' })
  vi.stubGlobal('URL', Object.assign(URL, { createObjectURL: vi.fn(() => 'blob:proof'), revokeObjectURL: vi.fn() }))
  fireEvent.change(screen.getByLabelText('Add proof attachments'), { target: { files: [proof] } })
  fireEvent.change(screen.getByLabelText(/^Reason/), { target: { value: 'Repeated no-shows confirmed by review.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record warning & notify' }))
  await waitFor(() => expect(operations.recordEnforcement).toHaveBeenCalledTimes(1))
  await screen.findByRole('alert')
  expect(recorded).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Record warning & notify' }))
  await waitFor(() => expect(recorded).toHaveBeenCalledOnce())
  expect(operations.uploadEnforcementEvidence).toHaveBeenCalledTimes(1)
  expect(vi.mocked(operations.recordEnforcement).mock.calls[1]).toEqual(vi.mocked(operations.recordEnforcement).mock.calls[0])
  expect(vi.mocked(operations.recordEnforcement).mock.calls[0]?.[0]).toMatchObject({ subjectType: 'BUYER', subjectId: 'buyer-1', evidenceFileIds: new Set(['file-1']) })
})

test('view-only administrators cannot record or upload proof', async () => {
  vi.mocked(operations.getSubject).mockResolvedValue({ ...subject, recordableActions: [] } as never)
  render(<MemoryRouter><RecordActionDialog initialType="BUYER" initialSubjectId="buyer-1" lockType onClose={vi.fn()} /></MemoryRouter>)
  await screen.findByText(/Recording an action requires User Management permission/)
  expect(screen.queryByRole('button', { name: 'Record warning & notify' })).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Add proof attachments')).not.toBeInTheDocument()
})

test('unsupported proof and more than five files are refused before upload', async () => {
  render(<MemoryRouter><RecordActionDialog initialType="BUYER" initialSubjectId="buyer-1" lockType onClose={vi.fn()} /></MemoryRouter>)
  await screen.findByLabelText('Action')
  const picker = screen.getByLabelText('Add proof attachments')
  fireEvent.change(picker, { target: { files: [new File(['bad'], 'script.html', { type: 'text/html' })] } })
  expect(screen.getByRole('alert')).toHaveTextContent('Choose a supported file')
  fireEvent.change(picker, { target: { files: Array.from({ length: 6 }, (_, i) => new File(['%PDF'], `proof-${i}.pdf`, { type: 'application/pdf' })) } })
  expect(screen.getByRole('alert')).toHaveTextContent('Attach up to 5 proof files')
  expect(operations.uploadEnforcementEvidence).not.toHaveBeenCalled()
})
