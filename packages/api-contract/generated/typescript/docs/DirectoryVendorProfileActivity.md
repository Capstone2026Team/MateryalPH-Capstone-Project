
# DirectoryVendorProfileActivity


## Properties

Name | Type
------------ | -------------
`quotesSent` | number
`quotesAccepted` | number
`ordersTotal` | number
`ordersFulfilled` | number
`ordersOpen` | number
`ordersCancelled` | number
`disputesTotal` | number
`disputesOpen` | number
`listingsTotal` | number
`listingsActive` | number
`teamMembers` | number
`lastLoginAt` | Date
`signIns30Days` | number

## Example

```typescript
import type { DirectoryVendorProfileActivity } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "quotesSent": null,
  "quotesAccepted": null,
  "ordersTotal": null,
  "ordersFulfilled": null,
  "ordersOpen": null,
  "ordersCancelled": null,
  "disputesTotal": null,
  "disputesOpen": null,
  "listingsTotal": null,
  "listingsActive": null,
  "teamMembers": null,
  "lastLoginAt": null,
  "signIns30Days": null,
} satisfies DirectoryVendorProfileActivity

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryVendorProfileActivity
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


