
# PaymentOptions


## Properties

Name | Type
------------ | -------------
`orderId` | string
`orderReference` | string
`paymentDue` | boolean
`purpose` | string
`principalCentavos` | number
`breakdown` | { [key: string]: any; }
`channels` | [Array&lt;PaymentChannelOption&gt;](PaymentChannelOption.md)
`payBy` | Date
`environment` | string
`evidenceOrigin` | string
`providerReady` | boolean
`latestAttempt` | [PaymentAttempt](PaymentAttempt.md)
`notice` | string

## Example

```typescript
import type { PaymentOptions } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderId": null,
  "orderReference": null,
  "paymentDue": null,
  "purpose": null,
  "principalCentavos": null,
  "breakdown": null,
  "channels": null,
  "payBy": null,
  "environment": null,
  "evidenceOrigin": null,
  "providerReady": null,
  "latestAttempt": null,
  "notice": null,
} satisfies PaymentOptions

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PaymentOptions
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


