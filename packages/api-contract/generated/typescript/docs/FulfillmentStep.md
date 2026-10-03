
# FulfillmentStep


## Properties

Name | Type
------------ | -------------
`key` | string
`label` | string
`status` | string
`at` | Date
`actorRole` | string
`proofRequired` | boolean
`proof` | [FulfillmentProof](FulfillmentProof.md)
`proofRequirements` | Array&lt;string&gt;

## Example

```typescript
import type { FulfillmentStep } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "label": null,
  "status": null,
  "at": null,
  "actorRole": null,
  "proofRequired": null,
  "proof": null,
  "proofRequirements": null,
} satisfies FulfillmentStep

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentStep
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


