import { type ReactNode } from 'react'
import { StatusBadge } from './portal-shell'

export type ChecklistRequirement = { key: string; label: string; level: string; status: string; reason?: string | null }
export type ChecklistItem<T extends ChecklistRequirement = ChecklistRequirement> = ChecklistRequirement & { requirements: T[] }

const definitions = [
  { key: 'business_information_group', label: 'Business information', keys: ['business_type', 'business_information', 'legal_identity', 'registered_business_address', 'supplier_classification', 'tax_profile', 'authority_to_act', 'privacy_acknowledgement'] },
  { key: 'legal_identity_id', label: 'Government ID — Registered legal identity', keys: ['identity_evidence', 'identity_back_evidence'] },
  { key: 'representative_id', label: 'Government ID — Authorized Representative', keys: ['representative_identity', 'representative_identity_back'] },
  { key: 'tax_relief_evidence', label: 'Sworn Declaration', keys: ['tax_relief_evidence'] },
  { key: 'bir_cor', label: 'BIR Certificate of Registration (BIR Form 2303)', keys: ['bir_cor'] },
  { key: 'business_registration', label: 'Business registration', keys: ['business_registration'] },
  { key: 'lgu_permit', label: 'LGU permit evidence', keys: ['lgu_permit'] },
]

export function checklistStatus(items: ChecklistRequirement[]): string {
  const active = items.filter(item => item.status !== 'NOT_APPLICABLE')
  if (!active.length) return 'NOT_APPLICABLE'
  for (const status of ['REJECTED', 'CHANGES_REQUIRED', 'EXPIRED', 'NOT_STARTED', 'IN_PROGRESS', 'PENDING_VERIFICATION']) {
    if (active.some(item => item.status === status)) return status
  }
  return active.every(item => ['APPROVED', 'COMPLETED'].includes(item.status)) ? 'COMPLETED' : 'IN_PROGRESS'
}

export function verificationChecklist<T extends ChecklistRequirement>(requirements: T[], options: { separateAuthority?: boolean } = {}): ChecklistItem<T>[] {
  const adminGroups = [
    { ...definitions[0]!, keys: definitions[0]!.keys.filter(key => key !== 'authority_to_act') },
    ...definitions.slice(1, 3),
    { key: 'authority_to_act', label: 'Authority to Act', keys: ['authority_to_act'] },
    ...definitions.slice(3),
  ]
  const groups = options.separateAuthority ? [
    ...adminGroups,
    ...requirements.filter(item => item.level !== 'OPTIONAL' && !adminGroups.some(group => group.keys.includes(item.key)))
      .map(item => ({ key: item.key, label: item.label, keys: [item.key] })),
  ] : definitions
  return groups.flatMap(group => {
    const items = requirements.filter(item => (group.keys.includes(item.key) || (!options.separateAuthority && group.key === 'business_information_group' && item.level !== 'OPTIONAL' && !groups.some(definition => definition.keys.includes(item.key)))) && item.status !== 'NOT_APPLICABLE')
    items.sort((a, b) => (group.keys.indexOf(a.key) < 0 ? group.keys.length : group.keys.indexOf(a.key)) - (group.keys.indexOf(b.key) < 0 ? group.keys.length : group.keys.indexOf(b.key)))
    if (!items.length) return []
    const reasons = items.flatMap(item => checklistReason(item) ? [`${item.label}: ${checklistReason(item)}`] : [])
    return [{ reason: reasons.join(' '), key: group.key, label: group.label, level: items.some(item => item.level === 'REQUIRED') ? 'REQUIRED' : 'CONDITIONALLY_REQUIRED', status: checklistStatus(items), requirements: items }]
  })
}

export const checklistLabel = (value: string) => value.replaceAll('_', ' ').toLowerCase().replace(/^./, character => character.toUpperCase())
export function checklistReason(item: ChecklistRequirement): string | null {
  if (!item.reason || /^Approval is required for /.test(item.reason)) return null
  return item.reason
}

export function ChecklistPanel({ title, items, children, renderDetails, renderAction, compact = false, selectedKey }: {
  title: string; items: ChecklistItem[]; children?: ReactNode
  compact?: boolean
  selectedKey?: string | undefined
  renderDetails?: (item: ChecklistItem) => ReactNode
  renderAction?: (item: ChecklistItem) => ReactNode
}) {
  return <section aria-label={title} className={`min-w-0 rounded-surface border border-border-default bg-surface-primary ${compact ? 'p-4' : 'p-5 sm:p-6'}`}>
    <h3 className="text-lg font-semibold">{title}</h3>
    {children}
    {items.length ? <ul className={compact ? 'mt-3 grid gap-2 sm:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-5' : 'mt-4 divide-y divide-border-default'}>{items.map(item => <li key={item.key} className={compact ? `min-w-0 rounded-control border p-3 ${selectedKey === item.key ? 'border-action-primary bg-brand-orange-50' : 'border-border-default'}` : 'min-w-0 py-4'}>
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className={`min-w-0 flex-1 ${compact ? 'text-sm' : 'basis-52'}`}><p className="font-semibold">{item.label}</p>{compact && <p className="mt-1 text-xs text-text-secondary">{checklistLabel(item.status)}</p>}
          {!compact && ['legal_identity_id', 'representative_id'].includes(item.key) && <p className="mt-1 text-sm text-text-secondary">{item.requirements.some(requirement => requirement.key.includes('back')) ? 'Front and back of the same ID' : 'Front / identity page'}</p>}
          {checklistReason(item) && <p className="mt-1 text-sm text-text-secondary">{checklistReason(item)}</p>}
        </div>
        <div className="flex flex-wrap items-center gap-2">{!compact && <StatusBadge label={checklistLabel(item.status)} />}{renderAction?.(item)}</div>
      </div>
      {renderDetails?.(item)}
    </li>)}</ul> : <p className="mt-3 text-sm text-text-secondary">No applicable requirements are available. Refresh to check your progress.</p>}
  </section>
}


export function checklistProgress(section: { key: string; steps: ChecklistRequirement[] }) {
  const items = section.key === 'STORE_VERIFICATION' ? verificationChecklist(section.steps) : section.steps.filter(item => item.status !== 'NOT_APPLICABLE')
  return { total: items.length, complete: items.filter(item => ['APPROVED', 'COMPLETED'].includes(item.status)).length }
}
