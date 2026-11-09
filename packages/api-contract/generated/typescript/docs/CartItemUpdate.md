
# CartItemUpdate

Atomically edits an owned cart line. A listing_variant_id requires expected_price_version_id and must belong to the same listing. A duplicate option returns CART_VARIANT_ALREADY_EXISTS (409). fulfillment_method changes the entire Vendor group and retains all delivery eligibility checks. No stock is reserved.

## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`quantity` | string
`savedForLater` | boolean
`acceptCurrentPrice` | boolean
`listingVariantId` | string
`expectedPriceVersionId` | string
`fulfillmentMethod` | string

## Example

```typescript
import type { CartItemUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "quantity": null,
  "savedForLater": null,
  "acceptCurrentPrice": null,
  "listingVariantId": null,
  "expectedPriceVersionId": null,
  "fulfillmentMethod": null,
} satisfies CartItemUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartItemUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


