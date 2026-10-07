
# NotificationPreference


## Properties

Name | Type
------------ | -------------
`category` | string
`mandatory` | boolean
`explanation` | string
`inApp` | boolean
`email` | boolean
`push` | boolean

## Example

```typescript
import type { NotificationPreference } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "category": null,
  "mandatory": null,
  "explanation": null,
  "inApp": null,
  "email": null,
  "push": null,
} satisfies NotificationPreference

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NotificationPreference
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


