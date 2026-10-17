import { useCallback, useEffect, useRef, useState } from 'react'
import { ResponseError } from '@materyalph/api-client-ts'
import { saveVariants, updateListing, type CatalogListing } from './catalog-api'
import { detailsUpdate, rowsFromListing, variantClientErrors, variantInputs, type DetailsForm, type VariantRow } from './catalog-form'

/**
 * Instant saving for the listing editor. Edits are written to the draft shortly after the Vendor stops typing, one
 * write at a time, and the page keeps showing what was typed while the server answers. Two situations are never
 * saved automatically, because the write itself has consequences for Buyers or for verified evidence:
 *  - a live (ACTIVE) listing: every save is republished to Buyers, so half-typed names or prices must not go out;
 *  - a regulated listing whose PS/ICC evidence is verified or under review: changing the material, brand, model,
 *    manufacturer, address or country withdraws that status.
 * Those use `manual` mode: the same status line, saved when the Vendor chooses Save changes.
 */
export const autosaveTiming = { delayMs: 1500, retryMs: 8000 }

export type AutosaveMode = 'auto' | 'manual' | 'off'
export type SaveStatus =
  | { kind: 'saved'; at: Date | null }
  | { kind: 'pending' }
  | { kind: 'saving' }
  | { kind: 'incomplete'; reason: string }
  | { kind: 'error'; message: string }

/** Why a listing is saved by hand, or null when it saves itself. */
export function manualSaveReason(listing: CatalogListing): 'LIVE' | 'REGULATED' | null {
  if (listing.status === 'ACTIVE') return 'LIVE'
  if (listing.regulated && (listing.complianceStatus === 'VERIFIED' || listing.complianceStatus === 'PENDING_ADMIN_REVIEW')) return 'REGULATED'
  return null
}

const detailsKey = (form: DetailsForm) => JSON.stringify(detailsUpdate(form, 0))
const rowsKey = (rows: VariantRow[]) => JSON.stringify(variantInputs(rows))

type Options = {
  listing: CatalogListing | null
  form: DetailsForm | null
  rows: VariantRow[]
  mode: AutosaveMode
  /** True while another write (photo, publication) is running, so two writes never race on the lock version. */
  paused: boolean
  /** Receives each saved listing; `merge` carries the rows that were sent and the server's view of them. */
  onSaved: (listing: CatalogListing, merge: { sent: VariantRow[]; saved: VariantRow[] } | null) => void
  /** Maps a failure to the message shown to the Vendor and records field errors or a conflict. */
  onError: (cause: unknown) => Promise<string>
}

