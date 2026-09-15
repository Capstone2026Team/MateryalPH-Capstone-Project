
# AccountAgreement


## Properties

Name | Type
------------ | -------------
`id` | string
`code` | string
`title` | string
`version` | number
`content` | string
`contentAvailable` | boolean
`acceptedAt` | string
`requiresAcceptance` | boolean

## Example

```typescript
import type { AccountAgreement } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "code": null,
  "title": null,
  "version": null,
  "content": null,
  "contentAvailable": null,
  "acceptedAt": null,
  "requiresAcceptance": null,
} satisfies AccountAgreement

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AccountAgreement
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


