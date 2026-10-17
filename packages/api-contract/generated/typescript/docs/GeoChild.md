
# GeoChild


## Properties

Name | Type
------------ | -------------
`code` | string
`name` | string
`level` | string
`levelLabel` | string
`drillable` | boolean
`vendorCount` | number
`registeredBuyers` | [GeoChildRegisteredBuyers](GeoChildRegisteredBuyers.md)
`grossGmvCentavos` | [GeoChildRegisteredBuyers](GeoChildRegisteredBuyers.md)
`netGmvCentavos` | [GeoChildRegisteredBuyers](GeoChildRegisteredBuyers.md)
`orderVolume` | [GeoChildRegisteredBuyers](GeoChildRegisteredBuyers.md)
`fulfillmentRate` | [GeoRate](GeoRate.md)
`cancellationRate` | [GeoRate](GeoRate.md)
`disputeRate` | [GeoRate](GeoRate.md)
`medianResponseSeconds` | number
`responseSuppressed` | boolean
`suppressed` | boolean
`suppressionReason` | string
`suppressionNote` | string

## Example

```typescript
import type { GeoChild } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "name": null,
  "level": null,
  "levelLabel": null,
  "drillable": null,
  "vendorCount": null,
  "registeredBuyers": null,
  "grossGmvCentavos": null,
  "netGmvCentavos": null,
  "orderVolume": null,
  "fulfillmentRate": null,
  "cancellationRate": null,
  "disputeRate": null,
  "medianResponseSeconds": null,
  "responseSuppressed": null,
  "suppressed": null,
  "suppressionReason": null,
  "suppressionNote": null,
} satisfies GeoChild

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoChild
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


