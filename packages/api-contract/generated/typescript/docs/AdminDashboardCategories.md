
# AdminDashboardCategories

Category demand and Apriori rules; a category or rule needs at least minimum_buyers distinct Buyers.

## Properties

Name | Type
------------ | -------------
`demand` | [Array&lt;AdminDashboardCategoriesDemandInner&gt;](AdminDashboardCategoriesDemandInner.md)
`suppressedCategories` | number
`rules` | [Array&lt;DashboardRule&gt;](DashboardRule.md)
`baskets` | number
`minimumBuyers` | number

## Example

```typescript
import type { AdminDashboardCategories } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "demand": null,
  "suppressedCategories": null,
  "rules": null,
  "baskets": null,
  "minimumBuyers": null,
} satisfies AdminDashboardCategories

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardCategories
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


