
# DisputeRemedy


## Properties

Name | Type
------------ | -------------
`id` | string
`kind` | string
`state` | string
`amountCentavos` | number
`note` | string
`recorded` | boolean
`completedAt` | Date
`decisionId` | string
`evidence` | [DisputeFileLink](DisputeFileLink.md)
`canRecord` | boolean
`canConfirm` | boolean

## Example

```typescript
import type { DisputeRemedy } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "kind": null,
  "state": null,
  "amountCentavos": null,
  "note": null,
  "recorded": null,
  "completedAt": null,
  "decisionId": null,
  "evidence": null,
  "canRecord": null,
  "canConfirm": null,
} satisfies DisputeRemedy

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeRemedy
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


