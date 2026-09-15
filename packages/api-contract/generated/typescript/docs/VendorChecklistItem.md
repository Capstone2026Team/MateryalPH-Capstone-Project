
# VendorChecklistItem


## Properties

Name | Type
------------ | -------------
`id` | string
`section` | string
`label` | string
`requirementLevel` | string
`status` | string
`blocking` | boolean
`reason` | string
`nextAction` | string
`versionId` | string
`updatedAt` | string
`recentAuthenticationRequired` | boolean

## Example

```typescript
import type { VendorChecklistItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "section": null,
  "label": null,
  "requirementLevel": null,
  "status": null,
  "blocking": null,
  "reason": null,
  "nextAction": null,
  "versionId": null,
  "updatedAt": null,
  "recentAuthenticationRequired": null,
} satisfies VendorChecklistItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorChecklistItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


