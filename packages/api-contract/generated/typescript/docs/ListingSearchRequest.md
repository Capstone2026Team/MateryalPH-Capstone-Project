
# ListingSearchRequest

Origin fields as BuyerOriginRequest plus optional filters. ANY means no filter. A cursor is valid only for the same scope, query, sort, weights and filters.

## Properties

Name | Type
------------ | -------------
`locationId` | string
`latitude` | number
`longitude` | number
`originSource` | string
`radiusKm` | number
`query` | string
`sort` | [ListingSearchSort](ListingSearchSort.md)
`categoryId` | string
`brand` | string
`variant` | string
`availability` | string
`fulfillment` | string
`favoritesOnly` | boolean
`compliance` | string
`minPriceCentavos` | number
`maxPriceCentavos` | number
`vendorId` | string
`cursor` | string
`perPage` | number

## Example

```typescript
import type { ListingSearchRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "locationId": null,
  "latitude": null,
  "longitude": null,
  "originSource": null,
  "radiusKm": null,
  "query": null,
  "sort": null,
  "categoryId": null,
  "brand": null,
  "variant": null,
  "availability": null,
  "fulfillment": null,
  "favoritesOnly": null,
  "compliance": null,
  "minPriceCentavos": null,
  "maxPriceCentavos": null,
  "vendorId": null,
  "cursor": null,
  "perPage": null,
} satisfies ListingSearchRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingSearchRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


