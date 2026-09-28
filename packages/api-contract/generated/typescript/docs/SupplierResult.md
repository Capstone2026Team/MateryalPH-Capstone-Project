
# SupplierResult


## Properties

Name | Type
------------ | -------------
`resultId` | string
`tier` | [SupplierTier](SupplierTier.md)
`tierLabel` | string
`rank` | number
`name` | string
`marker` | [MapPoint](MapPoint.md)
`distanceMeters` | number
`scoreLabel` | [ScoreLabel](ScoreLabel.md)
`isFavorite` | boolean
`vendor` | [VerifiedVendorSummary](VerifiedVendorSummary.md)
`directory` | [DirectorySupplierSummary](DirectorySupplierSummary.md)

## Example

```typescript
import type { SupplierResult } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "resultId": null,
  "tier": null,
  "tierLabel": null,
  "rank": null,
  "name": null,
  "marker": null,
  "distanceMeters": null,
  "scoreLabel": null,
  "isFavorite": null,
  "vendor": null,
  "directory": null,
} satisfies SupplierResult

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupplierResult
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


