
# SupplierServiceability

Advisory straight-line comparison with the Vendor\'s stated delivery distance; actual serviceability is revalidated at checkout.

## Properties

Name | Type
------------ | -------------
`pickupAvailable` | boolean
`delivery` | string
`deliveryMaximumKm` | number
`basis` | string

## Example

```typescript
import type { SupplierServiceability } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "pickupAvailable": null,
  "delivery": null,
  "deliveryMaximumKm": null,
  "basis": null,
} satisfies SupplierServiceability

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupplierServiceability
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