export function useListingAutosave({ listing, form, rows, mode, paused, onSaved, onError }: Options) {
  const [status, setStatus] = useState<SaveStatus>({ kind: 'saved', at: null })
  const latest = useRef({ form, rows, mode, onSaved, onError })
  const base = useRef<{ details: string; variants: string; rows: VariantRow[] } | null>(null)
  const current = useRef<CatalogListing | null>(listing)
  const inFlight = useRef<Promise<boolean> | null>(null)
  const again = useRef(false)
  const stopped = useRef(false)
  const timer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined)

  useEffect(() => {
    latest.current = { form, rows, mode, onSaved, onError }
    if (listing && (current.current?.id !== listing.id || listing.lockVersion >= current.current.lockVersion)) current.current = listing
  })

  /** Treats a form and rows as exactly what the server holds, for example right after a load. */
  const reset = useCallback((nextForm: DetailsForm, nextRows: VariantRow[]) => {
    base.current = { details: detailsKey(nextForm), variants: rowsKey(nextRows), rows: nextRows }
    window.clearTimeout(timer.current)
    setStatus({ kind: 'saved', at: null })
  }, [])

  const isDirty = useCallback(() => {
    const { form: nowForm, rows: nowRows } = latest.current
    return Boolean(nowForm && base.current && (detailsKey(nowForm) !== base.current.details || rowsKey(nowRows) !== base.current.variants))
  }, [])

  const save = useCallback((): Promise<boolean> => {
    if (stopped.current) return Promise.resolve(true)
    if (inFlight.current) { again.current = true; return inFlight.current }
    const task = (async () => {
      let ok = true
      do {
        again.current = false
        const { form: sentForm, rows: sentRows, onSaved: saved, onError: failed } = latest.current
        const baseline = base.current
        if (!sentForm || !baseline || !current.current) break
        const detailsChanged = detailsKey(sentForm) !== baseline.details
        const variantsChanged = rowsKey(sentRows) !== baseline.variants
        if (!detailsChanged && !variantsChanged) break
        setStatus({ kind: 'saving' })
        let incomplete: string | null = null
        try {
          let working = current.current
          if (detailsChanged) {
            working = await updateListing(working.id, detailsUpdate(sentForm, working.lockVersion))
            current.current = working
            base.current = { ...baseline, details: detailsKey(sentForm) }
            saved(working, null)
          }
          if (variantsChanged) {
            const problems = Object.values(variantClientErrors(sentRows))
            if (problems.length) incomplete = problems[0] ?? 'Finish the highlighted variant fields.'
            else {
              working = await saveVariants(working.id, working.lockVersion, variantInputs(sentRows, baseline.rows))
              current.current = working
              const savedRows = rowsFromListing(working)
              const sentWithIds = sentRows.map((row, index) => { const id = savedRows[index]?.id; return id ? { ...row, id } : row })
              base.current = { details: base.current?.details ?? baseline.details, variants: rowsKey(sentWithIds), rows: sentWithIds }
              saved(working, { sent: sentRows, saved: savedRows })
            }
          }
          setStatus(incomplete ? { kind: 'incomplete', reason: incomplete } : isDirty() ? { kind: 'pending' } : { kind: 'saved', at: new Date() })
        } catch (cause) {
          ok = false
          const message = await failed(cause)
          setStatus({ kind: 'error', message })
          // A temporary network or server fault is retried; a rejected value or a conflict waits for the Vendor.
          if (!(cause instanceof ResponseError) || cause.response.status >= 500) timer.current = setTimeout(() => void save(), autosaveTiming.retryMs)
          break
        }
      } while (again.current)
      return ok
    })().finally(() => { inFlight.current = null })
    inFlight.current = task
    return task
  }, [isDirty])

  // Schedules a save after each edit while automatic saving is on.
  useEffect(() => {
    if (!form || !base.current) return
    if (!isDirty()) return
    setStatus(previous => previous.kind === 'saving' ? previous : { kind: 'pending' })
    if (mode !== 'auto' || paused) return
    window.clearTimeout(timer.current)
    timer.current = setTimeout(() => void save(), autosaveTiming.delayMs)
    return () => window.clearTimeout(timer.current)
  }, [form, rows, mode, paused, isDirty, save])

  /** Writes any pending edits now. Resolves false when the write failed. */
  const flush = useCallback(async (): Promise<boolean> => {
    window.clearTimeout(timer.current)
    if (inFlight.current) await inFlight.current
    return isDirty() && latest.current.mode === 'auto' ? save() : true
  }, [isDirty, save])

  /** Stops saving and waits for a write already running, for example before the listing is deleted. */
  const stop = useCallback(async () => {
    stopped.current = true
    window.clearTimeout(timer.current)
    if (inFlight.current) await inFlight.current
  }, [])
  const resume = useCallback(() => { stopped.current = false }, [])
  const lockVersion = useCallback(() => current.current?.lockVersion ?? null, [])

  // A Vendor leaving the editor does not lose the last edits.
  useEffect(() => () => { if (latest.current.mode === 'auto' && isDirty()) void save() }, [isDirty, save])

  const unsaved = status.kind !== 'saved'
  useEffect(() => {
    if (!unsaved) return
    const warn = (event: BeforeUnloadEvent) => { event.preventDefault(); event.returnValue = '' }
    window.addEventListener('beforeunload', warn)
    return () => window.removeEventListener('beforeunload', warn)
  }, [unsaved])

  return { status, reset, flush, saveNow: save, isDirty, stop, resume, lockVersion }
}
