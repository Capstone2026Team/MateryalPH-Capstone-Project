
# ProjectDraftVendorGroup


## Properties

Name | Type
------------ | -------------
`vendorId` | string
`storeName` | string
`items` | [Array&lt;ProjectSeparatePurchase&gt;](ProjectSeparatePurchase.md)
`materialsCentavos` | number
`fulfillmentMethod` | string
`fulfillmentOptions` | Array&lt;string&gt;
`delivery` | { [key: string]: any; }
`paymentMethods` | [Array&lt;ProjectPaymentMethod&gt;](ProjectPaymentMethod.md)
`issues` | Array&lt;string&gt;
`draftFingerprint` | string
`deliveryCentavos` | number
`projectedTotalCentavos` | number

## Example

```typescript
import type { ProjectDraftVendorGroup } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "storeName": null,
  "items": null,
  "materialsCentavos": null,
  "fulfillmentMethod": null,
  "fulfillmentOptions": null,
  "delivery": null,
  "paymentMethods": null,
  "issues": null,
  "draftFingerprint": null,
  "deliveryCentavos": null,
  "projectedTotalCentavos": null,
} satisfies ProjectDraftVendorGroup

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectDraftVendorGroup
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


