
# VendorDeliverySetup

Live eligibility for new deliveries only. Existing delivery orders, assignments and accepted snapshots remain intact. Private to the Owner and Store Manager.

## Properties

Name | Type
------------ | -------------
`fulfillmentMethod` | string
`staffReady` | boolean
`vehicleReady` | boolean
`pickupLocationReady` | boolean
`serviceSettingsReady` | boolean
`ready` | boolean
`enabled` | boolean
`available` | boolean
`activeDeliveryObligations` | number

## Example

```typescript
import type { VendorDeliverySetup } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fulfillmentMethod": null,
  "staffReady": null,
  "vehicleReady": null,
  "pickupLocationReady": null,
  "serviceSettingsReady": null,
  "ready": null,
  "enabled": null,
  "available": null,
  "activeDeliveryObligations": null,
} satisfies VendorDeliverySetup

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDeliverySetup
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


