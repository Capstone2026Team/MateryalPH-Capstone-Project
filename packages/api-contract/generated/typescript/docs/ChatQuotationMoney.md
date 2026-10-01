
# ChatQuotationMoney


## Properties

Name | Type
------------ | -------------
`materialsPayableCentavos` | number
`materialsVatCentavos` | number
`vendorDiscountCentavos` | number
`deliveryCentavos` | number
`nrpcCentavos` | number
`commercialTotalCentavos` | number

## Example

```typescript
import type { ChatQuotationMoney } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "materialsPayableCentavos": null,
  "materialsVatCentavos": null,
  "vendorDiscountCentavos": null,
  "deliveryCentavos": null,
  "nrpcCentavos": null,
  "commercialTotalCentavos": null,
} satisfies ChatQuotationMoney

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatQuotationMoney
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


