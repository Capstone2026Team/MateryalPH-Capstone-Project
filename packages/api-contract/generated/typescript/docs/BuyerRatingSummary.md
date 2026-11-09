
# BuyerRatingSummary


## Properties

Name | Type
------------ | -------------
`score` | number
`count` | number
`minimumCount` | number
`windowDays` | number
`inquirySeriousness` | number
`communicationQuality` | number
`paymentReliability` | number

## Example

```typescript
import type { BuyerRatingSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "score": null,
  "count": null,
  "minimumCount": null,
  "windowDays": null,
  "inquirySeriousness": null,
  "communicationQuality": null,
  "paymentReliability": null,
} satisfies BuyerRatingSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerRatingSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


