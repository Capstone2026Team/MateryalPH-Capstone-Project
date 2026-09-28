
# AutoAcceptPolicyDetailStock


## Properties

Name | Type
------------ | -------------
`quantityOnHand` | string
`hardReservedQuantity` | string
`softHeldQuantity` | string
`availableToSell` | string

## Example

```typescript
import type { AutoAcceptPolicyDetailStock } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "quantityOnHand": null,
  "hardReservedQuantity": null,
  "softHeldQuantity": null,
  "availableToSell": null,
} satisfies AutoAcceptPolicyDetailStock

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutoAcceptPolicyDetailStock
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


