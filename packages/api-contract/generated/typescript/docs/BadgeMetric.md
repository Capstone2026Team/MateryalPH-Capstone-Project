
# BadgeMetric


## Properties

Name | Type
------------ | -------------
`key` | string
`value` | string
`sampleCount` | number
`window` | string
`definition` | string

## Example

```typescript
import type { BadgeMetric } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "value": null,
  "sampleCount": null,
  "window": null,
  "definition": null,
} satisfies BadgeMetric

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BadgeMetric
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


