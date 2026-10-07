
# NotificationPreferenceInput


## Properties

Name | Type
------------ | -------------
`category` | string
`inApp` | boolean
`email` | boolean
`push` | boolean

## Example

```typescript
import type { NotificationPreferenceInput } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "category": null,
  "inApp": null,
  "email": null,
  "push": null,
} satisfies NotificationPreferenceInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NotificationPreferenceInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


