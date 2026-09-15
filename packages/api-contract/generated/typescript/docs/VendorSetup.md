
# VendorSetup


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`bulkOrderCapable` | boolean
`store` | [VendorStore](VendorStore.md)
`hours` | [Array&lt;VendorOperatingDay&gt;](VendorOperatingDay.md)
`deliveryVehicles` | [Array&lt;VendorVehicle&gt;](VendorVehicle.md)
`payment` | [VendorConnection](VendorConnection.md)
`withholdingDemoScenario` | string
`productionWithholdingAssignment` | string
`environment` | string

## Example

```typescript
import type { VendorSetup } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "bulkOrderCapable": null,
  "store": null,
  "hours": null,
  "deliveryVehicles": null,
  "payment": null,
  "withholdingDemoScenario": null,
  "productionWithholdingAssignment": null,
  "environment": null,
} satisfies VendorSetup

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorSetup
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


