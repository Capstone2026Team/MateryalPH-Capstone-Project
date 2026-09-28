
# BuyerLocationUpdate


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`resolutionToken` | string
`label` | string
`locationKind` | [BuyerLocationKind](BuyerLocationKind.md)
`contactName` | string
`contactPhoneE164` | string
`siteInstructions` | string
`addressLine` | string

## Example

```typescript
import type { BuyerLocationUpdate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "resolutionToken": null,
  "label": null,
  "locationKind": null,
  "contactName": null,
  "contactPhoneE164": null,
  "siteInstructions": null,
  "addressLine": null,
} satisfies BuyerLocationUpdate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerLocationUpdate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


