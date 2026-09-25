
# VendorSetupDraft


## Properties

Name | Type
------------ | -------------
`draftLockVersion` | number
`organizationLockVersion` | number
`formState` | string
`publicStoreName` | string
`description` | string
`bulkCapability` | boolean
`fulfillmentMethod` | string
`publicEmail` | string
`publicPhone` | string
`operatingSchedule` | [Array&lt;StoreOperatingDay&gt;](StoreOperatingDay.md)
`delivery` | [VendorSetupDraftDelivery](VendorSetupDraftDelivery.md)
`vehicles` | [Array&lt;VendorSetupDraftVehiclesInner&gt;](VendorSetupDraftVehiclesInner.md)

## Example

```typescript
import type { VendorSetupDraft } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "draftLockVersion": null,
  "organizationLockVersion": null,
  "formState": null,
  "publicStoreName": null,
  "description": null,
  "bulkCapability": null,
  "fulfillmentMethod": null,
  "publicEmail": null,
  "publicPhone": null,
  "operatingSchedule": null,
  "delivery": null,
  "vehicles": null,
} satisfies VendorSetupDraft

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorSetupDraft
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


