
# FleetSummary

Saved fleet counts for the current Vendor organization. Unit totals use number_available, not configuration row counts. Delivery assignments use immutable accepted snapshots on orders currently OUT_FOR_DELIVERY, including subsequently disabled or removed configurations; they are not unique physical vehicles or trip counts and do not reduce manually configured availability.

## Properties

Name | Type
------------ | -------------
`configurations` | number
`totalVehicles` | number
`activeVehicles` | number
`availableVehicles` | number
`outForDeliveryVehicleAssignments` | number
`outForDeliveryOrders` | number

## Example

```typescript
import type { FleetSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "configurations": null,
  "totalVehicles": null,
  "activeVehicles": null,
  "availableVehicles": null,
  "outForDeliveryVehicleAssignments": null,
  "outForDeliveryOrders": null,
} satisfies FleetSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FleetSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


