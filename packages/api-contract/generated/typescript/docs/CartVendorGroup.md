
# CartVendorGroup


## Properties

Name | Type
------------ | -------------
`vendor` | [CartVendorRef](CartVendorRef.md)
`fulfillmentMethod` | string
`fulfillmentOptions` | Array&lt;string&gt;
`lines` | [Array&lt;CartLine&gt;](CartLine.md)
`materialsSubtotalCentavos` | number
`status` | string

## Example

```typescript
import type { CartVendorGroup } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendor": null,
  "fulfillmentMethod": null,
  "fulfillmentOptions": null,
  "lines": null,
  "materialsSubtotalCentavos": null,
  "status": null,
} satisfies CartVendorGroup

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CartVendorGroup
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


