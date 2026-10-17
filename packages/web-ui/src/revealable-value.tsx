import { useState } from 'react'
import { Eye, EyeOff } from 'lucide-react'

/**
 * A private identifier (for example the store's TIN) that stays masked until its Owner asks to see it. The full
 * value is fetched only on that explicit action, held in component state while shown, and discarded when hidden
 * or unmounted, so it is never cached, persisted or rendered by default.
 */
export function RevealableValue({ masked, label, reveal, readError }: {
  masked: string
  /** Names the identifier for assistive technology, for example "TIN". */
  label: string
  reveal: () => Promise<string>
  readError?: (error: unknown) => string | Promise<string>
}) {
  const [value, setValue] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const shown = value !== null
  async function toggle() {
    setError('')
    if (shown) { setValue(null); return }
    setBusy(true)
    try { setValue(await reveal()) }
    catch (failure) { setError(readError ? await readError(failure) : `The ${label} could not be shown. Try again.`) }
    finally { setBusy(false) }
  }
  return <span className="inline-flex min-w-0 flex-wrap items-center gap-x-1">
    <span className="tabular-nums" aria-live="polite">{shown ? value : masked}</span>
    <button type="button" aria-label={`${shown ? 'Hide' : 'Show'} ${label}`} aria-pressed={shown} disabled={busy} onClick={() => void toggle()}
      className="-my-3 inline-flex size-11 shrink-0 items-center justify-center rounded-control text-text-secondary hover:text-text-strong focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring disabled:cursor-wait disabled:opacity-60">
      {shown ? <EyeOff size={18} aria-hidden="true" /> : <Eye size={18} aria-hidden="true" />}
    </button>
    {error && <span role="alert" className="basis-full text-xs font-medium text-status-error">{error}</span>}
  </span>
}
