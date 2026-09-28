
# ScoreLabel

Tier 2 shows VPS or New Vendor; Tier 1 shows Directory. A Google rating is never a ScoreLabel.

## Properties

Name | Type
------------ | -------------
`kind` | string
`value` | string
`text` | string

## Example

```typescript
import type { ScoreLabel } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "kind": null,
  "value": null,
  "text": null,
} satisfies ScoreLabel

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ScoreLabel
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


