
# AnalyticsPriceRange

Current per-Vendor prices per canonical unit (each Vendor once per variant at its lowest normalized price), half-up at 2 dp; all null when there is no current offer.

## Properties

Name | Type
------------ | -------------
`minPhp` | string
`medianPhp` | string
`maxPhp` | string

## Example

```typescript
import type { AnalyticsPriceRange } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "minPhp": null,
  "medianPhp": null,
  "maxPhp": null,
} satisfies AnalyticsPriceRange

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AnalyticsPriceRange
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


