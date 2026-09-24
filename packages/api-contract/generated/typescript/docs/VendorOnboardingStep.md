
# VendorOnboardingStep


## Properties

Name | Type
------------ | -------------
`id` | string
`key` | string
`label` | string
`level` | string
`status` | string
`reason` | string
`lockVersion` | number
`submittedAt` | Date
`reviewedAt` | Date

## Example

```typescript
import type { VendorOnboardingStep } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "key": null,
  "label": null,
  "level": null,
  "status": null,
  "reason": null,
  "lockVersion": null,
  "submittedAt": null,
  "reviewedAt": null,
} satisfies VendorOnboardingStep

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOnboardingStep
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


