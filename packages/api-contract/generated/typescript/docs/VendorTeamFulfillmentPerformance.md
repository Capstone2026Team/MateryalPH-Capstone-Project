
# VendorTeamFulfillmentPerformance


## Properties

Name | Type
------------ | -------------
`assigned` | number
`active` | number
`handovers` | number
`onTime` | number
`onTimeMeasured` | number
`milestones` | number
`proofs` | number
`vehicleIssues` | number
`conversations` | number
`messages` | number
`awaitingReply` | number
`reply` | [VendorTeamReplyTime](VendorTeamReplyTime.md)

## Example

```typescript
import type { VendorTeamFulfillmentPerformance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "assigned": null,
  "active": null,
  "handovers": null,
  "onTime": null,
  "onTimeMeasured": null,
  "milestones": null,
  "proofs": null,
  "vehicleIssues": null,
  "conversations": null,
  "messages": null,
  "awaitingReply": null,
  "reply": null,
} satisfies VendorTeamFulfillmentPerformance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamFulfillmentPerformance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


