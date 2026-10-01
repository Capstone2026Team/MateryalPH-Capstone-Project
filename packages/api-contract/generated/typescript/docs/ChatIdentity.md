
# ChatIdentity


## Properties

Name | Type
------------ | -------------
`displayName` | string
`role` | string
`avatarPath` | string

## Example

```typescript
import type { ChatIdentity } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "displayName": null,
  "role": null,
  "avatarPath": null,
} satisfies ChatIdentity

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatIdentity
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


