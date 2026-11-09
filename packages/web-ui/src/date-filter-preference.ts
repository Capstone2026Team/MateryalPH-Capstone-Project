import { useMemo, useSyncExternalStore } from 'react'
import { isCalendarDate } from './calendar-dates'
import type { DateFilterRange } from './date-filter'

const STORAGE_KEY = 'materyalph:date-filter:v1'
const CHANGE_EVENT = 'materyalph:date-filter-changed'
let memoryPreference: string | null = null
let storageWriteFailed = false

function snapshot(): string | null {
  if (typeof window === 'undefined') return null
  if (storageWriteFailed) return memoryPreference
  try { return window.localStorage.getItem(STORAGE_KEY) } catch { return memoryPreference }
}

function parsePreference(raw: string | null): DateFilterRange | null {
  if (!raw) return null
  try {
    const value: unknown = JSON.parse(raw)
    if (!value || typeof value !== 'object' || !('label' in value) || !('from' in value) || !('to' in value)) return null
    const { label, from, to } = value
    if (typeof label !== 'string' || label.length > 120 || typeof from !== 'string' || typeof to !== 'string') return null
    if (from && !isCalendarDate(from) || to && !isCalendarDate(to) || from && to && from > to) return null
    return { label: from || to ? label : 'All dates', from, to }
  } catch { return null }
}

function subscribe(listener: () => void): () => void {
  const storage = (event: StorageEvent) => { if (event.key === STORAGE_KEY || event.key === null) listener() }
  window.addEventListener(CHANGE_EVENT, listener)
  window.addEventListener('storage', storage)
  return () => {
    window.removeEventListener(CHANGE_EVENT, listener)
    window.removeEventListener('storage', storage)
  }
}

export function useSavedDateFilterRange(): DateFilterRange | null {
  const raw = useSyncExternalStore(subscribe, snapshot, () => null)
  return useMemo(() => parsePreference(raw), [raw])
}

/** Store only the applied calendar selection; no account or authentication data. */
export function saveDateFilterRange(range: DateFilterRange): void {
  const selection = parsePreference(JSON.stringify({ label: range.label, from: range.from, to: range.to }))
  if (!selection) return
  memoryPreference = JSON.stringify(selection)
  try {
    window.localStorage.setItem(STORAGE_KEY, memoryPreference)
    storageWriteFailed = false
  } catch {
    storageWriteFailed = true
  }
  window.dispatchEvent(new Event(CHANGE_EVENT))
}
