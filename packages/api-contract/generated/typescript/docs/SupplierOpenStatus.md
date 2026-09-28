
# SupplierOpenStatus

Descriptive only. Derived from saved public hours in Asia/Manila; never filters, ranks or implies stock or staff presence.

## Properties

Name | Type
------------ | -------------
`status` | string
`opensAt` | string
`closesAt` | string
`basis` | string

## Example

```typescript
import type { SupplierOpenStatus } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "opensAt": null,
  "closesAt": null,
  "basis": null,
} satisfies SupplierOpenStatus

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupplierOpenStatus
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


