
# XenditAccountVerificationWebhook


## Properties

Name | Type
------------ | -------------
`event` | string
`created` | Date
`data` | [XenditAccountVerificationWebhookData](XenditAccountVerificationWebhookData.md)

## Example

```typescript
import type { XenditAccountVerificationWebhook } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "event": null,
  "created": null,
  "data": null,
} satisfies XenditAccountVerificationWebhook

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as XenditAccountVerificationWebhook
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


