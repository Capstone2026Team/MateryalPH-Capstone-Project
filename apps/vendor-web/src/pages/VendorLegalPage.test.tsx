import { fireEvent, render, screen } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import { afterEach, expect, test, vi } from 'vitest'
import { VendorLegalPage } from './VendorLegalPage'
import { Routes, Route } from 'react-router-dom'

const agreements = [
  { id: 'terms-1', code: 'TERMS_OF_SERVICE', title: 'Published terms', audience: 'ALL', version: 1, content_uri: '/legal/terms-of-service', effective_at: '2026-09-14T00:00:00Z', content: '# Terms\n\nOld terms.' },
  { id: 'terms-2', code: 'TERMS_OF_SERVICE', title: 'Published terms', audience: 'ALL', version: 2, content_uri: '/legal/terms-of-service', effective_at: '2026-09-14T00:00:00Z', content: '# Terms\n\n## Marketplace roles\n\nEach Vendor remains the seller.' },
  { id: 'privacy-2', code: 'PRIVACY_NOTICE', title: 'Published privacy notice', audience: 'ALL', version: 2, content_uri: '/legal/privacy-notice', effective_at: '2026-09-14T00:00:00Z', content: '# Privacy\n\n## Retention and requests\n\nContact the privacy team.' },
]

function openDocument(document: string) {
  window.history.replaceState({}, '', `/legal/${document}`)
  return render(<BrowserRouter><Routes><Route path="/legal/:document" element={<VendorLegalPage />} /></Routes></BrowserRouter>)
}

function response(data: typeof agreements) {
  return new Response(JSON.stringify({ data, meta: {}, errors: [] }), { status: 200, headers: { 'Content-Type': 'application/json' } })
}

afterEach(() => vi.unstubAllGlobals())

test.each([
  ['terms-of-service', 'Terms of Service', 'Each Vendor remains the seller.', 'Contact the privacy team.'],
  ['privacy-notice', 'Privacy Notice', 'Contact the privacy team.', 'Each Vendor remains the seller.'],
])('loads the correct current document for %s', async (document, title, content, otherContent) => {
  const fetch = vi.fn().mockResolvedValue(response(agreements))
  vi.stubGlobal('fetch', fetch)
  openDocument(document)
  expect(screen.getByRole('heading', { level: 1, name: title })).toBeVisible()
  expect(screen.getByText('Loading the published document…')).toBeVisible()
  expect(await screen.findByText(content)).toBeVisible()
  expect(screen.queryByText(otherContent)).not.toBeInTheDocument()
  expect(screen.queryByText('Old terms.')).not.toBeInTheDocument()
  expect(screen.getByText(/Version 2 · Effective/)).toBeVisible()
  expect(fetch.mock.calls[0]?.[0]).toContain('/api/v1/agreements/current')
})

test('offers retry after an API failure', async () => {
  vi.stubGlobal('fetch', vi.fn().mockRejectedValueOnce(new TypeError('Offline')).mockResolvedValueOnce(response(agreements)))
  openDocument('terms-of-service')
  expect(await screen.findByRole('alert')).toHaveTextContent('This document could not be loaded')
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(await screen.findByText('Each Vendor remains the seller.')).toBeVisible()
})

test('handles missing published content without showing another document', async () => {
  vi.stubGlobal('fetch', vi.fn().mockResolvedValue(response(agreements.filter(item => item.code === 'PRIVACY_NOTICE'))))
  openDocument('terms-of-service')
  expect(await screen.findByRole('alert')).toHaveTextContent('This document could not be loaded')
  expect(screen.queryByText('Contact the privacy team.')).not.toBeInTheDocument()
})

test.each(['unknown', '__proto__'])('unknown document %s shows a not found state without calling the API', (document) => {
  const fetch = vi.fn()
  vi.stubGlobal('fetch', fetch)
  openDocument(document)
  expect(screen.getByRole('heading', { name: 'Document not found' })).toBeVisible()
  expect(fetch).not.toHaveBeenCalled()
})
