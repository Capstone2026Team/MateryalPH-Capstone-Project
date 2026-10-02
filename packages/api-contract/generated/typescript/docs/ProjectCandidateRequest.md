
# ProjectCandidateRequest


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`candidateId` | string
`note` | string
`budgetOverrideReason` | string

## Example

```typescript
import type { ProjectCandidateRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "candidateId": null,
  "note": null,
  "budgetOverrideReason": null,
} satisfies ProjectCandidateRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectCandidateRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


