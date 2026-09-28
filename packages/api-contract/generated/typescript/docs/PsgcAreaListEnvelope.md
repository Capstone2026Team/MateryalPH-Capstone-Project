
# PsgcAreaListEnvelope


## Properties

Name | Type
------------ | -------------
`data` | [Array&lt;PsgcAreaOption&gt;](PsgcAreaOption.md)
`meta` | [PsgcAreaListMeta](PsgcAreaListMeta.md)
`errors` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { PsgcAreaListEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies PsgcAreaListEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PsgcAreaListEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


