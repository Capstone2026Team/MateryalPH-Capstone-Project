
# VendorDashboardOrdersUnusualDays

DBSCAN noise points among the store’s active days.

## Properties

Name | Type
------------ | -------------
`state` | string
`epsilon` | number
`days` | [Array&lt;VendorDashboardOrdersUnusualDaysDaysInner&gt;](VendorDashboardOrdersUnusualDaysDaysInner.md)

## Example

```typescript
import type { VendorDashboardOrdersUnusualDays } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "state": null,
  "epsilon": null,
  "days": null,
} satisfies VendorDashboardOrdersUnusualDays

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorDashboardOrdersUnusualDays
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


