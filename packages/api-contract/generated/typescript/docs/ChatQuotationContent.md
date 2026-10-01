
# ChatQuotationContent


## Properties

Name | Type
------------ | -------------
`lines` | [Array&lt;ChatQuotationLine&gt;](ChatQuotationLine.md)
`commercial` | [ChatQuotationMoney](ChatQuotationMoney.md)
`fulfillmentMethod` | string
`paymentMethod` | string
`fulfillmentDate` | string
`delivery` | { [key: string]: any; }
`nrpc` | { [key: string]: any; }
`changes` | [Array&lt;ChatQuotationChange&gt;](ChatQuotationChange.md)
`originalChanges` | [Array&lt;ChatQuotationChange&gt;](ChatQuotationChange.md)
`priceSource` | string
`processingFeeStatus` | string

## Example

```typescript
import type { ChatQuotationContent } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lines": null,
  "commercial": null,
  "fulfillmentMethod": null,
  "paymentMethod": null,
  "fulfillmentDate": null,
  "delivery": null,
  "nrpc": null,
  "changes": null,
  "originalChanges": null,
  "priceSource": null,
  "processingFeeStatus": null,
} satisfies ChatQuotationContent

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ChatQuotationContent
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


