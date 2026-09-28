
# StaleListing


## Properties

Name | Type
------------ | -------------
`listingId` | string
`listingName` | string
`listingStatus` | [ListingStatus](ListingStatus.md)
`confirmation` | [StockConfirmationSchedule](StockConfirmationSchedule.md)

## Example

```typescript
import type { StaleListing } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingId": null,
  "listingName": null,
  "listingStatus": null,
  "confirmation": null,
} satisfies StaleListing

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as StaleListing
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


