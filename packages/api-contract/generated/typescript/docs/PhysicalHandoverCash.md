
# PhysicalHandoverCash

Vendor views only. Cash the Buyer handed over at Delivered or Picked up, reported by a member who may not record cash (Fulfillment Staff), still waiting for an Owner, Store Manager or Store Staff confirmation. Null when nothing waits or for the Buyer.

## Properties

Name | Type
------------ | -------------
`reportedCentavos` | number
`confirmableCentavos` | number
`milestone` | string
`reportedAt` | Date
`hasPhoto` | boolean

## Example

```typescript
import type { PhysicalHandoverCash } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "reportedCentavos": null,
  "confirmableCentavos": null,
  "milestone": null,
  "reportedAt": null,
  "hasPhoto": null,
} satisfies PhysicalHandoverCash

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PhysicalHandoverCash
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


