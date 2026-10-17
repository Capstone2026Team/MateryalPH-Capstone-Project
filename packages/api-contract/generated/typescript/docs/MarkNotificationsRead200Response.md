
# MarkNotificationsRead200Response


## Properties

Name | Type
------------ | -------------
`data` | [NotificationBulkReadAction](NotificationBulkReadAction.md)
`meta` | { [key: string]: any; }
`errors` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { MarkNotificationsRead200Response } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "data": null,
  "meta": null,
  "errors": null,
} satisfies MarkNotificationsRead200Response

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MarkNotificationsRead200Response
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


