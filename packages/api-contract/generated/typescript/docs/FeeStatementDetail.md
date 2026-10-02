
# FeeStatementDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`state` | string
`overdue` | boolean
`periodStart` | string
`periodEnd` | string
`issuedOn` | string
`dueOn` | string
`chargesCentavos` | number
`creditsCentavos` | number
`paidCentavos` | number
`outstandingCentavos` | number
`disputedHeldCentavos` | number
`lockVersion` | number
`sampleNotice` | string
`lines` | Array&lt;{ [key: string]: any; }&gt;
`payments` | [Array&lt;PaymentAttempt&gt;](PaymentAttempt.md)
`channels` | [Array&lt;PaymentChannelOption&gt;](PaymentChannelOption.md)

## Example

```typescript
import type { FeeStatementDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "state": null,
  "overdue": null,
  "periodStart": null,
  "periodEnd": null,
  "issuedOn": null,
  "dueOn": null,
  "chargesCentavos": null,
  "creditsCentavos": null,
  "paidCentavos": null,
  "outstandingCentavos": null,
  "disputedHeldCentavos": null,
  "lockVersion": null,
  "sampleNotice": null,
  "lines": null,
  "payments": null,
  "channels": null,
} satisfies FeeStatementDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FeeStatementDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


