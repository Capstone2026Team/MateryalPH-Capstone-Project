
# CounterpartRating


## Properties

Name | Type
------------ | -------------
`ratings` | [ReviewRatings](ReviewRatings.md)
`comment` | string
`displayName` | string
`submittedAt` | Date

## Example

```typescript
import type { CounterpartRating } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "ratings": null,
  "comment": null,
  "displayName": null,
  "submittedAt": null,
} satisfies CounterpartRating

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CounterpartRating
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


