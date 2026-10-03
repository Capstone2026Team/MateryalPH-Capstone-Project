
# PhysicalPaymentSummary


## Properties

Name | Type
------------ | -------------
`applicable` | boolean
`method` | string
`state` | string
`remainingCentavos` | number
`onlineBalanceApproved` | boolean
`records` | [Array&lt;PhysicalPaymentRecord&gt;](PhysicalPaymentRecord.md)
`notice` | string

## Example

```typescript
import type { PhysicalPaymentSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "applicable": null,
  "method": null,
  "state": null,
  "remainingCentavos": null,
  "onlineBalanceApproved": null,
  "records": null,
  "notice": null,
} satisfies PhysicalPaymentSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PhysicalPaymentSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


