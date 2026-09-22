
# VendorActivationSnapshot


## Properties

Name | Type
------------ | -------------
`status` | string
`marketplaceDiscoverabilityStatus` | string
`readiness` | [StoreActivationReadiness](StoreActivationReadiness.md)

## Example

```typescript
import type { VendorActivationSnapshot } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "marketplaceDiscoverabilityStatus": null,
  "readiness": null,
} satisfies VendorActivationSnapshot

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorActivationSnapshot
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


