
# ReviewRatings


## Properties

Name | Type
------------ | -------------
`serviceQuality` | number
`speedRating` | number
`speedKind` | string
`productQuality` | number
`inquirySeriousness` | number
`communicationQuality` | number
`paymentReliability` | number

## Example

```typescript
import type { ReviewRatings } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "serviceQuality": null,
  "speedRating": null,
  "speedKind": null,
  "productQuality": null,
  "inquirySeriousness": null,
  "communicationQuality": null,
  "paymentReliability": null,
} satisfies ReviewRatings

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReviewRatings
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


