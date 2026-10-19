
# ProjectArrangementEdit


## Properties

Name | Type
------------ | -------------
`version` | number
`vendorId` | string
`lineId` | string
`itemId` | string
`variantId` | string
`priceVersionId` | string
`optionId` | string
`fulfillmentMethod` | string
`method` | string
`remove` | boolean
`replaceItem` | boolean

## Example

```typescript
import type { ProjectArrangementEdit } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "version": null,
  "vendorId": null,
  "lineId": null,
  "itemId": null,
  "variantId": null,
  "priceVersionId": null,
  "optionId": null,
  "fulfillmentMethod": null,
  "method": null,
  "remove": null,
  "replaceItem": null,
} satisfies ProjectArrangementEdit

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectArrangementEdit
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


