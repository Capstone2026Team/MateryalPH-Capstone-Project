
# BuyerLocationResolveRequest


## Properties

Name | Type
------------ | -------------
`mode` | string
`placeId` | string
`sessionToken` | string
`latitude` | number
`longitude` | number
`addressLine` | string
`barangay` | string
`cityMunicipality` | string
`province` | string
`postalCode` | string
`cityCode` | string
`barangayCode` | string

## Example

```typescript
import type { BuyerLocationResolveRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "mode": null,
  "placeId": null,
  "sessionToken": null,
  "latitude": null,
  "longitude": null,
  "addressLine": null,
  "barangay": null,
  "cityMunicipality": null,
  "province": null,
  "postalCode": null,
  "cityCode": null,
  "barangayCode": null,
} satisfies BuyerLocationResolveRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerLocationResolveRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


