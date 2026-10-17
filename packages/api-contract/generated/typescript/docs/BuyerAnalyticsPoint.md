
# BuyerAnalyticsPoint


## Properties

Name | Type
------------ | -------------
`date` | Date
`status` | string
`label` | string
`averagePhp` | string
`vendorCount` | number
`participantsChanged` | boolean

## Example

```typescript
import type { BuyerAnalyticsPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "status": null,
  "label": null,
  "averagePhp": null,
  "vendorCount": null,
  "participantsChanged": null,
} satisfies BuyerAnalyticsPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerAnalyticsPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


