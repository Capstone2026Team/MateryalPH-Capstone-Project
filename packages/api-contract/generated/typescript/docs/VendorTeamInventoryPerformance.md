
# VendorTeamInventoryPerformance


## Properties

Name | Type
------------ | -------------
`stockUpdates` | number
`stockConfirmations` | number
`listingsCreated` | number
`listingUpdates` | number
`complianceSubmissions` | number
`allotmentUpdates` | number
`unsuccessful` | number

## Example

```typescript
import type { VendorTeamInventoryPerformance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "stockUpdates": null,
  "stockConfirmations": null,
  "listingsCreated": null,
  "listingUpdates": null,
  "complianceSubmissions": null,
  "allotmentUpdates": null,
  "unsuccessful": null,
} satisfies VendorTeamInventoryPerformance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamInventoryPerformance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


