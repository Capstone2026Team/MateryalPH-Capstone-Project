
# FeeStatement


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

## Example

```typescript
import type { FeeStatement } from '@materyalph/api-client-ts'

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
} satisfies FeeStatement

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FeeStatement
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


