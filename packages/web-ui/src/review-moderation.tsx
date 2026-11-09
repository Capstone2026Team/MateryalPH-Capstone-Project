import './review-moderation.css'
import { QueueLoadingState } from './queue-workspace'

/** Both list and detail requests use the shared bounded loading treatment. */
export function ModerationLoadingState({ detail = false }: { detail?: boolean }) {
  if (!detail) return <QueueLoadingState label="Loading reviews…" />
  return <div className="mp-card"><QueueLoadingState label="Loading review details…" /></div>
}
