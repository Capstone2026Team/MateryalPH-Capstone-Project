
# AssessedOnlinePayment

One assessed order payment with positive retained principal. Payment principal, Buyer fees and collections are net of completed refunds; pending or failed refunds do not reduce them. Tax basis, rate and withholding retain the original posted assessment values.

## Properties

Name | Type
------------ | -------------
`id` | string
`orderReference` | string
`assessedAt` | Date
`grossBasisCentavos` | number
`rateBasisPoints` | number
`withheldCentavos` | number
`assessedPaymentCentavos` | number
`deliveryCentavos` | number
`materialVatCentavos` | number
`paymentPrincipalCentavos` | number
`buyerProcessingFeesCentavos` | number
`collectionsCentavos` | number

## Example

```typescript
import type { AssessedOnlinePayment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderReference": null,
  "assessedAt": null,
  "grossBasisCentavos": null,
  "rateBasisPoints": null,
  "withheldCentavos": null,
  "assessedPaymentCentavos": null,
  "deliveryCentavos": null,
  "materialVatCentavos": null,
  "paymentPrincipalCentavos": null,
  "buyerProcessingFeesCentavos": null,
  "collectionsCentavos": null,
} satisfies AssessedOnlinePayment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AssessedOnlinePayment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


