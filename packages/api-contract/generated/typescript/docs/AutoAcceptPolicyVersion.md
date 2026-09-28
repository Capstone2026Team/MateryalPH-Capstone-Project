
# AutoAcceptPolicyVersion


## Properties

Name | Type
------------ | -------------
`version` | number
`changeKind` | string
`enabled` | boolean
`paused` | boolean
`pauseReason` | string
`allotmentQuantity` | string
`remainingAllotmentQuantity` | string
`maxUnitCount` | string
`maxOrderAmountCentavos` | number
`createdAt` | string
`automated` | boolean
`actor` | string

## Example

```typescript
import type { AutoAcceptPolicyVersion } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "version": null,
  "changeKind": null,
  "enabled": null,
  "paused": null,
  "pauseReason": null,
  "allotmentQuantity": null,
  "remainingAllotmentQuantity": null,
  "maxUnitCount": null,
  "maxOrderAmountCentavos": null,
  "createdAt": null,
  "automated": null,
  "actor": null,
} satisfies AutoAcceptPolicyVersion

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutoAcceptPolicyVersion
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


