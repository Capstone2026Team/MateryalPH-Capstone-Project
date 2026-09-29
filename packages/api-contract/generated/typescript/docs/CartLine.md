
# CartLine


## Properties

Name | Type
------------ | -------------
`id` | string
`lockVersion` | number
`listingId` | string
`variantId` | string
`vendorId` | string
`displayName` | string
`variantLabel` | string
`image` | [ListingImage](ListingImage.md)
`unitCode` | string
`unitName` | string
`quantity` | string
`quantityStep` | string
`savedForLater` | boolean
`snapshot` | [CartLineSnapshot](CartLineSnapshot.md)
`current` | [CartLineCurrent](CartLineCurrent.md)
`lineTotalCentavos` | number
`issues` | [Array&lt;CartIssue&gt;](CartIssue.md)
`status` | string

## Example

```typescript
import type { CartLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "lockVersion": null,
  "listingId": null,
  "variantId": null,
  "vendorId": null,
  "displayName": null,
  "variantLabel": null,
  "image": null,
  "unitCode": null,
  "unitName": null,
  "quantity": null,
  "quantityStep": null,
  "savedForLater": null,
  "snapshot": null,
  "current": null,
  "lineTotalCentavos": null,
  "issues": null,
  "status": null,
} satisfies CartLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


