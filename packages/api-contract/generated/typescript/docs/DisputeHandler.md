
# DisputeHandler


## Properties

Name | Type
------------ | -------------
`vendor` | [DisputeHandlerRef](DisputeHandlerRef.md)
`adminAssigned` | boolean
`adminIsMe` | boolean

## Example

```typescript
import type { DisputeHandler } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendor": null,
  "adminAssigned": null,
  "adminIsMe": null,
} satisfies DisputeHandler

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DisputeHandler
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


