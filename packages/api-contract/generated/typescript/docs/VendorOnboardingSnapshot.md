
# VendorOnboardingSnapshot


## Properties

Name | Type
------------ | -------------
`stepCompletion` | [Array&lt;OnboardingStepCompletion&gt;](OnboardingStepCompletion.md)
`lockVersion` | number
`requirements` | [Array&lt;OnboardingRequirement&gt;](OnboardingRequirement.md)
`drafts` | [Array&lt;OnboardingDraftVersion&gt;](OnboardingDraftVersion.md)
`organization` | { [key: string]: any; }
`sections` | [{ [key: string]: VendorOnboardingSection; }](VendorOnboardingSection.md)
`verification` | { [key: string]: any; }
`setup` | [VendorOnboardingSnapshotSetup](VendorOnboardingSnapshotSetup.md)
`activation` | [VendorActivationSnapshot](VendorActivationSnapshot.md)
`welcomeRequired` | boolean
`permissions` | Array&lt;string&gt;

## Example

```typescript
import type { VendorOnboardingSnapshot } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "stepCompletion": null,
  "lockVersion": null,
  "requirements": null,
  "drafts": null,
  "organization": null,
  "sections": null,
  "verification": null,
  "setup": null,
  "activation": null,
  "welcomeRequired": null,
  "permissions": null,
} satisfies VendorOnboardingSnapshot

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOnboardingSnapshot
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


