
# ListingSearchRanking


## Properties

Name | Type
------------ | -------------
`weights` | [RankingWeightSet](RankingWeightSet.md)
`personalized` | boolean
`defaultWeights` | [RankingWeightSet](RankingWeightSet.md)
`tieBreakers` | Array&lt;string&gt;

## Example

```typescript
import type { ListingSearchRanking } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "weights": null,
  "personalized": null,
  "defaultWeights": null,
  "tieBreakers": null,
} satisfies ListingSearchRanking

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingSearchRanking
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


