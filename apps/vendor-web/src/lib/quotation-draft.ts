import type { ChatDraftContent } from '@materyalph/api-client-ts'
import { parsePesoInput, pesoInputFromCentavos } from '../../../../packages/web-ui/src/money-input'

/** Keep unfinished input in the editor; omit empty optional strings only when saving. */
export function quotationDraftForSave(draft: ChatDraftContent): ChatDraftContent {
  const { vendorDiscountCentavos, paymentMethod, nrpc, ...rest } = draft
  void nrpc
  void paymentMethod
  const points = draft.discount ? parsePesoInput(draft.discount.percent.trim() || '0') : null
  return {
    ...rest,
    message: draft.message?.trim() || '',
    ...(!draft.discount && vendorDiscountCentavos !== undefined ? { vendorDiscountCentavos } : {}),
    ...(draft.discount && points !== null ? { discount: { ...draft.discount, percent: pesoInputFromCentavos(points) } } : {}),
    lines: draft.lines.map(({ description, specifications, ...line }) => ({
      ...line,
      ...(description?.trim() ? { description: description.trim() } : {}),
      ...(specifications !== undefined ? { specifications: Object.fromEntries(Object.entries(specifications).filter(([, value]) => value.trim()).map(([name, value]) => [name, value.trim()])) } : {}),
    })),
  }
}
