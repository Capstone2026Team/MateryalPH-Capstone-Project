
# PublicScores


## Properties

Name | Type
------------ | -------------
`label` | string
`newVendor` | boolean
`vps` | string
`vcs` | string
`mqs` | string
`ohs` | string
`asOf` | Date
`badges` | [Array&lt;PublicBadge&gt;](PublicBadge.md)

## Example

```typescript
import type { PublicScores } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "label": null,
  "newVendor": null,
  "vps": null,
  "vcs": null,
  "mqs": null,
  "ohs": null,
  "asOf": null,
  "badges": null,
} satisfies PublicScores

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PublicScores
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


