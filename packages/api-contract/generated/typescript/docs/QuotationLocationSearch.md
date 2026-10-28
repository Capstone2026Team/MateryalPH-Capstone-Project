
# QuotationLocationSearch

Supply exactly one selection - query for address search, latitude plus longitude for a map pin, or address_id to reopen a location previously proposed in this same conversation. Device GPS and the Buyer address book are never queried.

## Properties

Name | Type
------------ | -------------
`query` | string
`latitude` | number
`longitude` | number
`addressId` | string

## Example

```typescript
import type { QuotationLocationSearch } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "query": null,
  "latitude": null,
  "longitude": null,
  "addressId": null,
} satisfies QuotationLocationSearch

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as QuotationLocationSearch
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


