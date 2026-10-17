/** Count meaning belongs to the control's accessible label; visual labels stay compact. */
export function CountBadge({ count, className = '' }: { count: number; className?: string }) {
  if (!Number.isSafeInteger(count) || count <= 0) return null
  return <span aria-hidden="true" className={`portal-count-badge ${className}`}>{count > 99 ? '99+' : count}</span>
}
