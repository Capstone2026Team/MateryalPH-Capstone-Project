
# RankingWeightSet

Independent whole importance values for the five Item-Based SRS components. At least one must be above zero; their sum need not be 100. Persisted unchanged; scoring uses each value divided by their sum. Platform defaults still total 100.

## Properties

Name | Type
------------ | -------------
`distance` | number
`price` | number
`vps` | number
`stock` | number
`productRating` | number

## Example

```typescript
import type { RankingWeightSet } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "distance": null,
  "price": null,
  "vps": null,
  "stock": null,
  "productRating": null,
} satisfies RankingWeightSet

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RankingWeightSet
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


