
# VendorCommissionTerms


## Properties

Name | Type
------------ | -------------
`agreement` | { [key: string]: any; }
`commissionBasisPoints` | number
`basis` | string
`cadence` | string
`environment` | string
`contentAvailable` | boolean

## Example

```typescript
import type { VendorCommissionTerms } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "agreement": null,
  "commissionBasisPoints": null,
  "basis": null,
  "cadence": null,
  "environment": null,
  "contentAvailable": null,
} satisfies VendorCommissionTerms

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorCommissionTerms
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


