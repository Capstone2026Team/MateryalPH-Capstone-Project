
# PaymentWebhookPayload


## Properties

Name | Type
------------ | -------------
`event` | string
`businessId` | string
`created` | string
`data` | { [key: string]: any; }

## Example

```typescript
import type { PaymentWebhookPayload } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "event": null,
  "businessId": null,
  "created": null,
  "data": null,
} satisfies PaymentWebhookPayload

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PaymentWebhookPayload
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


