
# InvoiceListMeta


## Properties

Name | Type
------------ | -------------
`view` | string
`counts` | { [key: string]: number; }
`page` | number
`perPage` | number
`total` | number
`hasMore` | boolean
`canUpload` | boolean
`issuanceNotice` | string
`notice` | string

## Example

```typescript
import type { InvoiceListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "view": null,
  "counts": null,
  "page": null,
  "perPage": null,
  "total": null,
  "hasMore": null,
  "canUpload": null,
  "issuanceNotice": null,
  "notice": null,
} satisfies InvoiceListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InvoiceListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


