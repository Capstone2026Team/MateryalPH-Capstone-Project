import { useState, type ReactNode } from 'react'

export function StatusMessage({ children, tone = 'info', dismissLabel }: { children: ReactNode; tone?: 'info' | 'error' | 'success'; dismissLabel?: string }) {
  const [dismissed, setDismissed] = useState(false)
  if (dismissed) return null
  const toneClass = tone === 'error'
    ? 'border-status-error/30 bg-red-50 text-red-900'
    : tone === 'success'
      ? 'border-status-success/30 bg-green-50 text-green-900'
      : 'border-status-info/30 bg-blue-50 text-blue-900'

  return <div className={`rounded-surface border px-4 py-3 text-sm ${toneClass}`} role={tone === 'error' ? 'alert' : 'status'}>{dismissLabel ? <div className="flex items-start gap-3"><span aria-hidden="true" className="pt-3">ⓘ</span><div className="min-w-0 flex-1">{children}</div><button type="button" aria-label={dismissLabel} className="min-h-11 min-w-11 rounded-control text-lg focus-visible:outline-2 focus-visible:outline-focus-ring" onClick={() => setDismissed(true)}>×</button></div> : children}</div>
}
