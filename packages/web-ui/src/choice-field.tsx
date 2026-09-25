import { useId } from 'react'

type Choice = { value: string; label: string; description: string }

export function ChoiceField({ legend, description, name, value, options, onChange, required = false }: {
  legend: string
  description: string
  name: string
  value: string
  options: Choice[]
  onChange: (value: string) => void
  required?: boolean
}) {
  const id = useId()
  return <fieldset aria-describedby={`${id}-description`} className="min-w-0">
    <legend className="text-lg font-semibold text-text-strong">{legend}</legend>
    <p id={`${id}-description`} className="mt-2 text-sm leading-6 text-text-secondary">{description}</p>
    <div className={`mt-4 grid gap-3 ${options.length === 3 ? 'lg:grid-cols-3' : 'sm:grid-cols-2'}`}>
      {options.map(option => <label key={option.value} className={`flex min-h-11 cursor-pointer items-start gap-3 rounded-control border p-4 focus-within:ring-2 focus-within:ring-focus-ring ${value === option.value ? 'border-action-primary bg-surface-primary' : 'border-border-default bg-surface-primary hover:border-action-primary'}`}>
        <input className="mt-0.5 h-5 w-5 shrink-0 accent-action-primary" type="radio" name={name} value={option.value} checked={value === option.value} required={required} onChange={() => onChange(option.value)} aria-labelledby={`${id}-${option.value}-label`} aria-describedby={`${id}-${option.value}-description`} />
        <span className="min-w-0"><span id={`${id}-${option.value}-label`} className="block font-semibold text-text-strong">{option.label}</span><span id={`${id}-${option.value}-description`} className="mt-1 block text-sm leading-6 text-text-secondary">{option.description}</span></span>
      </label>)}
    </div>
  </fieldset>
}
