
# DashboardAnomaly

A day more than three residual standard deviations from its fitted value.

## Properties

Name | Type
------------ | -------------
`date` | Date
`value` | number
`expected` | number
`deviation` | number

## Example

```typescript
import type { DashboardAnomaly } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "value": null,
  "expected": null,
  "deviation": null,
} satisfies DashboardAnomaly

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DashboardAnomaly
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


