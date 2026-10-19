
# DirectoryBuyerProfileRecentOrdersInner


## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`orderState` | string
`paymentState` | string
`procurementType` | string
`storeName` | string
`createdAt` | Date

## Example

```typescript
import type { DirectoryBuyerProfileRecentOrdersInner } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "orderState": null,
  "paymentState": null,
  "procurementType": null,
  "storeName": null,
  "createdAt": null,
} satisfies DirectoryBuyerProfileRecentOrdersInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DirectoryBuyerProfileRecentOrdersInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


