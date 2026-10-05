
# ModerationQueueRow


## Properties

Name | Type
------------ | -------------
`id` | string
`type` | string
`moderationState` | string
`orderReference` | string
`storeName` | string
`displayName` | string
`ratings` | [ReviewRatings](ReviewRatings.md)
`comment` | string
`openFlags` | number
`submittedAt` | Date
`updatedAt` | Date

## Example

```typescript
import type { ModerationQueueRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "type": null,
  "moderationState": null,
  "orderReference": null,
  "storeName": null,
  "displayName": null,
  "ratings": null,
  "comment": null,
  "openFlags": null,
  "submittedAt": null,
  "updatedAt": null,
} satisfies ModerationQueueRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ModerationQueueRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


