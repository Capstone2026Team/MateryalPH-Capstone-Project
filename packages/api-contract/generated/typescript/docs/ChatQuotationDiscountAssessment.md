
# ChatQuotationDiscountAssessment


## Properties

Name | Type
------------ | -------------
`scope` | string
`percent` | string
`basisCentavos` | number
`deductionCentavos` | number

## Example

```typescript
import type { ChatQuotationDiscountAssessment } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "scope": null,
  "percent": null,
  "basisCentavos": null,
  "deductionCentavos": null,
} satisfies ChatQuotationDiscountAssessment

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatQuotationDiscountAssessment
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


