
# PlatformSetting

An approved non-secret default. Version 0 means the approved default has never been stored; consuming rules apply it to new records only.

## Properties

Name | Type
------------ | -------------
`key` | string
`group` | string
`label` | string
`description` | string
`validationRule` | string
`appliesTo` | string
`value` | any
`defaultValue` | any
`version` | number
`previousValue` | any
`lastReason` | string
`updatedAt` | Date
`updatedBy` | string
`editable` | boolean

## Example

```typescript
import type { PlatformSetting } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "group": null,
  "label": null,
  "description": null,
  "validationRule": null,
  "appliesTo": null,
  "value": null,
  "defaultValue": null,
  "version": null,
  "previousValue": null,
  "lastReason": null,
  "updatedAt": null,
  "updatedBy": null,
  "editable": null,
} satisfies PlatformSetting

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PlatformSetting
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


