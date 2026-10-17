import { Field } from './field'

/** Product details use ordinary inputs while retaining their original specification names. */
export function SpecificationFields({ value, variantLabel, disabled = false, onChange }: {
  value: Record<string, string>
  variantLabel: string
  disabled?: boolean
  onChange: (value: Record<string, string>) => void
}) {
  const entries = Object.entries(value)
  return <fieldset className="grid min-w-0 gap-3 sm:grid-cols-2 lg:grid-cols-3">
    <legend className="sr-only">Product specifications</legend>
    {variantLabel && !Object.hasOwn(value, 'Variant') && <p className="text-xs text-text-secondary sm:col-span-2 lg:col-span-3"><span className="font-semibold">Variant:</span> {variantLabel}</p>}
    {entries.map(([name, detail]) => <Field key={name} label={name.replace(/[_-]+/g, ' ').replace(/^./, letter => letter.toUpperCase())} value={detail} maxLength={200} disabled={disabled} onChange={event => onChange({ ...value, [name]: event.target.value })} />)}
    {!variantLabel && entries.length === 0 && <p className="text-sm text-text-secondary sm:col-span-2 lg:col-span-3">Specifications come from the selected product variant.</p>}
  </fieldset>
}
