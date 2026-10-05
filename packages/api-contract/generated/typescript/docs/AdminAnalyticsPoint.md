
# AdminAnalyticsPoint


## Properties

Name | Type
------------ | -------------
`date` | Date
`status` | string
`label` | string
`averagePhp` | string
`averagePhpExact` | string
`vendorCount` | number
`participantsChanged` | boolean

## Example

```typescript
import type { AdminAnalyticsPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "status": null,
  "label": null,
  "averagePhp": null,
  "averagePhpExact": null,
  "vendorCount": null,
  "participantsChanged": null,
} satisfies AdminAnalyticsPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminAnalyticsPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


