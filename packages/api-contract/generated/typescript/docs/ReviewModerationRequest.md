
# ReviewModerationRequest

There is no delete action. Request Correction hides the review and gives its author one correction within 7 days.

## Properties

Name | Type
------------ | -------------
`action` | string
`reason` | string
`lockVersion` | number

## Example

```typescript
import type { ReviewModerationRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "action": null,
  "reason": null,
  "lockVersion": null,
} satisfies ReviewModerationRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ReviewModerationRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


