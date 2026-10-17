
# VendorEarningsBreakdownOnline


## Properties

Name | Type
------------ | -------------
`payments` | number
`principalPaidCentavos` | number
`refundedPrincipalCentavos` | number

## Example

```typescript
import type { VendorEarningsBreakdownOnline } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "payments": null,
  "principalPaidCentavos": null,
  "refundedPrincipalCentavos": null,
} satisfies VendorEarningsBreakdownOnline

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorEarningsBreakdownOnline
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


