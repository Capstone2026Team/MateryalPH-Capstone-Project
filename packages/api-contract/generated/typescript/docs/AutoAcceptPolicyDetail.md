
# AutoAcceptPolicyDetail


## Properties

Name | Type
------------ | -------------
`listingVariantId` | string
`listingId` | string
`listingName` | string
`listingStatus` | [ListingStatus](ListingStatus.md)
`variantLabel` | string
`sku` | string
`unitCode` | string
`stock` | [AutoAcceptPolicyDetailStock](AutoAcceptPolicyDetailStock.md)
`policy` | [AutoAcceptPolicy](AutoAcceptPolicy.md)
`versions` | [Array&lt;AutoAcceptPolicyVersion&gt;](AutoAcceptPolicyVersion.md)
`scope` | [AutoAcceptPolicyDetailScope](AutoAcceptPolicyDetailScope.md)
`permissions` | [AutoAcceptPolicyDetailPermissions](AutoAcceptPolicyDetailPermissions.md)

## Example

```typescript
import type { AutoAcceptPolicyDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "listingVariantId": null,
  "listingId": null,
  "listingName": null,
  "listingStatus": null,
  "variantLabel": null,
  "sku": null,
  "unitCode": null,
  "stock": null,
  "policy": null,
  "versions": null,
  "scope": null,
  "permissions": null,
} satisfies AutoAcceptPolicyDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutoAcceptPolicyDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


