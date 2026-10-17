
# ProductAnalyticsSeriesPoint


## Properties

Name | Type
------------ | -------------
`date` | Date
`views` | number
`orders` | number
`valueCentavos` | number

## Example

```typescript
import type { ProductAnalyticsSeriesPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "views": null,
  "orders": null,
  "valueCentavos": null,
} satisfies ProductAnalyticsSeriesPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductAnalyticsSeriesPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


