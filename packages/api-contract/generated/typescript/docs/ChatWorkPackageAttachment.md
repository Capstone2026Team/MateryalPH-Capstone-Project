
# ChatWorkPackageAttachment


## Properties

Name | Type
------------ | -------------
`inquiryId` | string
`orderId` | string
`orderLockVersion` | number
`reference` | { [key: string]: any; }
`canPrepareQuotation` | boolean

## Example

```typescript
import type { ChatWorkPackageAttachment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "inquiryId": null,
  "orderId": null,
  "orderLockVersion": null,
  "reference": null,
  "canPrepareQuotation": null,
} satisfies ChatWorkPackageAttachment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatWorkPackageAttachment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


