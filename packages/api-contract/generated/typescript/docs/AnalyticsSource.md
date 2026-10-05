
# AnalyticsSource


## Properties

Name | Type
------------ | -------------
`observationId` | string
`storeName` | string
`listingId` | string
`displayName` | string
`variantLabel` | string
`priceVersion` | number
`ordinaryPayableCentavos` | number
`normalizedPhpExact` | string
`taxCategory` | string
`capturedAt` | Date
`priceEffectiveAt` | Date
`selectedForAverage` | boolean
`exclusionReason` | string
`geography` | { [key: string]: any; }

## Example

```typescript
import type { AnalyticsSource } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "observationId": null,
  "storeName": null,
  "listingId": null,
  "displayName": null,
  "variantLabel": null,
  "priceVersion": null,
  "ordinaryPayableCentavos": null,
  "normalizedPhpExact": null,
  "taxCategory": null,
  "capturedAt": null,
  "priceEffectiveAt": null,
  "selectedForAverage": null,
  "exclusionReason": null,
  "geography": null,
} satisfies AnalyticsSource

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AnalyticsSource
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


