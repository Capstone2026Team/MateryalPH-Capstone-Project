
# AutoAcceptPolicyConfigure


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`enabled` | boolean
`allotmentQuantity` | string
`maxUnitCount` | string
`maxOrderAmountCentavos` | number

## Example

```typescript
import type { AutoAcceptPolicyConfigure } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "enabled": null,
  "allotmentQuantity": null,
  "maxUnitCount": null,
  "maxOrderAmountCentavos": null,
} satisfies AutoAcceptPolicyConfigure

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutoAcceptPolicyConfigure
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


