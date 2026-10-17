
# BuyAgainResult


## Properties

Name | Type
------------ | -------------
`cart` | [Cart](Cart.md)
`added` | [Array&lt;BuyAgainAddedLine&gt;](BuyAgainAddedLine.md)
`skipped` | [Array&lt;BuyAgainSkippedLine&gt;](BuyAgainSkippedLine.md)

## Example

```typescript
import type { BuyAgainResult } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "cart": null,
  "added": null,
  "skipped": null,
} satisfies BuyAgainResult

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyAgainResult
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


