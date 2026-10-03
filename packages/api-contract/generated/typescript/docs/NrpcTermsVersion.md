
# NrpcTermsVersion


## Properties

Name | Type
------------ | -------------
`id` | string
`version` | number
`title` | string
`content` | string
`contentHash` | string

## Example

```typescript
import type { NrpcTermsVersion } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "version": null,
  "title": null,
  "content": null,
  "contentHash": null,
} satisfies NrpcTermsVersion

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NrpcTermsVersion
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


