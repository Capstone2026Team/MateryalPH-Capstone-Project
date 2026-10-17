
# VendorWorkstreamsProviderReadiness


## Properties

Name | Type
------------ | -------------
`status` | string
`providerStatus` | string
`environment` | string
`lastErrorCode` | string
`lastReconciledAt` | Date
`note` | string

## Example

```typescript
import type { VendorWorkstreamsProviderReadiness } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "providerStatus": null,
  "environment": null,
  "lastErrorCode": null,
  "lastReconciledAt": null,
  "note": null,
} satisfies VendorWorkstreamsProviderReadiness

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorWorkstreamsProviderReadiness
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


