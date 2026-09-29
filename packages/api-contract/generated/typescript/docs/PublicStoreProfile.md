
# PublicStoreProfile


## Properties

Name | Type
------------ | -------------
`id` | string
`vacationMode` | boolean
`publicStoreName` | string
`description` | string
`publicEmail` | string
`publicPhone` | string
`operatingSchedule` | [Array&lt;StoreOperatingDay&gt;](StoreOperatingDay.md)
`effectiveToday` | [StoreOperatingDay](StoreOperatingDay.md)
`effectiveDate` | Date
`effectiveSource` | string
`timeZone` | string
`logoUrl` | string
`bannerUrl` | string
`address` | [PublicAddressSummary](PublicAddressSummary.md)
`supplierType` | string
`niches` | Array&lt;string&gt;
`fulfillmentMethod` | string
`scoreLabel` | [ScoreLabel](ScoreLabel.md)
`hoursStatus` | string
`week` | [Array&lt;StoreHoursDay&gt;](StoreHoursDay.md)
`openNow` | [StoreOpenNow](StoreOpenNow.md)
`allClosed` | boolean
`hoursAsOf` | Date
`hoursNotice` | string
`hoursUnavailableReason` | string

## Example

```typescript
import type { PublicStoreProfile } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "vacationMode": null,
  "publicStoreName": null,
  "description": null,
  "publicEmail": null,
  "publicPhone": null,
  "operatingSchedule": null,
  "effectiveToday": null,
  "effectiveDate": null,
  "effectiveSource": null,
  "timeZone": null,
  "logoUrl": null,
  "bannerUrl": null,
  "address": null,
  "supplierType": null,
  "niches": null,
  "fulfillmentMethod": null,
  "scoreLabel": null,
  "hoursStatus": null,
  "week": null,
  "openNow": null,
  "allClosed": null,
  "hoursAsOf": null,
  "hoursNotice": null,
  "hoursUnavailableReason": null,
} satisfies PublicStoreProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PublicStoreProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


