export type JsonRecord = Record<string, unknown>

export function record(value: unknown): JsonRecord {
  return typeof value === 'object' && value !== null && !Array.isArray(value) ? value as JsonRecord : {}
}

export function records(value: unknown): JsonRecord[] {
  return Array.isArray(value) ? value.map(record) : []
}

export function stringValue(value: unknown, fallback = ''): string {
  return typeof value === 'string' ? value : fallback
}

export function numberValue(value: unknown, fallback = 0): number {
  return typeof value === 'number' && Number.isFinite(value) ? value : fallback
}

export function statusTone(status: string): 'neutral' | 'warning' | 'success' | 'error' | 'info' {
  if (['APPROVED', 'COMPLETED', 'COMPLETE', 'ACTIVE', 'CONNECTED', 'READY'].includes(status)) return 'success'
  if (['CHANGES_REQUIRED', 'IN_PROGRESS', 'PENDING_VERIFICATION', 'PENDING', 'NOT_READY', 'UNVERIFIED'].includes(status)) return 'warning'
  if (['REJECTED', 'EXPIRED', 'FAILED', 'RESTRICTED', 'SUSPENDED'].includes(status)) return 'error'
  if (status === 'SUBMITTED') return 'info'
  return 'neutral'
}

export function statusLabel(status: string): string {
  return status.replaceAll('_', ' ').toLowerCase().replace(/(^|\s)\S/g, (letter) => letter.toUpperCase())
}

export function formatDate(value: unknown): string {
  if (value instanceof Date && !Number.isNaN(value.valueOf())) return new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeZone: 'Asia/Manila' }).format(value)
  if (typeof value === 'string' && value) return new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeZone: 'Asia/Manila' }).format(new Date(value))
  return 'Not recorded'
}
