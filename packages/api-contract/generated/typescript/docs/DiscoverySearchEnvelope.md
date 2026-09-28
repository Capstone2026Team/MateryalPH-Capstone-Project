
# DiscoverySearchEnvelope


## Properties

Name | Type
------------ | -------------
`data` | [Array&lt;SupplierResult&gt;](SupplierResult.md)
`meta` | [DiscoverySearchMeta](DiscoverySearchMeta.md)
`errors` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { DiscoverySearchEnvelope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies DiscoverySearchEnvelope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DiscoverySearchEnvelope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


