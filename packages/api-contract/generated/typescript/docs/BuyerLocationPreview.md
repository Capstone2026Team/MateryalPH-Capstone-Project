
# BuyerLocationPreview


## Properties

Name | Type
------------ | -------------
`formattedAddress` | string
`latitude` | number
`longitude` | number
`source` | string
`providerStatus` | string
`components` | [AddressComponents](AddressComponents.md)
`psgc` | [PsgcResolution](PsgcResolution.md)
`resolutionToken` | string
`expiresAt` | Date

## Example

```typescript
import type { BuyerLocationPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "formattedAddress": null,
  "latitude": null,
  "longitude": null,
  "source": null,
  "providerStatus": null,
  "components": null,
  "psgc": null,
  "resolutionToken": null,
  "expiresAt": null,
} satisfies BuyerLocationPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerLocationPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


