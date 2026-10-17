
# VendorTeamSalesPerformance


## Properties

Name | Type
------------ | -------------
`orders` | number
`completed` | number
`cancelled` | number
`valueCentavos` | number
`conversations` | number
`messages` | number
`awaitingReply` | number
`reply` | [VendorTeamReplyTime](VendorTeamReplyTime.md)

## Example

```typescript
import type { VendorTeamSalesPerformance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orders": null,
  "completed": null,
  "cancelled": null,
  "valueCentavos": null,
  "conversations": null,
  "messages": null,
  "awaitingReply": null,
  "reply": null,
} satisfies VendorTeamSalesPerformance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamSalesPerformance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


