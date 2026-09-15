
# VendorDocumentReview


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`decision` | string
`reason` | string
`verifiedReference` | string
`verifiedIssuedOn` | string
`verifiedExpiresOn` | string
`verifiedExpiryNotApplicable` | boolean
`sourceReference` | string
`remarks` | string
`immediateRestriction` | boolean

## Example

```typescript
import type { VendorDocumentReview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "decision": null,
  "reason": null,
  "verifiedReference": null,
  "verifiedIssuedOn": null,
  "verifiedExpiresOn": null,
  "verifiedExpiryNotApplicable": null,
  "sourceReference": null,
  "remarks": null,
  "immediateRestriction": null,
} satisfies VendorDocumentReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDocumentReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


