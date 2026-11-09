import { useSyncExternalStore, type ReactNode } from 'react'
import { AlertCircle, RefreshCw, WifiOff } from 'lucide-react'
import { Button } from './button'
import './async-state.css'

/** A bounded content placeholder. Real controls and page shells stay mounted around it. */
export function AsyncSkeleton({ label = 'Loading records…', rows = 4 }: { label?: string; rows?: number }) {
  return <div role="status" aria-label={label} className="grid gap-3 py-4"><span className="sr-only">{label}</span>{Array.from({ length: rows }, (_, index) => <div key={index} aria-hidden="true" className="grid grid-cols-[2fr_1fr_1fr] gap-4 border-b border-border-default py-3">{[0, 1, 2].map(column => <span key={column} className="h-4 rounded-control bg-surface-canvas motion-safe:animate-pulse" />)}</div>)}</div>
}

export function AsyncLoading({ label = 'Loading…', compact = false, framed = false, className = '' }: { label?: ReactNode; compact?: boolean; framed?: boolean; className?: string }) {
  return <div role="status" aria-live="polite" className={`mp-async-loading${compact ? ' mp-async-loading--compact' : ''}${framed ? ' mp-card' : ''} ${className}`}>
    <RefreshCw size={compact ? 18 : 24} aria-hidden="true" className="animate-spin motion-reduce:animate-none" />
    <p>{label}</p>
  </div>
}

export function RequestErrorState({ message, onRetry, kind = 'error', title, retryLabel = 'Try again' }: { message: string; onRetry?: () => void; kind?: 'error' | 'offline'; title?: string; retryLabel?: string }) {
  const Icon = kind === 'offline' ? WifiOff : AlertCircle
  return <div role="alert" className="mp-async-error mp-card">
    <Icon size={24} aria-hidden="true" />
    <div><h2>{title ?? (kind === 'offline' ? "You're offline" : 'Unable to load this section')}</h2><p>{message}</p></div>
    {onRetry && <Button variant="secondary" onClick={onRetry}><RefreshCw size={16} aria-hidden="true" />{retryLabel}</Button>}
  </div>
}

function subscribeConnection(notify: () => void) {
  window.addEventListener('online', notify)
  window.addEventListener('offline', notify)
  return () => { window.removeEventListener('online', notify); window.removeEventListener('offline', notify) }
}
const readConnection = () => navigator.onLine

/** A device connection hint only; server, provider and authorization errors keep their own messages. */
export function ConnectionNotice() {
  const online = useSyncExternalStore(subscribeConnection, readConnection, () => true)
  if (online) return null
  return <aside role="status" aria-live="polite" aria-atomic="true" className="mp-connection-notice">
    <WifiOff size={20} aria-hidden="true" /><div><p>You're offline</p><span>Reconnect to the internet, then try again. Your current view stays open.</span></div>
  </aside>
}
