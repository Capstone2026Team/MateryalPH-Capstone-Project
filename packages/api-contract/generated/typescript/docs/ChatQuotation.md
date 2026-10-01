
# ChatQuotation


## Properties

Name | Type
------------ | -------------
`id` | string
`state` | string
`lockVersion` | number
`currentVersionId` | string
`acceptedOrderId` | string
`responseDueAt` | string
`draft` | { [key: string]: any; }
`canDraft` | boolean
`canPublish` | boolean

## Example

```typescript
import type { ChatQuotation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "state": null,
  "lockVersion": null,
  "currentVersionId": null,
  "acceptedOrderId": null,
  "responseDueAt": null,
  "draft": null,
  "canDraft": null,
  "canPublish": null,
} satisfies ChatQuotation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatQuotation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


