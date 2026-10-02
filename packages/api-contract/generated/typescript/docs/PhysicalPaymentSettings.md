
# PhysicalPaymentSettings


## Properties

Name | Type
------------ | -------------
`codEnabled` | boolean
`inStoreEnabled` | boolean
`lockVersion` | number
`updatedAt` | string

## Example

```typescript
import type { PhysicalPaymentSettings } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "codEnabled": null,
  "inStoreEnabled": null,
  "lockVersion": null,
  "updatedAt": null,
} satisfies PhysicalPaymentSettings

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PhysicalPaymentSettings
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


