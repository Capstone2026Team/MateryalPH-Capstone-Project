
# InventorySettings


## Properties

Name | Type
------------ | -------------
`reminderLocalTime` | string
`emailReminders` | boolean
`inAppReminders` | boolean
`timezone` | string
`reminderDays` | Array&lt;number&gt;
`hideAfterDays` | number
`autoAcceptReadyLeadDays` | number
`lockVersion` | number
`canEdit` | boolean

## Example

```typescript
import type { InventorySettings } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "reminderLocalTime": null,
  "emailReminders": null,
  "inAppReminders": null,
  "timezone": null,
  "reminderDays": null,
  "hideAfterDays": null,
  "autoAcceptReadyLeadDays": null,
  "lockVersion": null,
  "canEdit": null,
} satisfies InventorySettings

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventorySettings
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


