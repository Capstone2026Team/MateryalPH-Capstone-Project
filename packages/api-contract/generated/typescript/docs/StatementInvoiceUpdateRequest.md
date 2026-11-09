
# StatementInvoiceUpdateRequest


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`invoiceHeading` | string
`invoiceMessage` | string

## Example

```typescript
import type { StatementInvoiceUpdateRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "invoiceHeading": null,
  "invoiceMessage": null,
} satisfies StatementInvoiceUpdateRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as StatementInvoiceUpdateRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


