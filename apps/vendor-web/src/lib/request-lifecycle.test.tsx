import { StrictMode, useEffect, useState } from 'react'
import { fireEvent, render, screen } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { clearWebSessionTransport } from '@materyalph/web-ui'
import { getSession } from './auth-api'

afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('StrictMode session effects share one network read and local interaction does not reload it', async () => {
  const fetchMock = vi.fn(async () => new Response(JSON.stringify({ data: { authenticated: true }, meta: {}, errors: [] }), {
    headers: { 'Content-Type': 'application/json' },
  }))
  vi.stubGlobal('fetch', fetchMock)
  function SessionProbe() {
    const [ready, setReady] = useState(false)
    const [clicks, setClicks] = useState(0)
    useEffect(() => {
      let active = true
      void getSession().then(() => { if (active) setReady(true) })
      return () => { active = false }
    }, [])
    return <button disabled={!ready} onClick={() => setClicks(value => value + 1)}>{ready ? `Ready ${clicks}` : 'Loading'}</button>
  }
  render(<StrictMode><SessionProbe /></StrictMode>)
  const button = await screen.findByRole('button', { name: 'Ready 0' })
  for (let click = 0; click < 20; click++) fireEvent.click(button)
  expect(screen.getByRole('button', { name: 'Ready 20' })).toBeEnabled()
  expect(fetchMock).toHaveBeenCalledTimes(1)
})
