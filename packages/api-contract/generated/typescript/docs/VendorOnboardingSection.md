
# VendorOnboardingSection


## Properties

Name | Type
------------ | -------------
`key` | string
`label` | string
`status` | string
`complete` | number
`total` | number
`progress` | { [key: string]: any; }
`steps` | [Array&lt;VendorOnboardingStep&gt;](VendorOnboardingStep.md)

## Example

```typescript
import type { VendorOnboardingSection } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "label": null,
  "status": null,
  "complete": null,
  "total": null,
  "progress": null,
  "steps": null,
} satisfies VendorOnboardingSection

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOnboardingSection
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


