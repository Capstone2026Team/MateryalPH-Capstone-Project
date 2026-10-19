
# DirectoryListing


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`sku` | string
`status` | string
`updatedAt` | Date
`variantCount` | number
`minPriceCentavos` | number
`maxPriceCentavos` | number
`unitCode` | string
`stock` | string
`imageUrl` | string
`imageAlt` | string

## Example

```typescript
import type { DirectoryListing } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "sku": null,
  "status": null,
  "updatedAt": null,
  "variantCount": null,
  "minPriceCentavos": null,
  "maxPriceCentavos": null,
  "unitCode": null,
  "stock": null,
  "imageUrl": null,
  "imageAlt": null,
} satisfies DirectoryListing

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryListing
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


