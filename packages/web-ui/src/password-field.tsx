import { Check } from 'lucide-react'
import { forwardRef, useContext, useId, useState, type ChangeEvent, type ReactNode } from 'react'
import { Field, FormErrors, type FieldProps } from './field'

export interface PasswordRequirement {
  id: 'length' | 'uppercase' | 'lowercase' | 'number'
  label: string
  met: boolean
}

/** Mirrors the API rule `Password::min(n)->mixedCase()->numbers()`; the server stays authoritative. */
export function passwordRequirements(value: string, minLength: number): PasswordRequirement[] {
  return [
    { id: 'length', label: `Must be a minimum of ${minLength} characters in length`, met: [...value].length >= minLength },
    { id: 'uppercase', label: 'Must contain at least 1 uppercase letter', met: /\p{Lu}/u.test(value) },
    { id: 'lowercase', label: 'Must contain at least 1 lowercase letter', met: /\p{Ll}/u.test(value) },
    { id: 'number', label: 'Must contain at least 1 number', met: /\p{N}/u.test(value) },
  ]
}

export interface PasswordFieldProps extends Omit<FieldProps, 'hint' | 'type' | 'minLength'> {
  minLength: number
  /** Extra guidance shown above the requirement list, such as the existing-account case. */
  note?: ReactNode
}

export const PasswordField = forwardRef<HTMLInputElement, PasswordFieldProps>(
  ({ minLength, note, id, name, error, onChange, ...props }, ref) => {
    const generatedId = useId()
    const errors = useContext(FormErrors)
    const [value, setValue] = useState('')
    const fieldId = id ?? name ?? generatedId
    const listId = `${fieldId}-requirements`
    const requirements = passwordRequirements(value, minLength)
    const hasError = Boolean(error || errors[name ?? ''])

    function handleChange(event: ChangeEvent<HTMLInputElement>) {
      setValue(event.target.value)
      onChange?.(event)
    }

    return (
      <div className="grid min-w-0 gap-2">
        <Field
          {...props}
          aria-describedby={hasError ? `${fieldId}-error ${listId}` : listId}
          error={error}
          id={fieldId}
          minLength={minLength}
          name={name}
          onChange={handleChange}
          ref={ref}
          type="password"
        />
        {note && <p className="text-sm font-normal text-text-secondary">{note}</p>}
        <ul aria-label="Requirements for this password" className="grid gap-1.5 text-sm font-normal" id={listId}>
          {requirements.map(requirement => (
            <li className={`flex items-start gap-2 ${requirement.met ? 'text-text-strong' : 'text-text-secondary'}`} key={requirement.id}>
              <span aria-hidden="true" className={`mt-0.5 grid size-4 shrink-0 place-items-center rounded-full border ${requirement.met ? 'border-status-success bg-status-success text-white' : 'border-border-default'}`}>
                {requirement.met && <Check size={11} strokeWidth={3.5} />}
              </span>
              <span>{requirement.label}<span className="sr-only">{requirement.met ? ' (met)' : ' (not met)'}</span></span>
            </li>
          ))}
        </ul>
      </div>
    )
  },
)

PasswordField.displayName = 'PasswordField'
