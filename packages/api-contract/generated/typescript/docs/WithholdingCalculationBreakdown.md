
# WithholdingCalculationBreakdown

First five POSTED tax assessments from this store in assessment order, plus aggregate-only remainder across the taxpayer-year. Includes original tax assessments even when a later refund removes a payment from the retained-payment list. Preview and remainder reconcile exactly to the recorded annual basis and withholding total.

## Properties

Name | Type
------------ | -------------
`payments` | [Array&lt;WithholdingPaymentCalculation&gt;](WithholdingPaymentCalculation.md)
`remainingPayments` | number
`remainingBasisCentavos` | number
`remainingWithheldCentavos` | number

## Example

```typescript
import type { WithholdingCalculationBreakdown } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "payments": null,
  "remainingPayments": null,
  "remainingBasisCentavos": null,
  "remainingWithheldCentavos": null,
} satisfies WithholdingCalculationBreakdown

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingCalculationBreakdown
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


