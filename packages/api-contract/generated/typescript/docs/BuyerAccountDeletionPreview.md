
# BuyerAccountDeletionPreview


## Properties

Name | Type
------------ | -------------
`canDelete` | boolean
`blockers` | [BuyerAccountDeletionBlockers](BuyerAccountDeletionBlockers.md)
`retainedRecords` | [Array&lt;BuyerAccountRetainedRecord&gt;](BuyerAccountRetainedRecord.md)
`confirmationPhrase` | string

## Example

```typescript
import type { BuyerAccountDeletionPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "canDelete": null,
  "blockers": null,
  "retainedRecords": null,
  "confirmationPhrase": null,
} satisfies BuyerAccountDeletionPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BuyerAccountDeletionPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


