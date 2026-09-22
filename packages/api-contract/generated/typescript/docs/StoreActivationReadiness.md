
# StoreActivationReadiness


## Properties

Name | Type
------------ | -------------
`ready` | boolean
`status` | string
`ruleVersion` | string
`blockers` | [Array&lt;StoreActivationBlocker&gt;](StoreActivationBlocker.md)

## Example

```typescript
import type { StoreActivationReadiness } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "ready": null,
  "status": null,
  "ruleVersion": null,
  "blockers": null,
} satisfies StoreActivationReadiness

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as StoreActivationReadiness
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


