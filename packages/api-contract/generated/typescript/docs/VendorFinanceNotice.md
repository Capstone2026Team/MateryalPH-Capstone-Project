
# VendorFinanceNotice


## Properties

Name | Type
------------ | -------------
`id` | string
`mandatory` | boolean
`title` | string
`body` | string
`createdAt` | Date
`read` | boolean

## Example

```typescript
import type { VendorFinanceNotice } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "mandatory": null,
  "title": null,
  "body": null,
  "createdAt": null,
  "read": null,
} satisfies VendorFinanceNotice

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorFinanceNotice
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


