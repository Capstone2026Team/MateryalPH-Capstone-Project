
# ListingFulfillmentSummary


## Properties

Name | Type
------------ | -------------
`pickupAvailable` | boolean
`delivery` | string
`basis` | string

## Example

```typescript
import type { ListingFulfillmentSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "pickupAvailable": null,
  "delivery": null,
  "basis": null,
} satisfies ListingFulfillmentSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingFulfillmentSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


