
# AccountSession


## Properties

Name | Type
------------ | -------------
`id` | string
`description` | string
`current` | boolean
`createdAt` | string
`lastActiveAt` | string

## Example

```typescript
import type { AccountSession } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "description": null,
  "current": null,
  "createdAt": null,
  "lastActiveAt": null,
} satisfies AccountSession

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AccountSession
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


