
# AutoAcceptOutcome


## Properties

Name | Type
------------ | -------------
`accepted` | boolean
`routedTo` | string
`reasons` | [Array&lt;AutoAcceptReason&gt;](AutoAcceptReason.md)
`ruleVersion` | string
`evaluatedAt` | Date

## Example

```typescript
import type { AutoAcceptOutcome } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "accepted": null,
  "routedTo": null,
  "reasons": null,
  "ruleVersion": null,
  "evaluatedAt": null,
} satisfies AutoAcceptOutcome

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutoAcceptOutcome
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


