
# ChannelFeeVersion


## Properties

Name | Type
------------ | -------------
`code` | string
`displayName` | string
`kind` | string
`version` | number
`ratePpm` | number
`fixedCentavos` | number
`feeVatBasisPoints` | number
`rateIncludesVat` | boolean
`refundSupported` | boolean
`enabled` | boolean
`disabledReason` | string
`sourceType` | string
`sourceReference` | string
`effectiveFrom` | Date

## Example

```typescript
import type { ChannelFeeVersion } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "displayName": null,
  "kind": null,
  "version": null,
  "ratePpm": null,
  "fixedCentavos": null,
  "feeVatBasisPoints": null,
  "rateIncludesVat": null,
  "refundSupported": null,
  "enabled": null,
  "disabledReason": null,
  "sourceType": null,
  "sourceReference": null,
  "effectiveFrom": null,
} satisfies ChannelFeeVersion

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChannelFeeVersion
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


