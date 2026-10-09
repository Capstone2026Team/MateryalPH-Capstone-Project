
# VendorTeamActivityEnvelopeMeta


## Properties

Name | Type
------------ | -------------
`currentPage` | number
`lastPage` | number
`total` | number
`totalEvents` | number
`succeededEvents` | number
`failedEvents` | number
`categories` | [Array&lt;VendorTeamActivityEnvelopeMetaCategoriesInner&gt;](VendorTeamActivityEnvelopeMetaCategoriesInner.md)

## Example

```typescript
import type { VendorTeamActivityEnvelopeMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "currentPage": null,
  "lastPage": null,
  "total": null,
  "totalEvents": null,
  "succeededEvents": null,
  "failedEvents": null,
  "categories": null,
} satisfies VendorTeamActivityEnvelopeMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamActivityEnvelopeMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


