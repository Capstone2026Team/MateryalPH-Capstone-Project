import { useEffect, useLayoutEffect, useRef, useState } from 'react'
import { Field, type FieldProps } from './field'
import { formatPesoInput, parsePesoInput, pesoInputCaret, pesoInputFromCentavos } from './money-input'

interface MoneyFieldProps extends Pick<FieldProps, 'label' | 'disabled' | 'placeholder' | 'aria-label' | 'name'> {
  error?: string | undefined
  valueCentavos: number | null
  onChange: (value: number | null) => void
  allowEmptyZero?: boolean
  minCentavos?: number
  maxCentavos?: number
}

/** A peso input keeps editable text separate from the integer API amount. */
export function MoneyField({ valueCentavos, onChange, allowEmptyZero = false, minCentavos = 0, maxCentavos = Number.MAX_SAFE_INTEGER, placeholder = '0.00', error: externalError, ...props }: MoneyFieldProps) {
  const [editor, setEditor] = useState<{ text: string; caret: number | null }>(() => ({ text: valueCentavos === 0 && allowEmptyZero ? '' : pesoInputFromCentavos(valueCentavos), caret: null }))
  const text = editor.text
  const emitted = useRef(valueCentavos)
  const input = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (valueCentavos !== emitted.current) {
      emitted.current = valueCentavos
      setEditor({ text: valueCentavos === 0 && allowEmptyZero ? '' : pesoInputFromCentavos(valueCentavos), caret: null })
    }
  }, [valueCentavos, allowEmptyZero])
  useLayoutEffect(() => {
    if (editor.caret !== null && document.activeElement === input.current) {
      input.current?.setSelectionRange(editor.caret, editor.caret)
    }
  }, [editor])

  const parsed = !text.trim() && allowEmptyZero ? 0 : parsePesoInput(text)
  const error = parsed === null ? (!text.trim() ? 'Enter an amount.' : 'Use numbers and up to 2 decimal places.')
    : parsed < minCentavos ? `Enter at least ₱${pesoInputFromCentavos(minCentavos)}.`
      : parsed > maxCentavos ? `Enter at most ₱${pesoInputFromCentavos(maxCentavos)}.` : undefined

  return <Field {...props} ref={input} startAdornment="₱" inputMode="decimal" type="text" autoComplete="off" className="tabular-nums" placeholder={placeholder} value={text} error={error ?? externalError} onChange={event => {
    const raw = event.target.value
    const formatted = formatPesoInput(raw)
    setEditor({ text: formatted, caret: pesoInputCaret(raw, event.target.selectionStart ?? raw.length, formatted) })
    const amount = !formatted.trim() && allowEmptyZero ? 0 : parsePesoInput(formatted)
    const next = amount !== null && amount >= minCentavos && amount <= maxCentavos ? amount : null
    emitted.current = next
    onChange(next)
  }} onBlur={() => {
    if (!text.trim() && allowEmptyZero) return
    if (parsed !== null && !error) setEditor({ text: pesoInputFromCentavos(parsed), caret: null })
  }} />
}
