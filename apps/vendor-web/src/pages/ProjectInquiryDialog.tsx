import { useEffect, useState } from 'react'
import type { ConversationPage } from '@materyalph/api-client-ts'
import { Button, FormDialog, ProjectInquiryList } from '@materyalph/web-ui'
import { chatApi, readableChatError, watchConversation } from '../lib/messaging-api'
import { ErrorState, LoadingState } from './PhaseThreeVendorPages'
import { ConversationThread } from './ConversationThread'

export function ProjectInquiryDialog({ inquiryId, role, onClose }: { inquiryId: string; role: string; onClose: () => void }) {
  const [selected, setSelected] = useState<string | null>(null)
  const [page, setPage] = useState(1)
  const [result, setResult] = useState<ConversationPage | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [busy, setBusy] = useState(false)
  useEffect(() => {
    if (selected) return
    let active = true
    let running = false
    let pending = false
    const refresh = async () => {
      if (!active) return
      if (running) { pending = true; return }
      running = true
      try { const value = await chatApi.projectInquiries(inquiryId, page); if (active) { setResult(value); setError(null) } }
      catch (cause) { const message = await readableChatError(cause); if (active) setError(message) }
      finally { running = false; if (active && pending) { pending = false; void refresh() } }
    }
    void refresh()
    let stop: (() => void) | undefined
    let live = false
    let quiet = 0
    void watchConversation(null, () => void refresh(), undefined, undefined, value => { live = value }).then(close => { if (active) stop = close; else close() })
    const timer = window.setInterval(() => { quiet++; if (document.visibilityState === 'visible' && (!live || quiet >= 11)) { quiet = 0; void refresh() } }, 4000)
    return () => { active = false; stop?.(); window.clearInterval(timer) }
  }, [inquiryId, page, selected, attempt])

  return <FormDialog open title="Project inquiries" description="Open quotation inquiries for current Work Packages. Each inquiry keeps its own conversation and quotation history." busy={busy} onClose={onClose} footer={null} bodyClassName="flex h-[min(44rem,75dvh)] min-h-0 flex-col overflow-hidden">
    {selected ? <>
      <div className="shrink-0 border-b border-border-default px-4"><Button variant="quiet" disabled={busy} onClick={() => setSelected(null)}>Back to project inquiries</Button></div>
      <ConversationThread key={selected} selected={selected} role={role} onBusyChange={setBusy} />
    </> : <div className="min-h-0 overflow-y-auto p-5">
      {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !result || result.page !== page ? <LoadingState label="Loading project inquiries…" /> : <ProjectInquiryList result={result} onSelect={setSelected} onPage={setPage} />}
    </div>}
  </FormDialog>
}
