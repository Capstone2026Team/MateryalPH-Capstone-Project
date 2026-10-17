
# FulfillmentConversationSummary


## Properties

Name | Type
------------ | -------------
`conversationId` | string
`orderId` | string
`orderReference` | string
`orderState` | string
`fulfillmentMethod` | string
`unreadCount` | number
`updatedAt` | Date
`readOnly` | boolean
`readOnlyReason` | string

## Example

```typescript
import type { FulfillmentConversationSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "conversationId": null,
  "orderId": null,
  "orderReference": null,
  "orderState": null,
  "fulfillmentMethod": null,
  "unreadCount": null,
  "updatedAt": null,
  "readOnly": null,
  "readOnlyReason": null,
} satisfies FulfillmentConversationSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FulfillmentConversationSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


