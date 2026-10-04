
# DisputeDetail

One case: the chronological timeline, proposals, clarifications, immutable decisions, the one appeal, remedies and the linked Dispute-Conclusion Refunds. Fulfillment Staff receive a limited view.

## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`orderId` | string
`orderReference` | string
`status` | string
`caseKind` | string
`issueType` | string
`requestedRemedy` | string
`requestedAmountCentavos` | number
`filedByParty` | string
`responsibleParty` | string
`nextDeadline` | [DisputeDeadline](DisputeDeadline.md)
`refundState` | string
`remedyState` | string
`appealAvailable` | boolean
`vendorName` | string
`buyerName` | string
`assignedToAdmin` | boolean
`decisions` | [Array&lt;DisputeDecision&gt;](DisputeDecision.md)
`filedAt` | Date
`updatedAt` | Date
`description` | string
`affectedLines` | [Array&lt;DisputeAffectedLine&gt;](DisputeAffectedLine.md)
`originalPaymentMethod` | [DisputeOriginalPaymentMethod](DisputeOriginalPaymentMethod.md)
`preferredContactChannel` | string
`order` | [DisputeOrderRef](DisputeOrderRef.md)
`deadlines` | [Array&lt;DisputeDeadline&gt;](DisputeDeadline.md)
`serverTime` | Date
`timezone` | string
`handler` | [DisputeHandler](DisputeHandler.md)
`lockVersion` | number
`timeline` | [Array&lt;DisputeTimelineEntry&gt;](DisputeTimelineEntry.md)
`proposals` | [Array&lt;DisputeProposal&gt;](DisputeProposal.md)
`clarifications` | [Array&lt;DisputeClarification&gt;](DisputeClarification.md)
`appeal` | [DisputeAppeal](DisputeAppeal.md)
`remedies` | [Array&lt;DisputeRemedy&gt;](DisputeRemedy.md)
`refunds` | [Array&lt;RefundTimelineItem&gt;](RefundTimelineItem.md)
`reimbursements` | [Array&lt;ReimbursementTimelineItem&gt;](ReimbursementTimelineItem.md)
`availableActions` | Array&lt;string&gt;
`limitedView` | boolean
`permissions` | [DisputeVendorPermissions](DisputeVendorPermissions.md)
`admin` | [DisputeAdminContext](DisputeAdminContext.md)

## Example

```typescript
import type { DisputeDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "orderId": null,
  "orderReference": null,
  "status": null,
  "caseKind": null,
  "issueType": null,
  "requestedRemedy": null,
  "requestedAmountCentavos": null,
  "filedByParty": null,
  "responsibleParty": null,
  "nextDeadline": null,
  "refundState": null,
  "remedyState": null,
  "appealAvailable": null,
  "vendorName": null,
  "buyerName": null,
  "assignedToAdmin": null,
  "decisions": null,
  "filedAt": null,
  "updatedAt": null,
  "description": null,
  "affectedLines": null,
  "originalPaymentMethod": null,
  "preferredContactChannel": null,
  "order": null,
  "deadlines": null,
  "serverTime": null,
  "timezone": null,
  "handler": null,
  "lockVersion": null,
  "timeline": null,
  "proposals": null,
  "clarifications": null,
  "appeal": null,
  "remedies": null,
  "refunds": null,
  "reimbursements": null,
  "availableActions": null,
  "limitedView": null,
  "permissions": null,
  "admin": null,
} satisfies DisputeDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


