
# CheckoutPreview


## Properties

Name | Type
------------ | -------------
`requestVersion` | string
`cartLockVersion` | number
`currentAsOf` | Date
`calculationVersion` | string
`destination` | [CartDestination](CartDestination.md)
`groups` | [Array&lt;CheckoutGroupPreview&gt;](CheckoutGroupPreview.md)
`summary` | [CheckoutPreviewSummary](CheckoutPreviewSummary.md)

## Example

```typescript
import type { CheckoutPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "requestVersion": null,
  "cartLockVersion": null,
  "currentAsOf": null,
  "calculationVersion": null,
  "destination": null,
  "groups": null,
  "summary": null,
} satisfies CheckoutPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


