
# SupportUpdate


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`reason` | string
`status` | [SupportStatus](SupportStatus.md)
`assignedAdminId` | string

## Example

```typescript
import type { SupportUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "reason": null,
  "status": null,
  "assignedAdminId": null,
} satisfies SupportUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupportUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


