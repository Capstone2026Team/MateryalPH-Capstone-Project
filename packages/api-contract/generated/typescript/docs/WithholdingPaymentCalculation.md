
# WithholdingPaymentCalculation

One immutable POSTED merchant tax assessment belonging to the current store. No provider identifiers or other-store order references.

## Properties

Name | Type
------------ | -------------
`id` | string
`orderReference` | string
`grossBasisCentavos` | number
`rateBasisPoints` | number
`withheldCentavos` | number

## Example

```typescript
import type { WithholdingPaymentCalculation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderReference": null,
  "grossBasisCentavos": null,
  "rateBasisPoints": null,
  "withheldCentavos": null,
} satisfies WithholdingPaymentCalculation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingPaymentCalculation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


