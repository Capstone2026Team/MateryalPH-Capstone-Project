
# AdminDashboardVendorHealthAttentionInner


## Properties

Name | Type
------------ | -------------
`vendorId` | string
`storeName` | string
`_class` | string
`label` | string
`vps` | string
`ohs` | string
`reasons` | Array&lt;string&gt;

## Example

```typescript
import type { AdminDashboardVendorHealthAttentionInner } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "storeName": null,
  "_class": null,
  "label": null,
  "vps": null,
  "ohs": null,
  "reasons": null,
} satisfies AdminDashboardVendorHealthAttentionInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardVendorHealthAttentionInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


