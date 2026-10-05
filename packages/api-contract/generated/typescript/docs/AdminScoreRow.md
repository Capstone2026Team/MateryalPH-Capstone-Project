
# AdminScoreRow


## Properties

Name | Type
------------ | -------------
`vendorId` | string
`storeName` | string
`scores` | [PublicScores](PublicScores.md)
`crr` | string
`frr` | string
`sampleCounts` | { [key: string]: any; }
`activeSuppressions` | number
`activeExclusions` | number

## Example

```typescript
import type { AdminScoreRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "storeName": null,
  "scores": null,
  "crr": null,
  "frr": null,
  "sampleCounts": null,
  "activeSuppressions": null,
  "activeExclusions": null,
} satisfies AdminScoreRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminScoreRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


