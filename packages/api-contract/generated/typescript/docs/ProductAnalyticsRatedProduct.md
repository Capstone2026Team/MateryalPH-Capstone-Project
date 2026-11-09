
# ProductAnalyticsRatedProduct

One of the authenticated store\'s published products, using the existing all-time visible Product Quality average. Contains no reviewer identity.

## Properties

Name | Type
------------ | -------------
`listingId` | string
`name` | string
`category` | string
`average` | string
`count` | number

## Example

```typescript
import type { ProductAnalyticsRatedProduct } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "name": null,
  "category": null,
  "average": null,
  "count": null,
} satisfies ProductAnalyticsRatedProduct

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductAnalyticsRatedProduct
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


