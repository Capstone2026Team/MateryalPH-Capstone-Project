
# FleetVehicleListMeta


## Properties

Name | Type
------------ | -------------
`scope` | string
`delivery` | [FleetVehicleListMetaDelivery](FleetVehicleListMetaDelivery.md)
`permissions` | [FleetVehicleListMetaPermissions](FleetVehicleListMetaPermissions.md)
`limits` | [FleetVehicleListMetaLimits](FleetVehicleListMetaLimits.md)

## Example

```typescript
import type { FleetVehicleListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "scope": null,
  "delivery": null,
  "permissions": null,
  "limits": null,
} satisfies FleetVehicleListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FleetVehicleListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


