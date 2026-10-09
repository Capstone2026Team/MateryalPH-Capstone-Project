
# OperationRetryRecord


## Properties

Name | Type
------------ | -------------
`targetType` | string
`label` | string
`reason` | string
`outcome` | string
`actor` | string
`actorRole` | string
`correlationId` | string
`createdAt` | Date

## Example

```typescript
import type { OperationRetryRecord } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "targetType": null,
  "label": null,
  "reason": null,
  "outcome": null,
  "actor": null,
  "actorRole": null,
  "correlationId": null,
  "createdAt": null,
} satisfies OperationRetryRecord

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OperationRetryRecord
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


