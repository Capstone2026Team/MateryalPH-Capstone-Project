
# ConversationView


## Properties

Name | Type
------------ | -------------
`id` | string
`purpose` | string
`contextType` | string
`orderId` | string
`lockVersion` | number
`store` | [ChatStore](ChatStore.md)
`handler` | [ChatIdentity](ChatIdentity.md)
`unreadCount` | number
`channel` | string
`lockedReference` | { [key: string]: any; }
`updatedAt` | string
`canTransfer` | boolean
`fulfillmentEntryEnabled` | boolean
`readOnly` | boolean
`readOnlyReason` | string
`orderReference` | string
`buyer` | [ChatIdentity](ChatIdentity.md)
`lastMessagePreview` | string
`latestProductId` | string
`canonicalConversationId` | string
`legacyConversationIds` | Array&lt;string&gt;
`legacyHasMore` | boolean
`legacyPage` | number

## Example

```typescript
import type { ConversationView } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "purpose": null,
  "contextType": null,
  "orderId": null,
  "lockVersion": null,
  "store": null,
  "handler": null,
  "unreadCount": null,
  "channel": null,
  "lockedReference": null,
  "updatedAt": null,
  "canTransfer": null,
  "fulfillmentEntryEnabled": null,
  "readOnly": null,
  "readOnlyReason": null,
  "orderReference": null,
  "buyer": null,
  "lastMessagePreview": null,
  "latestProductId": null,
  "canonicalConversationId": null,
  "legacyConversationIds": null,
  "legacyHasMore": null,
  "legacyPage": null,
} satisfies ConversationView

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ConversationView
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


