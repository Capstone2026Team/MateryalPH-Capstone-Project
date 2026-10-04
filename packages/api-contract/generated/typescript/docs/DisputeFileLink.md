
# DisputeFileLink

A five-minute signed URL; the fetch also re-authorizes the signed-in caller.

## Properties

Name | Type
------------ | -------------
`url` | string
`expiresAt` | Date

## Example

```typescript
import type { DisputeFileLink } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "url": null,
  "expiresAt": null,
} satisfies DisputeFileLink

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeFileLink
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


