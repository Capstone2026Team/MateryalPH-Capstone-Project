
# VendorFinanceOverview


## Properties

Name | Type
------------ | -------------
`demoLabel` | string
`xenditConnection` | { [key: string]: any; }
`taxProfile` | { [key: string]: any; }
`withholdingArrangement` | { [key: string]: any; }
`threshold` | [WithholdingThresholdPanel](WithholdingThresholdPanel.md)
`commissionTerms` | { [key: string]: any; }
`onlineChannels` | { [key: string]: any; }
`physicalPayments` | { [key: string]: any; }
`refundCapability` | { [key: string]: any; }
`statements` | { [key: string]: any; }
`notices` | [Array&lt;VendorFinanceNotice&gt;](VendorFinanceNotice.md)

## Example

```typescript
import type { VendorFinanceOverview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "demoLabel": null,
  "xenditConnection": null,
  "taxProfile": null,
  "withholdingArrangement": null,
  "threshold": null,
  "commissionTerms": null,
  "onlineChannels": null,
  "physicalPayments": null,
  "refundCapability": null,
  "statements": null,
  "notices": null,
} satisfies VendorFinanceOverview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorFinanceOverview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


