
# PsgcSearchEnvelopeData


## Properties

Name | Type
------------ | -------------
`items` | [Array&lt;PsgcArea&gt;](PsgcArea.md)
`page` | number
`hasMore` | boolean
`versionId` | string

## Example

```typescript
import type { PsgcSearchEnvelopeData } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "items": null,
  "page": null,
  "hasMore": null,
  "versionId": null,
} satisfies PsgcSearchEnvelopeData

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PsgcSearchEnvelopeData
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


