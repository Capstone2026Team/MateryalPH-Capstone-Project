
# CartLineSnapshot

What the Buyer saw when the line was added or last accepted.

## Properties

Name | Type
------------ | -------------
`priceVersionId` | string
`unitPriceCentavos` | number
`stockLabel` | string
`publicationVersion` | number
`addedAt` | Date

## Example

```typescript
import type { CartLineSnapshot } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "priceVersionId": null,
  "unitPriceCentavos": null,
  "stockLabel": null,
  "publicationVersion": null,
  "addedAt": null,
} satisfies CartLineSnapshot

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartLineSnapshot
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


