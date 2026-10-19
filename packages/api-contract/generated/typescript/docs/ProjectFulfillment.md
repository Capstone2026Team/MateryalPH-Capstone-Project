
# ProjectFulfillment

How much of the Work Package this quotation covers, derived on every read from the Work Package lines, this Vendor\'s priced lines and the Item-Based purchases tagged to the lines. The Vendor card, quotation, order summary and missing-item list all read this one result. A separate purchase closes a gap only when its product satisfies the line\'s brand and specifications; `complete` on the candidate remains the Vendor\'s own ability and drives ranking.

## Properties

Name | Type
------------ | -------------
`status` | string
`linesTotal` | number
`linesFulfilled` | number
`linesPartial` | number
`linesUnfulfilled` | number
`vendorLinesFulfilled` | number
`lines` | [Array&lt;ProjectFulfillmentLine&gt;](ProjectFulfillmentLine.md)
`separateItems` | [Array&lt;ProjectSeparatePurchase&gt;](ProjectSeparatePurchase.md)
`separateTotalCentavos` | number
`combinedTotalCentavos` | number

## Example

```typescript
import type { ProjectFulfillment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "linesTotal": null,
  "linesFulfilled": null,
  "linesPartial": null,
  "linesUnfulfilled": null,
  "vendorLinesFulfilled": null,
  "lines": null,
  "separateItems": null,
  "separateTotalCentavos": null,
  "combinedTotalCentavos": null,
} satisfies ProjectFulfillment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectFulfillment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


