
# GeoRate

Numerator and denominator are always shown with the percentage, or all null when suppressed.

## Properties

Name | Type
------------ | -------------
`percent` | string
`numerator` | number
`denominator` | number
`suppressed` | boolean
`reason` | string

## Example

```typescript
import type { GeoRate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "percent": null,
  "numerator": null,
  "denominator": null,
  "suppressed": null,
  "reason": null,
} satisfies GeoRate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoRate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


