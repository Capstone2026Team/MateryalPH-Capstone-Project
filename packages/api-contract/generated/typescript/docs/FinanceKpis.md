
# FinanceKpis


## Properties

Name | Type
------------ | -------------
`label` | string
`scenario` | string
`period` | [FinanceKpisPeriod](FinanceKpisPeriod.md)
`commerce` | [Array&lt;FinanceKpi&gt;](FinanceKpi.md)
`finance` | [Array&lt;FinanceKpi&gt;](FinanceKpi.md)
`counts` | { [key: string]: number; }
`trend` | [Array&lt;CommissionTrendPoint&gt;](CommissionTrendPoint.md)
`trendGranularity` | string

## Example

```typescript
import type { FinanceKpis } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "label": null,
  "scenario": null,
  "period": null,
  "commerce": null,
  "finance": null,
  "counts": null,
  "trend": null,
  "trendGranularity": null,
} satisfies FinanceKpis

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FinanceKpis
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


