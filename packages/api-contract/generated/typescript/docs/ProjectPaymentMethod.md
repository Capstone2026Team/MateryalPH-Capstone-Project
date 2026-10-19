
# ProjectPaymentMethod


## Properties

Name | Type
------------ | -------------
`method` | string
`available` | boolean
`reason` | string

## Example

```typescript
import type { ProjectPaymentMethod } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "method": null,
  "available": null,
  "reason": null,
} satisfies ProjectPaymentMethod

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectPaymentMethod
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


