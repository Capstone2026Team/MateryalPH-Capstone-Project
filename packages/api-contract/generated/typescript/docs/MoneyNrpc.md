
# MoneyNrpc


## Properties

Name | Type
------------ | -------------
`amountCentavos` | number
`withinOrderValue` | boolean
`status` | string

## Example

```typescript
import type { MoneyNrpc } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "amountCentavos": null,
  "withinOrderValue": null,
  "status": null,
} satisfies MoneyNrpc

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MoneyNrpc
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


