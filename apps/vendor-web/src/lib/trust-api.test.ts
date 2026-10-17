import { afterEach, expect, test, vi } from 'vitest'
import { ResponseError, VendorOrderReviewsFromJSON, VendorReviewsApi, type VendorOrderReviews } from '@materyalph/api-client-ts'
import { editBuyerRating, getOrderReviews, rateBuyer } from './trust-api'

const orderId = '019a1000-0000-7000-8000-000000000001'
const reviewId = '019a1000-0000-7000-8000-000000000002'
const key = '019a1000-0000-7000-8000-000000000003'
const ratings = { inquirySeriousness: 5, communicationQuality: 4, paymentReliability: 3, comment: null }
function result(submitted = false): VendorOrderReviews {
  return VendorOrderReviewsFromJSON({
    order_id: orderId, order_reference: 'ORD-TEST', state: 'OPEN', party: 'VENDOR', revealed: false, withheld_for_dispute: false,
    rules: { window_days: 14, edit_hours: 24, comment_max: 1000, media_max: 3, blind_reveal: 'Ratings stay hidden until both parties submit or the 14-day window ends.' },
    can_submit_buyer_rating: !submitted, received: [],
    buyer_rating: submitted ? { id: reviewId, type: 'BUYER', ratings: { inquiry_seriousness: 5, communication_quality: 4, payment_reliability: 3 },
      comment: 'Clear arrangements.', display_name: 'Test Supply', submitted_at: '2026-10-10T04:00:00Z', editable_until: '2026-10-11T04:00:00Z',
      editable_until_label: 'Oct 11, 2026 12:00 PM (Asia/Manila)', can_edit: true, correction_requested: false, visibility: 'HIDDEN_UNTIL_REVEAL', revision: 1, lock_version: 1, media: [] } : null,
  })
}
afterEach(() => vi.restoreAllMocks())

test('loads the generated completed-order review model with no counterpart ratings before reveal', async () => {
  const get = vi.spyOn(VendorReviewsApi.prototype, 'getVendorOrderReviews').mockResolvedValue({ data: result(), meta: {}, errors: [] })
  const data = await getOrderReviews(orderId)
  expect(get).toHaveBeenCalledWith({ orderId })
  expect(data.buyerRating).toBeNull()
  expect(data.received).toEqual([])
  expect(data.rules.commentMax).toBe(1000)
})

test('submits the three criteria with the caller retry key and returns authoritative saved values', async () => {
  const submit = vi.spyOn(VendorReviewsApi.prototype, 'submitVendorBuyerRating').mockResolvedValue({ data: result(true), meta: {}, errors: [] })
  const data = await rateBuyer(orderId, ratings, key)
  expect(submit).toHaveBeenCalledWith({ orderId, idempotencyKey: key, vendorBuyerRatingRequest: { inquirySeriousness: 5, communicationQuality: 4, paymentReliability: 3 } })
  expect(data.buyerRating?.ratings).toEqual({ inquirySeriousness: 5, communicationQuality: 4, paymentReliability: 3 })
  expect(data.buyerRating?.comment).toBe('Clear arrangements.')
  expect(data.buyerRating?.editableUntil).toBeInstanceOf(Date)
})

test('a correction sends the current version and explicitly clears a removed comment', async () => {
  const edit = vi.spyOn(VendorReviewsApi.prototype, 'editVendorBuyerRating').mockResolvedValue({ data: result(true), meta: {}, errors: [] })
  await editBuyerRating(reviewId, 7, ratings)
  expect(edit).toHaveBeenCalledWith({ reviewId, vendorReviewEditRequest: { lockVersion: 7, inquirySeriousness: 5, communicationQuality: 4, paymentReliability: 3, comment: '' } })
})

test.each([
  ['missing rules', { ...result(), rules: undefined }],
  ['missing comment limit', { ...result(), rules: { ...result().rules, commentMax: undefined } }],
  ['wrong order', { ...result(), orderId: 'another-order' }],
  ['missing own rating values', { ...result(true), buyerRating: { ...result(true).buyerRating, ratings: undefined } }],
  ['missing received rating values', { ...result(), received: [{ id: reviewId }] }],
])('rejects %s at the request boundary so the order can show an inline error', async (_label, data) => {
  vi.spyOn(VendorReviewsApi.prototype, 'getVendorOrderReviews').mockResolvedValue({ data: data as VendorOrderReviews, meta: {}, errors: [] })
  await expect(getOrderReviews(orderId)).rejects.toThrow('The order ratings response is incomplete.')
})

test('preserves permission failures for the order error state without producing a success', async () => {
  const failure = new ResponseError(new Response(null, { status: 403 }), 'Reviews are not available to your role.')
  vi.spyOn(VendorReviewsApi.prototype, 'submitVendorBuyerRating').mockRejectedValue(failure)
  await expect(rateBuyer(orderId, ratings, key)).rejects.toBe(failure)
})
