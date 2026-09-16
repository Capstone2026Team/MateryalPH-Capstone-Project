
# VendorOnboardingSnapshot


## Properties

Name | Type
------------ | -------------
`organization` | { [key: string]: any; }
`sections` | [{ [key: string]: VendorOnboardingSection; }](VendorOnboardingSection.md)
`verification` | { [key: string]: any; }
`setup` | { [key: string]: any; }
`activation` | { [key: string]: any; }
`welcomeRequired` | boolean
`permissions` | Array&lt;string&gt;

## Example

```typescript
import type { VendorOnboardingSnapshot } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
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


