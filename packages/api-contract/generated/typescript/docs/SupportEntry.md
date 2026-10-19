
# SupportEntry


## Properties

Name | Type
------------ | -------------
`id` | string
`kind` | string
`actorName` | string
`actorRole` | string
`body` | string
`details` | [SupportEntryDetails](SupportEntryDetails.md)
`createdAt` | Date
`attachments` | [Array&lt;SupportAttachment&gt;](SupportAttachment.md)

## Example

```typescript
import type { SupportEntry } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "kind": null,
  "actorName": null,
  "actorRole": null,
  "body": null,
  "details": null,
  "createdAt": null,
  "attachments": null,
} satisfies SupportEntry

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupportEntry
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


