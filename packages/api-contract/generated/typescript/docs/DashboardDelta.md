
# DashboardDelta

The period value and the equal-length period before it.

## Properties

Name | Type
------------ | -------------
`value` | number
`previous` | number
`changePercent` | number

## Example

```typescript
import type { DashboardDelta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "value": null,
  "previous": null,
  "changePercent": null,
} satisfies DashboardDelta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DashboardDelta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


