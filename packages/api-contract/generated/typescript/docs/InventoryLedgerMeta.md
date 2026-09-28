
# InventoryLedgerMeta


## Properties

Name | Type
------------ | -------------
`currentPage` | number
`lastPage` | number
`total` | number
`pageSize` | number
`summary` | [InventoryLedgerMetaSummary](InventoryLedgerMetaSummary.md)
`staleListings` | [InventoryLedgerMetaStaleListings](InventoryLedgerMetaStaleListings.md)
`labelRuleVersion` | string
`timezone` | string
`permissions` | [InventoryLedgerMetaPermissions](InventoryLedgerMetaPermissions.md)

## Example

```typescript
import type { InventoryLedgerMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "currentPage": null,
  "lastPage": null,
  "total": null,
  "pageSize": null,
  "summary": null,
  "staleListings": null,
  "labelRuleVersion": null,
  "timezone": null,
  "permissions": null,
} satisfies InventoryLedgerMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as InventoryLedgerMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


