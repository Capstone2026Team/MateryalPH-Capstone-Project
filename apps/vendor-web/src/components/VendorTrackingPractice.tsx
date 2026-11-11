import { useEffect, useRef, useState } from 'react'
import { TutorialPractice, VendorTeamActivity, type PracticeStep } from '@materyalph/web-ui'
import { sampleActivity, sampleError, sampleMembers, samplePerformance, sampleWatch } from '../lib/vendor-tutorial-samples'

const steps: PracticeStep[] = [
  { title: 'Meet the sample team account', description: 'Demo Inventory Staff is a fictional account, not an invitation or a real employee. The first permitted account opens automatically. Search and Current role narrow the list; selecting a person changes the workspace.', target: '.team-tracking-sidebar' },
  { title: 'Read attributed statistics', description: 'These example cards count successful stock changes, listing changes and compliance submissions recorded for this Inventory Staff account. Rejected attempts remain separate. Other fixed roles have different work measures.', target: '.mp-metric-card' },
  { title: 'Follow the activity trend', description: 'The chart groups this sample employee’s product and stock changes by the displayed day or month. Tracking period changes the reporting dates; an empty real period means no matching recorded work.', target: '.mp-dashboard-panel' },
  { title: 'Review the work-area breakdown', description: 'Products and inventory separates stock counts, confirmations, listing edits and other recorded inventory work. These are example totals for one employee, not your store’s stock or an organization-wide report.', target: '.mp-card-group .mp-dashboard-panel' },
  { title: 'Open the recorded history', description: 'Activity history lists individual actions, their Manila timestamps and success or failure. Expand Record details on this sample event to see its previous and new values and role at the time. Real audit entries cannot be edited or deleted.', target: '[aria-label="Activity history"]' },
  { title: 'Understand the fixed role', description: 'Role responsibilities explains what the selected account’s current role may do and which work Statistics measures. Activity history retains the role held when an action happened. This tutorial never creates or grants a team account.', target: '[aria-label="Role responsibilities"]' },
]
export default function VendorTrackingPractice({ onClose }: { onClose: (completed: boolean) => void }) {
  const [step, setStep] = useState(0)
  const root = useRef<HTMLDivElement>(null)
  useEffect(() => {
    const label = step === 4 ? 'Activity history' : step === 5 ? 'Role responsibilities' : 'Statistics'
    const choose = () => [...root.current?.querySelectorAll<HTMLButtonElement>('nav[aria-label="Tracking views"] button') ?? []].find(button => button.textContent === label)?.click()
    choose()
    const timer = window.setTimeout(choose, 50)
    return () => window.clearTimeout(timer)
  }, [step])
  return <TutorialPractice title="Practice Team Tracking" steps={steps} step={step} onStep={setStep} onClose={onClose}><div ref={root}><VendorTeamActivity list={sampleActivity} performance={samplePerformance} listMembers={sampleMembers} canManageManagers={false} explainError={sampleError} watchUpdates={sampleWatch} persistDateSelection={false} /></div></TutorialPractice>
}
