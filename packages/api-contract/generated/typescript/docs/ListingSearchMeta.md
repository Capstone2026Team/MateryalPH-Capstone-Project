
# ListingSearchMeta


## Properties

Name | Type
------------ | -------------
`correlationId` | string
`scope` | [DiscoveryScope](DiscoveryScope.md)
`currentAsOf` | Date
`eligibilityVersion` | string
`algorithmVersion` | string
`sort` | [ListingSearchSort](ListingSearchSort.md)
`defaultSort` | [ListingSearchSort](ListingSearchSort.md)
`query` | [ListingSearchQuery](ListingSearchQuery.md)
`ranking` | [ListingSearchRanking](ListingSearchRanking.md)
`total` | number
`perPage` | number
`hasMore` | boolean
`nextCursor` | string
`candidateLimitReached` | boolean
`expansion` | [ListingSearchExpansion](ListingSearchExpansion.md)
`tierNote` | string

## Example

```typescript
import type { ListingSearchMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "correlationId": null,
  "scope": null,
  "currentAsOf": null,
  "eligibilityVersion": null,
  "algorithmVersion": null,
  "sort": null,
  "defaultSort": null,
  "query": null,
  "ranking": null,
  "total": null,
  "perPage": null,
  "hasMore": null,
  "nextCursor": null,
  "candidateLimitReached": null,
  "expansion": null,
  "tierNote": null,
} satisfies ListingSearchMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingSearchMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


