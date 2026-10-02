
# ChatProduct


## Properties

Name | Type
------------ | -------------
`productId` | string
`listingId` | string
`name` | string
`priceCentavos` | number
`imageUrl` | string
`available` | boolean

## Example

```typescript
import type { ChatProduct } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "productId": null,
  "listingId": null,
  "name": null,
  "priceCentavos": null,
  "imageUrl": null,
  "available": null,
} satisfies ChatProduct

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatProduct
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


