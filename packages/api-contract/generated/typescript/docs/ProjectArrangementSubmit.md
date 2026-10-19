
# ProjectArrangementSubmit


## Properties

Name | Type
------------ | -------------
`version` | number
`fingerprint` | string
`acknowledged` | boolean
`payments` | [Array&lt;ProjectArrangementSubmitPaymentsInner&gt;](ProjectArrangementSubmitPaymentsInner.md)
`note` | string
`budgetOverrideReason` | string

## Example

```typescript
import type { ProjectArrangementSubmit } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "version": null,
  "fingerprint": null,
  "acknowledged": null,
  "payments": null,
  "note": null,
  "budgetOverrideReason": null,
} satisfies ProjectArrangementSubmit

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectArrangementSubmit
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


