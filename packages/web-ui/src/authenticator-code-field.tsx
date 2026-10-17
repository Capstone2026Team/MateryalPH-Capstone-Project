import { useContext, useEffect, useId, useRef, useState } from 'react'
import { FormErrors } from './field'

type Props = { label: string; name: string; id?: string; required?: boolean; disabled?: boolean; error?: string; hint?: string; autoFocus?: boolean }

/** One native field preserves autofill, selection, validation and form submission. */
export function AuthenticatorCodeField({ label, name, id, required = false, disabled = false, error, hint = 'Enter the current code from your app, or paste all 6 digits.', autoFocus = false }: Props) {
  const errors = useContext(FormErrors)
  const generatedId = useId()
  const fieldId = id ?? name ?? generatedId
  const message = error || errors[name]
  const descriptionId = `${fieldId}-${message ? 'error' : 'hint'}`
  const input = useRef<HTMLInputElement>(null)
  const [code, setCode] = useState('')
  const [focused, setFocused] = useState(false)
  const [activeDigit, setActiveDigit] = useState(0)

  useEffect(() => {
    const form = input.current?.form
    function reset() { setCode(''); setActiveDigit(0) }
    form?.addEventListener('reset', reset)
    return () => form?.removeEventListener('reset', reset)
  }, [])

  return <div className="grid min-w-0 gap-2 text-sm font-semibold text-text-strong">
    <label htmlFor={fieldId}>{label} {required && <span className="text-status-error" aria-hidden="true">*</span>}</label>
    <div className={`relative w-full${disabled ? ' opacity-60' : ''}`}>
      <div aria-hidden="true" className="pointer-events-none grid grid-cols-6 gap-2 sm:gap-3">
        {Array.from({ length: 6 }, (_, index) => <span key={index} className={`flex h-14 min-w-0 items-center justify-center rounded-xl border text-2xl font-semibold tabular-nums transition-[border-color,background-color] duration-150 motion-reduce:transition-none sm:h-16 ${message ? 'border-status-error bg-status-error/5' : code[index] ? 'border-text-secondary bg-surface-primary' : 'border-border-default bg-surface-canvas'} ${code[index] ? 'text-text-strong' : 'text-text-secondary'} ${focused && activeDigit === index ? 'outline-2 outline-offset-2 outline-focus-ring' : ''}`}>
          {code[index] || '–'}
        </span>)}
      </div>
      <input
        ref={input}
        id={fieldId}
        name={name}
        type="text"
        inputMode="numeric"
        autoComplete="one-time-code"
        pattern="[0-9]{6}"
        maxLength={6}
        required={required}
        autoFocus={autoFocus}
        disabled={disabled}
        aria-describedby={descriptionId}
        aria-invalid={Boolean(message)}
        className="absolute inset-0 h-full w-full cursor-text opacity-0 disabled:cursor-not-allowed"
        value={code}
        onChange={event => {
          const next = event.currentTarget.value.replace(/\D/g, '').slice(0, 6)
          setCode(next)
          setActiveDigit(Math.min(event.currentTarget.selectionStart ?? next.length, 5))
        }}
        onPaste={event => {
          event.preventDefault()
          const next = event.clipboardData.getData('text').replace(/\D/g, '').slice(0, 6)
          setCode(next)
          event.currentTarget.value = next
          event.currentTarget.setSelectionRange(next.length, next.length)
          setActiveDigit(Math.min(next.length, 5))
        }}
        onFocus={event => { setFocused(true); setActiveDigit(Math.min(event.currentTarget.selectionStart ?? code.length, 5)) }}
        onBlur={() => setFocused(false)}
        onSelect={event => setActiveDigit(Math.min(event.currentTarget.selectionStart ?? code.length, 5))}
        onClick={event => {
          const bounds = event.currentTarget.getBoundingClientRect()
          const position = Math.min(Math.max(Math.floor((event.clientX - bounds.left) / bounds.width * 6), 0), code.length)
          if (!Number.isFinite(position)) return
          event.currentTarget.setSelectionRange(position, Math.min(position + 1, code.length))
          setActiveDigit(Math.min(position, 5))
        }}
      />
    </div>
    {message ? <span className="text-sm font-normal text-status-error" id={descriptionId} role="alert">{message}</span> : <span className="text-sm font-normal leading-relaxed text-text-secondary" id={descriptionId}>{hint}</span>}
  </div>
}
