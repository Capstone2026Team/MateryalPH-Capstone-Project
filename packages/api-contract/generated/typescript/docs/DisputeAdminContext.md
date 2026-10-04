
# DisputeAdminContext

Decision support for Order and Dispute Staff. Refundable amounts return only to the original payments; Admins never hold or disburse money.

## Properties

Name | Type
------------ | -------------
`outcomes` | Array&lt;string&gt;
`sanctions` | Array&lt;string&gt;
`metricEvents` | Array&lt;string&gt;
`refundable` | [DisputeRefundable](DisputeRefundable.md)
`alreadyAwardedCentavos` | number
`appealReviewerConflict` | boolean
`unansweredClarification` | boolean
`buyer` | [DisputeAdminParty](DisputeAdminParty.md)
`vendor` | [DisputeAdminParty](DisputeAdminParty.md)
`orderTimeline` | Array&lt;{ [key: string]: any; }&gt;
`enforcement` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { DisputeAdminContext } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "outcomes": null,
  "sanctions": null,
  "metricEvents": null,
  "refundable": null,
  "alreadyAwardedCentavos": null,
  "appealReviewerConflict": null,
  "unansweredClarification": null,
  "buyer": null,
  "vendor": null,
  "orderTimeline": null,
  "enforcement": null,
} satisfies DisputeAdminContext

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeAdminContext
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


