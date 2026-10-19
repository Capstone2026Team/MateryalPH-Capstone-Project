import type { ConversationPage } from '@materyalph/api-client-ts'
import { Button } from './button'
import { CountBadge } from './count-badge'

/** Project navigation only; every row retains its own server-authorized conversation. */
export function ProjectInquiryList({ result, onSelect, onPage }: {
  result: ConversationPage; onSelect: (id: string) => void; onPage: (page: number) => void
}) {
  return <>
    {result.items.length === 0 && <p className="py-8 text-sm text-text-secondary">No open project quotation inquiries.</p>}
    <ul aria-label="Project inquiries" className="divide-y divide-border-default">
      {result.items.map(row => <li key={row.id}><button type="button" className="flex min-h-11 w-full items-center justify-between gap-3 rounded-control p-4 text-left hover:bg-surface-canvas" onClick={() => onSelect(row.id)}>
        <span className="grid min-w-0 gap-1"><strong className="text-sm text-text-strong">{row.inquiryLabel ?? 'Project inquiry'}</strong><span className="break-words text-sm text-text-secondary">{row.lastMessagePreview || 'Open project conversation'}</span></span>
        <CountBadge count={row.unreadCount} />{row.unreadCount > 0 && <span className="sr-only">{row.unreadCount} unread messages</span>}
      </button></li>)}
    </ul>
    <nav aria-label="Project inquiry pages" className="mt-4 flex items-center justify-between gap-3">
      <Button variant="quiet" disabled={result.page === 1} onClick={() => onPage(result.page - 1)}>Previous</Button><span className="text-xs">Page {result.page}</span>
      <Button variant="quiet" disabled={!result.hasMore} onClick={() => onPage(result.page + 1)}>Next</Button>
    </nav>
  </>
}
