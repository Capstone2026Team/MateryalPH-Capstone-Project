
# OrderRefundTimeline


## Properties

Name | Type
------------ | -------------
`refunds` | [Array&lt;RefundTimelineItem&gt;](RefundTimelineItem.md)
`reimbursements` | [Array&lt;ReimbursementTimelineItem&gt;](ReimbursementTimelineItem.md)
`noLongerDueCentavos` | number
`decision` | [CancellationDecisionView](CancellationDecisionView.md)

## Example

```typescript
import type { OrderRefundTimeline } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "refunds": null,
  "reimbursements": null,
  "noLongerDueCentavos": null,
  "decision": null,
} satisfies OrderRefundTimeline

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderRefundTimeline
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


