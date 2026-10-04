
# DisputeProposal


## Properties

Name | Type
------------ | -------------
`id` | string
`proposedByParty` | string
`remedy` | string
`amountCentavos` | number
`terms` | string
`state` | string
`proposedAt` | Date
`answeredAt` | Date
`canAnswer` | boolean

## Example

```typescript
import type { DisputeProposal } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "proposedByParty": null,
  "remedy": null,
  "amountCentavos": null,
  "terms": null,
  "state": null,
  "proposedAt": null,
  "answeredAt": null,
  "canAnswer": null,
} satisfies DisputeProposal

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeProposal
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


