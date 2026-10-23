
# CommissionTrendPoint


## Properties

Name | Type
------------ | -------------
`period` | Date
`earnedCentavos` | number
`creditsCentavos` | number
`collectedCentavos` | number
`refundedCentavos` | number
`netEarningsCentavos` | number
`gmvCentavos` | number
`buyerPaymentsCentavos` | number
`buyerRefundsCentavos` | number

## Example

```typescript
import type { CommissionTrendPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "period": null,
  "earnedCentavos": null,
  "creditsCentavos": null,
  "collectedCentavos": null,
  "refundedCentavos": null,
  "netEarningsCentavos": null,
  "gmvCentavos": null,
  "buyerPaymentsCentavos": null,
  "buyerRefundsCentavos": null,
} satisfies CommissionTrendPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CommissionTrendPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


