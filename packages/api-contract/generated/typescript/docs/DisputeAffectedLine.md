
# DisputeAffectedLine


## Properties

Name | Type
------------ | -------------
`orderLineId` | string
`displayName` | string
`variantLabel` | string
`quantity` | string
`lineTotalCentavos` | number
`refundableCentavos` | number

## Example

```typescript
import type { DisputeAffectedLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderLineId": null,
  "displayName": null,
  "variantLabel": null,
  "quantity": null,
  "lineTotalCentavos": null,
  "refundableCentavos": null,
} satisfies DisputeAffectedLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeAffectedLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


