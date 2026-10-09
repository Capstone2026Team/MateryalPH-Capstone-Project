
# GeoKpis


## Properties

Name | Type
------------ | -------------
`vendorCount` | [GeoCell](GeoCell.md)
`registeredBuyers` | [GeoCell](GeoCell.md)
`grossGmvCentavos` | [GeoCell](GeoCell.md)
`netGmvCentavos` | [GeoCell](GeoCell.md)
`orderVolume` | [GeoCell](GeoCell.md)
`fulfillmentRate` | [GeoRate](GeoRate.md)
`cancellationRate` | [GeoRate](GeoRate.md)
`disputeRate` | [GeoRate](GeoRate.md)
`responseTime` | [GeoResponseTime](GeoResponseTime.md)
`activeUsers` | [GeoKpisActiveUsers](GeoKpisActiveUsers.md)

## Example

```typescript
import type { GeoKpis } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorCount": null,
  "registeredBuyers": null,
  "grossGmvCentavos": null,
  "netGmvCentavos": null,
  "orderVolume": null,
  "fulfillmentRate": null,
  "cancellationRate": null,
  "disputeRate": null,
  "responseTime": null,
  "activeUsers": null,
} satisfies GeoKpis

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoKpis
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


