
# WithholdingRecordedPayment


## Properties

Name | Type
------------ | -------------
`id` | string
`orderReference` | string
`collectedAt` | string
`amountCentavos` | number
`taxableCentavos` | number
`taxCentavos` | number

## Example

```typescript
import type { WithholdingRecordedPayment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderReference": null,
  "collectedAt": null,
  "amountCentavos": null,
  "taxableCentavos": null,
  "taxCentavos": null,
} satisfies WithholdingRecordedPayment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingRecordedPayment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


