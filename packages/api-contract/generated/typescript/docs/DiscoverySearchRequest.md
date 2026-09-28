
# DiscoverySearchRequest

Send location_id or latitude/longitude (never both). Omit both to use the primary saved location. radius_km defaults to the saved preference.

## Properties

Name | Type
------------ | -------------
`locationId` | string
`latitude` | number
`longitude` | number
`originSource` | string
`radiusKm` | number
`includeVerified` | boolean
`includeDirectory` | boolean
`favoritesOnly` | boolean
`supplierType` | string
`categoryId` | string
`page` | number
`perPage` | number

## Example

```typescript
import type { DiscoverySearchRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "locationId": null,
  "latitude": null,
  "longitude": null,
  "originSource": null,
  "radiusKm": null,
  "includeVerified": null,
  "includeDirectory": null,
  "favoritesOnly": null,
  "supplierType": null,
  "categoryId": null,
  "page": null,
  "perPage": null,
} satisfies DiscoverySearchRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DiscoverySearchRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


