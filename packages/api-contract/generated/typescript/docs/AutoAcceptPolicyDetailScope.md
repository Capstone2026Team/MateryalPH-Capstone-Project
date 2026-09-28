
# AutoAcceptPolicyDetailScope


## Properties

Name | Type
------------ | -------------
`itemBasedOnly` | boolean
`nrpcExcluded` | boolean
`projectBasedExcluded` | boolean
`ruleVersion` | string

## Example

```typescript
import type { AutoAcceptPolicyDetailScope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "itemBasedOnly": null,
  "nrpcExcluded": null,
  "projectBasedExcluded": null,
  "ruleVersion": null,
} satisfies AutoAcceptPolicyDetailScope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutoAcceptPolicyDetailScope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


