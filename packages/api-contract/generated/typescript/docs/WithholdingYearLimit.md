
# WithholdingYearLimit


## Properties

Name | Type
------------ | -------------
`taxableYear` | number
`totalCentavos` | number
`limitCentavos` | number
`crossed` | boolean
`status` | string

## Example

```typescript
import type { WithholdingYearLimit } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "taxableYear": null,
  "totalCentavos": null,
  "limitCentavos": null,
  "crossed": null,
  "status": null,
} satisfies WithholdingYearLimit

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WithholdingYearLimit
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


