
# VendorTaxReviewHistory


## Properties

Name | Type
------------ | -------------
`id` | string
`decision` | string
`reason` | string
`approvalScope` | string
`environment` | string
`createdAt` | string

## Example

```typescript
import type { VendorTaxReviewHistory } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "decision": null,
  "reason": null,
  "approvalScope": null,
  "environment": null,
  "createdAt": null,
} satisfies VendorTaxReviewHistory

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTaxReviewHistory
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


