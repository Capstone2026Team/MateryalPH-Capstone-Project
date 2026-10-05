
# ScoreHistoryPoint


## Properties

Name | Type
------------ | -------------
`date` | Date
`vps` | string
`vcs` | string
`mqs` | string
`ohs` | string

## Example

```typescript
import type { ScoreHistoryPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "vps": null,
  "vcs": null,
  "mqs": null,
  "ohs": null,
} satisfies ScoreHistoryPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ScoreHistoryPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


