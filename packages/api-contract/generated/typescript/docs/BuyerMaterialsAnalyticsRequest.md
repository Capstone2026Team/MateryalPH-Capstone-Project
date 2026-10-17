
# BuyerMaterialsAnalyticsRequest

Origins travel in the body. Any other field (a role, competitor id or include flag) is refused with 422.

## Properties

Name | Type
------------ | -------------
`locationId` | string
`latitude` | number
`longitude` | number
`originSource` | string
`radiusKm` | number
`presetDays` | number
`startDate` | Date
`endDate` | Date
`categoryId` | string
`q` | string
`cursor` | string
`perPage` | number

## Example

```typescript
import type { BuyerMaterialsAnalyticsRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "locationId": null,
  "latitude": null,
  "longitude": null,
  "originSource": null,
  "radiusKm": null,
  "presetDays": null,
  "startDate": null,
  "endDate": null,
  "categoryId": null,
  "q": null,
  "cursor": null,
  "perPage": null,
} satisfies BuyerMaterialsAnalyticsRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerMaterialsAnalyticsRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


