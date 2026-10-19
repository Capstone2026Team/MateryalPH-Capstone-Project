
# CommissionPolicies


## Properties

Name | Type
------------ | -------------
`current` | [CommissionPolicy](CommissionPolicy.md)
`next` | [CommissionPolicy](CommissionPolicy.md)
`latestVersion` | number
`canManage` | boolean
`versions` | [Array&lt;CommissionPolicy&gt;](CommissionPolicy.md)

## Example

```typescript
import type { CommissionPolicies } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "current": null,
  "next": null,
  "latestVersion": null,
  "canManage": null,
  "versions": null,
} satisfies CommissionPolicies

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CommissionPolicies
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


