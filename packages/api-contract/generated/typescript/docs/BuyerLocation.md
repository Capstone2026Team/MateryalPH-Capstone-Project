
# BuyerLocation


## Properties

Name | Type
------------ | -------------
`id` | string
`label` | string
`locationKind` | [BuyerLocationKind](BuyerLocationKind.md)
`isPrimary` | boolean
`formattedAddress` | string
`latitude` | number
`longitude` | number
`source` | string
`addressVersion` | number
`components` | [AddressComponents](AddressComponents.md)
`psgc` | [PsgcResolution](PsgcResolution.md)
`contactName` | string
`contactPhoneE164` | string
`siteInstructions` | string
`lockVersion` | number
`updatedAt` | Date

## Example

```typescript
import type { BuyerLocation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "label": null,
  "locationKind": null,
  "isPrimary": null,
  "formattedAddress": null,
  "latitude": null,
  "longitude": null,
  "source": null,
  "addressVersion": null,
  "components": null,
  "psgc": null,
  "contactName": null,
  "contactPhoneE164": null,
  "siteInstructions": null,
  "lockVersion": null,
  "updatedAt": null,
} satisfies BuyerLocation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerLocation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


