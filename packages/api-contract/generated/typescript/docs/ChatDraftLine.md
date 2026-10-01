
# ChatDraftLine


## Properties

Name | Type
------------ | -------------
`variantId` | string
`quantity` | string
`unitPriceCentavos` | number

## Example

```typescript
import type { ChatDraftLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "variantId": null,
  "quantity": null,
  "unitPriceCentavos": null,
} satisfies ChatDraftLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatDraftLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


