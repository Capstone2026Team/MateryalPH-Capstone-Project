
# ProductAnalyticsSuggestion

A planning suggestion from data-derived comparisons with the store’s own products or a level the Vendor set. It changes nothing by itself.

## Properties

Name | Type
------------ | -------------
`key` | string
`kind` | string
`priority` | string
`title` | string
`detail` | string
`technique` | string
`href` | string
`listingId` | string
`product` | string

## Example

```typescript
import type { ProductAnalyticsSuggestion } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "kind": null,
  "priority": null,
  "title": null,
  "detail": null,
  "technique": null,
  "href": null,
  "listingId": null,
  "product": null,
} satisfies ProductAnalyticsSuggestion

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductAnalyticsSuggestion
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


