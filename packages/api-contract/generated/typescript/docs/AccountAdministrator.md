
# AccountAdministrator


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`role` | string
`roleId` | string
`status` | string
`lockVersion` | number

## Example

```typescript
import type { AccountAdministrator } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "role": null,
  "roleId": null,
  "status": null,
  "lockVersion": null,
} satisfies AccountAdministrator

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AccountAdministrator
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


