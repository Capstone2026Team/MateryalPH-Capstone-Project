
# ReviewMediaLink

A five-minute signed link; the fetch re-authorizes the caller.

## Properties

Name | Type
------------ | -------------
`id` | string
`url` | string
`expiresAt` | Date
`contentType` | string
`byteSize` | number

## Example

```typescript
import type { ReviewMediaLink } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "url": null,
  "expiresAt": null,
  "contentType": null,
  "byteSize": null,
} satisfies ReviewMediaLink

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReviewMediaLink
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


