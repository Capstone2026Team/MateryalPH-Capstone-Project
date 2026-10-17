
# GeoCell

A person-derived value; null with a reason when suppressed under the small-cell rule.

## Properties

Name | Type
------------ | -------------
`value` | number
`suppressed` | boolean
`reason` | string

## Example

```typescript
import type { GeoCell } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "value": null,
  "suppressed": null,
  "reason": null,
} satisfies GeoCell

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoCell
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


