
# CheckoutSubmitRequest


## Properties

Name | Type
------------ | -------------
`cartLockVersion` | number
`vendorIds` | Set&lt;string&gt;
`splitConfirmed` | boolean
`paymentMethods` | { [key: string]: string; }

## Example

```typescript
import type { CheckoutSubmitRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "cartLockVersion": null,
  "vendorIds": null,
  "splitConfirmed": null,
  "paymentMethods": null,
} satisfies CheckoutSubmitRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutSubmitRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


