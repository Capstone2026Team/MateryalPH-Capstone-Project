import { useRef, useState } from 'react'
import { Button } from './button'
import { Field } from './field'

export function CustomLabelInput({ values, onChange, name = 'custom_labels' }: { values: string[]; onChange: (values: string[]) => void; name?: string }) {
  const [draft, setDraft] = useState('')
  const [error, setError] = useState('')
  const input = useRef<HTMLInputElement>(null)
  function add() {
    const label = draft.trim().replace(/\s+/g, ' ')
    if (label.length < 2 || label.length > 60) { setError('Use 2–60 characters for each category.'); input.current?.focus(); return }
    if (!label) { setError('Enter a category name.'); input.current?.focus(); return }
    if (values.some(value => value.toLowerCase() === label.toLowerCase())) { setError('This category is already added.'); return }
    onChange([...values, label]); setDraft(''); setError(''); input.current?.focus()
  }
  return <div className="grid min-w-0 gap-3">
    <div className="grid items-start gap-3 sm:grid-cols-[minmax(0,1fr)_auto]">
      <Field ref={input} label="Other category" value={draft} maxLength={60} error={error} placeholder="Enter a construction-material category" onChange={event => { setDraft(event.target.value); setError('') }} onKeyDown={event => { if (event.key === 'Enter') { event.preventDefault(); add() } }} />
      <Button variant="secondary" className="min-h-12 sm:mt-7" onClick={add}>Add category</Button>
    </div>
    <p className="text-sm text-text-secondary">Add each category separately. These are your custom labels, not new marketplace categories.</p>
    {values.length > 0 && <ul className="flex flex-wrap gap-2" aria-label="Added custom categories">{values.map(value => <li key={value} className="flex max-w-full items-center gap-2 rounded-control border border-border-default bg-surface-canvas pl-3"><span className="min-w-0 break-words text-sm">{value}</span><input type="hidden" name={name} value={value} /><Button variant="quiet" aria-label={`Remove ${value}`} onClick={() => onChange(values.filter(item => item !== value))}>Remove</Button></li>)}</ul>}
  </div>
}
