
# AccountMutationResult


## Properties

Name | Type
------------ | -------------
`changed` | boolean
`verified` | boolean
`revoked` | boolean
`accepted` | boolean
`queued` | boolean
`signInRequired` | boolean
`next` | string

## Example

```typescript
import type { AccountMutationResult } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "changed": null,
  "verified": null,
  "revoked": null,
  "accepted": null,
  "queued": null,
  "signInRequired": null,
  "next": null,
} satisfies AccountMutationResult

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AccountMutationResult
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


