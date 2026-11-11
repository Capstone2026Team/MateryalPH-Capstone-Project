import { createContext, useContext, forwardRef, useId, useState, type InputHTMLAttributes, type TextareaHTMLAttributes, type ReactNode } from 'react'

export const FormErrors = createContext<Record<string, string>>({})
const ControlScope = createContext('')
export function FormControlScope({ prefix, children }: { prefix: string; children: ReactNode }) {
  return <ControlScope.Provider value={prefix}>{children}</ControlScope.Provider>
}
export function useFormControlScope() { return useContext(ControlScope) }

export interface FieldProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string
  error?: string | undefined
  hint?: ReactNode
  startAdornment?: ReactNode
}

export const Field = forwardRef<HTMLInputElement, FieldProps>(
  ({ className = '', error, hint, startAdornment, id, label, required, type, ...props }, ref) => {
    const errors = useContext(FormErrors)
    error = error || errors[props.name ?? '']
    const generatedId = useId()
    const scope = useFormControlScope()
    const [visible, setVisible] = useState(false)
    const fieldId = scope + (id ?? props.name ?? generatedId)
    const descriptionId = error ? `${fieldId}-error` : hint ? `${fieldId}-hint` : undefined

    return (
      <div className="grid min-w-0 gap-2 text-sm font-semibold text-text-strong">
        <label htmlFor={fieldId}>
          {label} {required && <span className="text-status-error" aria-hidden="true">*</span>}
        </label>
        <div className="relative">
        {startAdornment && <span aria-hidden="true" className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-base font-normal text-text-secondary">{startAdornment}</span>}
        <input
          aria-describedby={descriptionId}
          aria-invalid={Boolean(error)}
          className={`min-h-12 w-full min-w-0 rounded-control border bg-surface-primary px-3 py-2 text-base font-normal text-text-strong transition-[border-color,box-shadow] motion-reduce:transition-none sm:min-h-11 placeholder:text-text-secondary focus:border-focus-ring focus:ring-2 focus:ring-focus-ring/20 disabled:cursor-not-allowed disabled:bg-surface-canvas disabled:opacity-60 ${startAdornment ? 'pl-8' : ''} ${type === 'password' ? 'pr-20' : ''} ${error ? 'border-status-error' : 'border-border-default'} ${className}`}
          id={fieldId}
          ref={ref}
          required={required}
          type={type === 'password' && visible ? 'text' : type}
          {...props}
        />
        {type === 'password' && <button type="button" className="absolute inset-y-0 right-0 min-h-12 min-w-16 rounded-control px-3 text-sm font-semibold text-action-primary disabled:opacity-50" disabled={props.disabled} aria-label={`${visible ? 'Hide' : 'Show'} ${label.toLowerCase()}`} aria-controls={fieldId} aria-pressed={visible} onClick={() => setVisible((value) => !value)}>{visible ? 'Hide' : 'Show'}</button>}
        </div>
        {error ? <span className="text-sm font-normal text-status-error" id={descriptionId} role="alert">{error}</span> : hint ? <span className="text-sm font-normal text-text-secondary" id={descriptionId}>{hint}</span> : null}
      </div>
    )
  },
)

Field.displayName = 'Field'

export function TextArea({ label, error, hint, id, className = '', ...props }: TextareaHTMLAttributes<HTMLTextAreaElement> & { label: string; error?: string; hint?: ReactNode }) {
  const generatedId = useId()
  const fieldId = id ?? generatedId
  const descriptionId = error || hint ? `${fieldId}-description` : undefined
  return <div className="grid min-w-0 gap-2 text-sm font-semibold text-text-strong">
    <label htmlFor={fieldId}>{label}</label>
    <textarea {...props} id={fieldId} aria-invalid={Boolean(error)} aria-describedby={descriptionId} className={`min-h-24 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 py-2 text-base font-normal text-text-strong focus:border-focus-ring focus:ring-2 focus:ring-focus-ring/20 disabled:opacity-60 ${className}`} />
    {(error || hint) && <span id={descriptionId} role={error ? 'alert' : undefined} className={`text-sm font-normal ${error ? 'text-status-error' : 'text-text-secondary'}`}>{error || hint}</span>}
  </div>
}
