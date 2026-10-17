import { useState } from 'react'
import { Check, Copy } from 'lucide-react'
import { Button } from './button'

export function CopyableText({ value, copyLabel = 'Copy value' }: { value: string; copyLabel?: string }) {
  const [feedback, setFeedback] = useState<{ value: string; copied: boolean } | null>(null)
  const copied = feedback?.value === value && feedback.copied
  async function copy() {
    try {
      await navigator.clipboard.writeText(value)
      setFeedback({ value, copied: true })
    } catch {
      setFeedback({ value, copied: false })
    }
  }
  return <div className="grid min-w-0 gap-1">
    <div className="flex min-w-0 flex-wrap items-center gap-2">
      <span className="select-all break-all text-sm font-semibold tabular-nums">{value}</span>
      <Button variant="quiet" aria-label={copyLabel} onClick={() => void copy()}>
        {copied ? <Check size={16} aria-hidden="true" /> : <Copy size={16} aria-hidden="true" />}{copied ? 'Copied' : 'Copy'}
      </Button>
    </div>
    {feedback?.value === value && <p role="status" className="text-xs leading-5 text-text-secondary">{feedback.copied ? 'Copied to clipboard.' : 'Copy is unavailable. Select and copy the value manually.'}</p>}
  </div>
}
