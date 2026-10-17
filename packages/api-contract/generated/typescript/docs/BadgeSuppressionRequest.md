
# BadgeSuppressionRequest

Display suppression for a documented fraud or compliance case. There is no award command.

## Properties

Name | Type
------------ | -------------
`badgeCode` | string
`reasonCode` | string
`caseReference` | string
`note` | string

## Example

```typescript
import type { BadgeSuppressionRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "badgeCode": null,
  "reasonCode": null,
  "caseReference": null,
  "note": null,
} satisfies BadgeSuppressionRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BadgeSuppressionRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


