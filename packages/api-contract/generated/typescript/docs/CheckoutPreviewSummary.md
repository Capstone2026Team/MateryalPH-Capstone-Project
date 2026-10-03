
# CheckoutPreviewSummary


## Properties

Name | Type
------------ | -------------
`groupCount` | number
`readyGroups` | number
`actionRequiredGroups` | number
`blockedGroups` | number
`requiresSplitConfirmation` | boolean
`createsOrders` | boolean
`reservesStock` | boolean
`notice` | string

## Example

```typescript
import type { CheckoutPreviewSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "groupCount": null,
  "readyGroups": null,
  "actionRequiredGroups": null,
  "blockedGroups": null,
  "requiresSplitConfirmation": null,
  "createsOrders": null,
  "reservesStock": null,
  "notice": null,
} satisfies CheckoutPreviewSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CheckoutPreviewSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


