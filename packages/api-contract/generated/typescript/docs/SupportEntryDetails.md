
# SupportEntryDetails


## Properties

Name | Type
------------ | -------------
`fromStatus` | string
`toStatus` | string
`previousHandler` | string
`newHandler` | string

## Example

```typescript
import type { SupportEntryDetails } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fromStatus": null,
  "toStatus": null,
  "previousHandler": null,
  "newHandler": null,
} satisfies SupportEntryDetails

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupportEntryDetails
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


