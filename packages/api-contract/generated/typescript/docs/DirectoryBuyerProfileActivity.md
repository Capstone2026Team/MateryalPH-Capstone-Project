
# DirectoryBuyerProfileActivity


## Properties

Name | Type
------------ | -------------
`ordersTotal` | number
`ordersOpen` | number
`ordersCompleted` | number
`ordersCancelled` | number
`quotationsTotal` | number
`quotationsAccepted` | number
`projectsTotal` | number
`workPackagesTotal` | number
`conversationsTotal` | number
`favoriteStores` | number
`disputesTotal` | number
`disputesOpen` | number
`signIns30Days` | number
`lastActiveAt` | Date

## Example

```typescript
import type { DirectoryBuyerProfileActivity } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "ordersTotal": null,
  "ordersOpen": null,
  "ordersCompleted": null,
  "ordersCancelled": null,
  "quotationsTotal": null,
  "quotationsAccepted": null,
  "projectsTotal": null,
  "workPackagesTotal": null,
  "conversationsTotal": null,
  "favoriteStores": null,
  "disputesTotal": null,
  "disputesOpen": null,
  "signIns30Days": null,
  "lastActiveAt": null,
} satisfies DirectoryBuyerProfileActivity

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryBuyerProfileActivity
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


