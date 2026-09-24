import { Button } from './button'
import { ChecklistPanel, checklistLabel, verificationChecklist, type ChecklistRequirement } from './verification-checklist'

export type ReviewRequirement = ChecklistRequirement
export function OnboardingReview({ groups, onJump, unsaved, pending, busy = false }: {
  groups: { label: string; items: ReviewRequirement[] }[]; onJump: (index: number) => void
  unsaved: string[]; pending: string[]; busy?: boolean
}) {
  const requirements = groups.flatMap(group => group.items)
  const items = verificationChecklist(requirements)
  function jump(key: string) { onJump(Math.max(0, groups.findIndex(group => group.items.some(item => item.key === key)))) }
  return <div className="mt-6 min-w-0 space-y-5">
    <ChecklistPanel title="Verification checklist" items={items}
      renderAction={item => item.key !== 'business_information_group' && <Button variant="quiet" disabled={busy} onClick={() => jump(item.requirements[0]!.key)} aria-label={`Review ${item.label}`}>Review</Button>}
      renderDetails={item => item.key === 'business_information_group' ? <div className="mt-4 grid gap-3 sm:grid-cols-2">{item.requirements.map(requirement => <div key={requirement.key} className="min-w-0 border-l-2 border-border-default pl-3">
        <p className="text-sm font-medium">{requirement.label}</p><p className="text-sm text-text-secondary">{checklistLabel(requirement.status)}</p>
        <Button variant="quiet" disabled={busy} onClick={() => jump(requirement.key)} aria-label={`Review ${requirement.label}`}>Review</Button>
      </div>)}</div> : null} />
    <div className="grid gap-3 text-sm" aria-live="polite"><h4 className="font-semibold">Unsaved edits</h4>{unsaved.length ? <><p>These edits will save automatically before submission.</p><ul className="list-inside list-disc">{unsaved.map(item => <li key={item}>{item}</li>)}</ul></> : <p className="text-text-secondary">No unsaved edits.</p>}
    {pending.length > 0 && <><h4 className="font-semibold">Saved progress awaiting submission</h4><p className="text-text-secondary">Your draft and pending documents are private. Submit for Admin Review sends them together.</p></>}</div>
  </div>
}
