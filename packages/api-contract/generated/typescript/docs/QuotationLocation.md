
# QuotationLocation

Vendor-searched or pinned location scoped to this conversation. Coordinates position the editable map pin; they do not represent device GPS.

## Properties

Name | Type
------------ | -------------
`id` | string
`formattedAddress` | string
`latitude` | number
`longitude` | number

## Example

```typescript
import type { QuotationLocation } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "formattedAddress": null,
  "latitude": null,
  "longitude": null,
} satisfies QuotationLocation

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as QuotationLocation
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


