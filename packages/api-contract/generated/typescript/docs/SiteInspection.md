
# SiteInspection


## Properties

Name | Type
------------ | -------------
`id` | string
`status` | string
`lockVersion` | number
`listing` | [SiteInspectionListing](SiteInspectionListing.md)
`variant` | [SiteInspectionVariant](SiteInspectionVariant.md)
`site` | [SiteInspectionSite](SiteInspectionSite.md)
`preferredDate` | Date
`buyerNotes` | string
`scheduledFor` | Date
`vendorNote` | string
`measuredVolumeM3` | string
`requestedAt` | Date
`closedAt` | Date
`free` | boolean
`actions` | [SiteInspectionActions](SiteInspectionActions.md)

## Example

```typescript
import type { SiteInspection } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "status": null,
  "lockVersion": null,
  "listing": null,
  "variant": null,
  "site": null,
  "preferredDate": null,
  "buyerNotes": null,
  "scheduledFor": null,
  "vendorNote": null,
  "measuredVolumeM3": null,
  "requestedAt": null,
  "closedAt": null,
  "free": null,
  "actions": null,
} satisfies SiteInspection

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SiteInspection
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


