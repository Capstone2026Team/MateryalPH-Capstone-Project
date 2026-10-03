
# FinancialPreviewLine


## Properties

Name | Type
------------ | -------------
`lineId` | string
`payableCentavos` | number
`includedVatCentavos` | number
`taxCategory` | string

## Example

```typescript
import type { FinancialPreviewLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lineId": null,
  "payableCentavos": null,
  "includedVatCentavos": null,
  "taxCategory": null,
} satisfies FinancialPreviewLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FinancialPreviewLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


