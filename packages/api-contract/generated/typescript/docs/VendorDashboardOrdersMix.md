
# VendorDashboardOrdersMix


## Properties

Name | Type
------------ | -------------
`procurement` | [Array&lt;DashboardCount&gt;](DashboardCount.md)
`fulfillment` | [Array&lt;DashboardCount&gt;](DashboardCount.md)
`payment` | [Array&lt;DashboardCount&gt;](DashboardCount.md)

## Example

```typescript
import type { VendorDashboardOrdersMix } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "procurement": null,
  "fulfillment": null,
  "payment": null,
} satisfies VendorDashboardOrdersMix

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersMix
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


