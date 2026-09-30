
# NrpcAffectedLine


## Properties

Name | Type
------------ | -------------
`orderLineId` | string
`label` | string
`principalCentavos` | number
`linePayableCentavos` | number
`includedVatCentavos` | number

## Example

```typescript
import type { NrpcAffectedLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "orderLineId": null,
  "label": null,
  "principalCentavos": null,
  "linePayableCentavos": null,
  "includedVatCentavos": null,
} satisfies NrpcAffectedLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NrpcAffectedLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


