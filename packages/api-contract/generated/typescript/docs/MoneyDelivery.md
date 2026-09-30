
# MoneyDelivery


## Properties

Name | Type
------------ | -------------
`status` | string
`amountCentavos` | number
`estimate` | [MoneyRange](MoneyRange.md)

## Example

```typescript
import type { MoneyDelivery } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "amountCentavos": null,
  "estimate": null,
} satisfies MoneyDelivery

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MoneyDelivery
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


