
# ActivationRestrictions

StoreActivationGate result explained by source revision. There is no override; teams and products never block.

## Properties

Name | Type
------------ | -------------
`ready` | boolean
`status` | string
`ruleVersion` | string
`evaluatedAt` | Date
`blockers` | [Array&lt;ActivationBlocker&gt;](ActivationBlocker.md)
`categories` | Array&lt;string&gt;
`notBlocking` | Array&lt;string&gt;
`overrideAvailable` | boolean

## Example

```typescript
import type { ActivationRestrictions } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "ready": null,
  "status": null,
  "ruleVersion": null,
  "evaluatedAt": null,
  "blockers": null,
  "categories": null,
  "notBlocking": null,
  "overrideAvailable": null,
} satisfies ActivationRestrictions

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ActivationRestrictions
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


