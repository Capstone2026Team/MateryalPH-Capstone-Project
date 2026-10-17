
# DisputeExport


## Properties

Name | Type
------------ | -------------
`id` | string
`state` | string
`rowCount` | number
`requestedAt` | Date
`completedAt` | Date
`expiresAt` | Date
`revocationReason` | string

## Example

```typescript
import type { DisputeExport } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "state": null,
  "rowCount": null,
  "requestedAt": null,
  "completedAt": null,
  "expiresAt": null,
  "revocationReason": null,
} satisfies DisputeExport

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeExport
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


