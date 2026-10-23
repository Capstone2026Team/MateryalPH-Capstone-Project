import { useState } from 'react'
import { fireEvent, render, screen } from '@testing-library/react'
import { afterEach, expect, it, vi } from 'vitest'
import { EvidenceFilePicker } from '@materyalph/web-ui'

afterEach(() => vi.unstubAllGlobals())

it('reviews a local receipt and removes it without uploading', () => {
  const revoke = vi.fn()
  vi.stubGlobal('URL', { createObjectURL: vi.fn(() => 'blob:receipt'), revokeObjectURL: revoke })
  function Form() {
    const [file, setFile] = useState<File | null>(null)
    return <EvidenceFilePicker label="Receipt evidence" file={file} onChange={setFile} />
  }
  render(<Form />)
  fireEvent.change(screen.getByLabelText('Receipt evidence'), { target: { files: [new File(['receipt'], 'receipt.webp', { type: 'image/webp' })] } })
  expect(screen.getByRole('img', { name: /Selected evidence preview/ })).toHaveAttribute('src', 'blob:receipt')
  expect(screen.getByRole('link', { name: 'Preview receipt.webp' })).toHaveAttribute('href', 'blob:receipt')
  fireEvent.click(screen.getByRole('button', { name: 'Remove receipt.webp' }))
  expect(screen.queryByText('receipt.webp')).not.toBeInTheDocument()
  expect(revoke).toHaveBeenCalledWith('blob:receipt')
})

it('rejects unsupported evidence without changing the selection', () => {
  const change = vi.fn()
  render(<EvidenceFilePicker label="Receipt evidence" file={null} onChange={change} />)
  fireEvent.change(screen.getByLabelText('Receipt evidence'), { target: { files: [new File(['text'], 'receipt.txt', { type: 'text/plain' })] } })
  expect(screen.getByText('Choose a JPG, PNG, WebP or PDF file up to 10 MB.')).toBeInTheDocument()
  expect(change).not.toHaveBeenCalled()
})
