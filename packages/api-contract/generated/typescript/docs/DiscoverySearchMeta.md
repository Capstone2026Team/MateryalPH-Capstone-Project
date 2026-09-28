
# DiscoverySearchMeta


## Properties

Name | Type
------------ | -------------
`correlationId` | string
`scope` | [DiscoveryScope](DiscoveryScope.md)
`currentAsOf` | Date
`eligibilityVersion` | string
`projectionVersion` | string
`counts` | [DiscoveryCounts](DiscoveryCounts.md)
`directory` | [DirectoryAvailability](DirectoryAvailability.md)
`expansion` | [RadiusExpansion](RadiusExpansion.md)
`page` | number
`perPage` | number
`total` | number
`hasMore` | boolean

## Example

```typescript
import type { DiscoverySearchMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "correlationId": null,
  "scope": null,
  "currentAsOf": null,
  "eligibilityVersion": null,
  "projectionVersion": null,
  "counts": null,
  "directory": null,
  "expansion": null,
  "page": null,
  "perPage": null,
  "total": null,
  "hasMore": null,
} satisfies DiscoverySearchMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DiscoverySearchMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


