
# BuyerAnalyticsFeaturedVariant

The most-offered variant, whose average and trend represent the product without blending variants.

## Properties

Name | Type
------------ | -------------
`group` | [BuyerMaterialsAnalyticsDetailGroup](BuyerMaterialsAnalyticsDetailGroup.md)
`series` | [Array&lt;BuyerAnalyticsPoint&gt;](BuyerAnalyticsPoint.md)

## Example

```typescript
import type { BuyerAnalyticsFeaturedVariant } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "group": null,
  "series": null,
} satisfies BuyerAnalyticsFeaturedVariant

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerAnalyticsFeaturedVariant
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


