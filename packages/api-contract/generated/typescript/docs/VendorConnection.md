
# VendorConnection


## Properties

Name | Type
------------ | -------------
`providerStatus` | string
`connectionError` | string
`environment` | string
`status` | string
`evidenceOrigin` | string
`checkedAt` | string

## Example

```typescript
import type { VendorConnection } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "providerStatus": null,
  "connectionError": null,
  "environment": null,
  "status": null,
  "evidenceOrigin": null,
  "checkedAt": null,
} satisfies VendorConnection

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorConnection
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


