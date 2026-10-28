
# ChatQuotationDestination

Item-Based Vendor proposal, subject to Buyer review and acceptance. Omit address IDs to use the location shared in the inquiry. Work Package destinations stay locked.

## Properties

Name | Type
------------ | -------------
`intendedAddress` | string
`alternateAddress` | string
`intendedAddressId` | string
`alternateAddressId` | string
`heavyVehicleRestriction` | string
`accessInstructions` | string

## Example

```typescript
import type { ChatQuotationDestination } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "intendedAddress": null,
  "alternateAddress": null,
  "intendedAddressId": null,
  "alternateAddressId": null,
  "heavyVehicleRestriction": null,
  "accessInstructions": null,
} satisfies ChatQuotationDestination

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatQuotationDestination
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


