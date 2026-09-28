
# InventoryLedgerMetaPermissions


## Properties

Name | Type
------------ | -------------
`canAdjust` | boolean
`canChangePrice` | boolean
`canConfigureAutoAccept` | boolean
`canUpdateAllotment` | boolean
`canViewAutoAccept` | boolean
`canEditSettings` | boolean

## Example

```typescript
import type { InventoryLedgerMetaPermissions } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "canAdjust": null,
  "canChangePrice": null,
  "canConfigureAutoAccept": null,
  "canUpdateAllotment": null,
  "canViewAutoAccept": null,
  "canEditSettings": null,
} satisfies InventoryLedgerMetaPermissions

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryLedgerMetaPermissions
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


