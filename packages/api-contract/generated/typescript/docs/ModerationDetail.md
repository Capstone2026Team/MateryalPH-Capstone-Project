
# ModerationDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`type` | string
`ratings` | [ReviewRatings](ReviewRatings.md)
`comment` | string
`displayName` | string
`moderationState` | string
`reviewerParty` | string
`displayNameChoice` | string
`authorDisplayRule` | string
`verifiedPurchase` | { [key: string]: any; }
`relatedDispute` | { [key: string]: any; }
`revisions` | Array&lt;{ [key: string]: any; }&gt;
`flags` | Array&lt;{ [key: string]: any; }&gt;
`history` | Array&lt;{ [key: string]: any; }&gt;
`availableActions` | Array&lt;string&gt;
`media` | [Array&lt;ReviewMediaLink&gt;](ReviewMediaLink.md)
`lockVersion` | number
`visibility` | string

## Example

```typescript
import type { ModerationDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "type": null,
  "ratings": null,
  "comment": null,
  "displayName": null,
  "moderationState": null,
  "reviewerParty": null,
  "displayNameChoice": null,
  "authorDisplayRule": null,
  "verifiedPurchase": null,
  "relatedDispute": null,
  "revisions": null,
  "flags": null,
  "history": null,
  "availableActions": null,
  "media": null,
  "lockVersion": null,
  "visibility": null,
} satisfies ModerationDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ModerationDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


