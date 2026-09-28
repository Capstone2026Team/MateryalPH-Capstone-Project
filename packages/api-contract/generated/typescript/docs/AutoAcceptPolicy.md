
# AutoAcceptPolicy


## Properties

Name | Type
------------ | -------------
`status` | [AutoAcceptStatus](AutoAcceptStatus.md)
`enabled` | boolean
`paused` | boolean
`pauseReason` | string
`pausedAt` | string
`allotmentQuantity` | string
`remainingAllotmentQuantity` | string
`maxUnitCount` | string
`maxOrderAmountCentavos` | number
`currentVersion` | number
`lockVersion` | number
`updatedAt` | string
`lastEditor` | string

## Example

```typescript
import type { AutoAcceptPolicy } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "enabled": null,
  "paused": null,
  "pauseReason": null,
  "pausedAt": null,
  "allotmentQuantity": null,
  "remainingAllotmentQuantity": null,
  "maxUnitCount": null,
  "maxOrderAmountCentavos": null,
  "currentVersion": null,
  "lockVersion": null,
  "updatedAt": null,
  "lastEditor": null,
} satisfies AutoAcceptPolicy

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutoAcceptPolicy
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


