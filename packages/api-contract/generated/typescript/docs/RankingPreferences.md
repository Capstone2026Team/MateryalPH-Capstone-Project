
# RankingPreferences


## Properties

Name | Type
------------ | -------------
`procurementType` | string
`weights` | [RankingWeightSet](RankingWeightSet.md)
`defaultWeights` | [RankingWeightSet](RankingWeightSet.md)
`defaultsVersion` | number
`personalized` | boolean
`version` | number
`totalPercent` | number
`algorithmVersion` | string

## Example

```typescript
import type { RankingPreferences } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "procurementType": null,
  "weights": null,
  "defaultWeights": null,
  "defaultsVersion": null,
  "personalized": null,
  "version": null,
  "totalPercent": null,
  "algorithmVersion": null,
} satisfies RankingPreferences

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RankingPreferences
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


