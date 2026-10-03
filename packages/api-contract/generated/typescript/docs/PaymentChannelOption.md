
# PaymentChannelOption


## Properties

Name | Type
------------ | -------------
`code` | string
`displayName` | string
`kind` | string
`available` | boolean
`unavailableReason` | string
`refundSupported` | boolean
`feeVersion` | number
`rateLabel` | string
`feeCentavos` | number
`totalCentavos` | number
`feeBearer` | string
`rateSource` | string

## Example

```typescript
import type { PaymentChannelOption } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "displayName": null,
  "kind": null,
  "available": null,
  "unavailableReason": null,
  "refundSupported": null,
  "feeVersion": null,
  "rateLabel": null,
  "feeCentavos": null,
  "totalCentavos": null,
  "feeBearer": null,
  "rateSource": null,
} satisfies PaymentChannelOption

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PaymentChannelOption
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


