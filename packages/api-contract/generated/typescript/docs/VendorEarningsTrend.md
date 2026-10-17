
# VendorEarningsTrend

The Earnings figures bucketed by Asia/Manila day (by calendar month when the period exceeds 92 days) over the filtered period, which ends today at the latest and starts at the store\'s first order when no start date is given; each figure uses the same date column as its total. Records only: no forecast, ratio or derived income figure. TEST/DEMO.

## Properties

Name | Type
------------ | -------------
`granularity` | string
`timezone` | string
`from` | Date
`to` | Date
`days` | number
`points` | [Array&lt;VendorEarningsTrendPoint&gt;](VendorEarningsTrendPoint.md)
`previous` | [VendorEarningsTrendComparison](VendorEarningsTrendComparison.md)

## Example

```typescript
import type { VendorEarningsTrend } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "granularity": null,
  "timezone": null,
  "from": null,
  "to": null,
  "days": null,
  "points": null,
  "previous": null,
} satisfies VendorEarningsTrend

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsTrend
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


