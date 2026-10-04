
# PlatformDocumentRef

MateryalPH documents are always labelled not a tax invoice.

## Properties

Name | Type
------------ | -------------
`kind` | string
`title` | string
`notTaxInvoice` | boolean
`label` | string
`availability` | string

## Example

```typescript
import type { PlatformDocumentRef } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "kind": null,
  "title": null,
  "notTaxInvoice": null,
  "label": null,
  "availability": null,
} satisfies PlatformDocumentRef

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PlatformDocumentRef
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


