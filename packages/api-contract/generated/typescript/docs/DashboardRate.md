
# DashboardRate

A rate with its numerator and denominator; percent is null when the denominator is zero.

## Properties

Name | Type
------------ | -------------
`percent` | string
`numerator` | number
`denominator` | number

## Example

```typescript
import type { DashboardRate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "percent": null,
  "numerator": null,
  "denominator": null,
} satisfies DashboardRate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DashboardRate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


