
# GeoTrendPoint


## Properties

Name | Type
------------ | -------------
`bucket` | Date
`grossGmvCentavos` | number
`netGmvCentavos` | number
`orderVolume` | number
`suppressed` | boolean
`reason` | string

## Example

```typescript
import type { GeoTrendPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "bucket": null,
  "grossGmvCentavos": null,
  "netGmvCentavos": null,
  "orderVolume": null,
  "suppressed": null,
  "reason": null,
} satisfies GeoTrendPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoTrendPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


