import { useId, useState, type FormEvent } from 'react'
import type { ReviewRatings } from '@materyalph/api-client-ts'
import { StarRatingDisplay, StarRatingInput } from './analytics-patterns'
import { Button } from './button'
import { StatusMessage } from './status-message'

export type BuyerRatingValues = {
  inquirySeriousness: number | null
  communicationQuality: number | null
  paymentReliability: number | null
  comment: string
}

export type BuyerRatingSubmission = {
  inquirySeriousness: number
  communicationQuality: number
  paymentReliability: number
  comment: string | null
}

const BUYER_CRITERIA = [
  { key: 'inquirySeriousness', label: 'Inquiry Seriousness', description: 'How serious was the Buyer about this purchase?' },
  { key: 'communicationQuality', label: 'Communication Quality', description: 'How clear and responsive was the Buyer?' },
  { key: 'paymentReliability', label: 'Payment Reliability', description: 'How reliably did the Buyer meet the payment arrangements?' },
] as const

/** One responsive form for a store's three Buyer criteria, including corrections. */
export function BuyerRatingForm({ initialValues, editing = false, commentMax = 1000, busy = false, error, onSubmit, onCancel }: {
  initialValues: BuyerRatingValues; editing?: boolean; commentMax?: number; busy?: boolean; error?: string | null
  onSubmit: (values: BuyerRatingSubmission) => void; onCancel: () => void
}) {
  const id = useId()
  const [values, setValues] = useState(initialValues)
  const [validation, setValidation] = useState(false)
  const rated = BUYER_CRITERIA.filter(criterion => values[criterion.key] !== null).length
  function submit(event: FormEvent) {
    event.preventDefault()
    if (busy) return
    setValidation(true)
    const { inquirySeriousness, communicationQuality, paymentReliability } = values
    if (!inquirySeriousness || !communicationQuality || !paymentReliability) return
    onSubmit({ inquirySeriousness, communicationQuality, paymentReliability, comment: values.comment.trim() || null })
  }
  return <form onSubmit={submit} noValidate aria-label={editing ? 'Correct Buyer rating' : 'Rate this Buyer'} className="grid min-w-0 gap-5">
    <div className="divide-y divide-border-default border-y border-border-default">
      {BUYER_CRITERIA.map(criterion => <div key={criterion.key} className="flex min-w-0 flex-wrap items-center justify-between gap-x-6 gap-y-3 py-4">
        <div className="min-w-0 flex-1 basis-64">
          <p className="text-sm font-semibold text-text-strong">{criterion.label}</p>
          <p className="text-sm leading-6 text-text-secondary" id={`${id}-${criterion.key}-hint`}>{criterion.description}</p>
        </div>
        <StarRatingInput legend={criterion.label} name={`${id}-${criterion.key}`} value={values[criterion.key]} disabled={busy} hideLegend
          descriptionId={`${id}-${criterion.key}-hint`} error={validation && values[criterion.key] === null ? 'Choose a rating from 1 to 5.' : null}
          onChange={value => setValues(current => ({ ...current, [criterion.key]: value }))} />
      </div>)}
    </div>
    <div className="grid min-w-0 gap-2">
      <div className="flex flex-wrap items-center justify-between gap-2 text-sm">
        <label htmlFor={`${id}-comment`} className="font-semibold">Comment <span className="font-normal text-text-secondary">(optional)</span></label>
        <span id={`${id}-comment-count`} className="text-xs tabular-nums text-text-secondary">{values.comment.length.toLocaleString()} / {commentMax.toLocaleString()}</span>
      </div>
      <textarea id={`${id}-comment`} aria-describedby={`${id}-comment-count`} className="min-h-28 w-full min-w-0 resize-y rounded-control border border-border-default bg-surface-primary p-3 text-base text-text-strong placeholder:text-text-secondary focus:border-focus-ring focus:outline-2 focus:outline-focus-ring disabled:opacity-60"
        placeholder="Share feedback about this transaction." maxLength={commentMax} disabled={busy} value={values.comment} onChange={event => setValues(current => ({ ...current, comment: event.target.value }))} />
    </div>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <div className="flex flex-wrap items-center justify-between gap-3">
      <p className="text-xs text-text-secondary">{rated} of 3 criteria rated · 1 is lowest, 5 is highest</p>
      <div className="flex w-full flex-wrap gap-2 sm:w-auto">
        <Button variant="secondary" disabled={busy} onClick={onCancel}>Cancel</Button>
        <Button type="submit" disabled={busy}>{busy ? 'Saving…' : editing ? 'Save correction' : 'Submit rating'}</Button>
      </div>
    </div>
  </form>
}

/** The same criterion labels for received reviews, store submissions and order summaries. */
export function ReviewRatingSummary({ ratings: given }: { ratings: ReviewRatings | undefined | null }) {
  const ratings = given ?? {}
  const entries: [string, number | undefined][] = [['Service Quality', ratings.serviceQuality], [ratings.speedKind === 'DELIVERY_SPEED' ? 'Delivery Speed' : 'Processing Speed', ratings.speedRating], ['Product Quality', ratings.productQuality],
    ['Inquiry Seriousness', ratings.inquirySeriousness], ['Communication Quality', ratings.communicationQuality], ['Payment Reliability', ratings.paymentReliability]]
  return <span className="flex min-w-0 flex-wrap gap-x-6 gap-y-2">{entries.filter((entry): entry is [string, number] => typeof entry[1] === 'number').map(([label, value]) => <span key={label} className="inline-flex flex-wrap items-center gap-2 text-sm"><span className="text-text-secondary">{label}</span><StarRatingDisplay value={value} label={label} /></span>)}</span>
}
