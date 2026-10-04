
# DisputeAppeal


## Properties

Name | Type
------------ | -------------
`id` | string
`appellantParty` | string
`grounds` | string
`statement` | string
`state` | string
`filedAt` | Date
`decidedAt` | Date
`appealedDecisionId` | string
`resultDecisionId` | string

## Example

```typescript
import type { DisputeAppeal } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "appellantParty": null,
  "grounds": null,
  "statement": null,
  "state": null,
  "filedAt": null,
  "decidedAt": null,
  "appealedDecisionId": null,
  "resultDecisionId": null,
} satisfies DisputeAppeal

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeAppeal
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


