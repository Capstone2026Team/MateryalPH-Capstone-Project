
# OrderPaymentAvailability

Order-specific payment state. Buyers see their attempts; Vendor staff see operational status only. Store-wide finance stays Owner-only in Vendor Finance.

## Properties

Name | Type
------------ | -------------
`available` | boolean
`reason` | string
`notice` | string
`purpose` | string
`principalCentavos` | number
`latestAttempt` | [PaymentAttempt](PaymentAttempt.md)
`verifiedPayment` | [PaymentAttempt](PaymentAttempt.md)
`attempts` | [Array&lt;PaymentAttempt&gt;](PaymentAttempt.md)
`physical` | [PhysicalPaymentSummary](PhysicalPaymentSummary.md)
`environment` | string

## Example

```typescript
import type { OrderPaymentAvailability } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "available": null,
  "reason": null,
  "notice": null,
  "purpose": null,
  "principalCentavos": null,
  "latestAttempt": null,
  "verifiedPayment": null,
  "attempts": null,
  "physical": null,
  "environment": null,
} satisfies OrderPaymentAvailability

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderPaymentAvailability
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


