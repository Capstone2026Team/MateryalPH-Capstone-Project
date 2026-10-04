
# InvoiceRequestCreate


## Properties

Name | Type
------------ | -------------
`kind` | string
`details` | string
`invoiceRecordId` | string

## Example

```typescript
import type { InvoiceRequestCreate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "kind": null,
  "details": null,
  "invoiceRecordId": null,
} satisfies InvoiceRequestCreate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceRequestCreate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


