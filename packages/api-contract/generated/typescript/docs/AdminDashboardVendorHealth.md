
# AdminDashboardVendorHealth

scores.view. Indicator classes only; no flag, warning or sanction is created.

## Properties

Name | Type
------------ | -------------
`total` | number
`classes` | [Array&lt;AdminDashboardVendorHealthClassesInner&gt;](AdminDashboardVendorHealthClassesInner.md)
`attention` | [Array&lt;AdminDashboardVendorHealthAttentionInner&gt;](AdminDashboardVendorHealthAttentionInner.md)
`segments` | [AdminDashboardVendorHealthSegments](AdminDashboardVendorHealthSegments.md)

## Example

```typescript
import type { AdminDashboardVendorHealth } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "total": null,
  "classes": null,
  "attention": null,
  "segments": null,
} satisfies AdminDashboardVendorHealth

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardVendorHealth
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


