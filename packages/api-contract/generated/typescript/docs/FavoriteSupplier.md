
# FavoriteSupplier


## Properties

Name | Type
------------ | -------------
`vendorId` | string
`name` | string
`logoUrl` | string
`scoreLabel` | [ScoreLabel](ScoreLabel.md)
`currentlyDiscoverable` | boolean
`savedAt` | Date

## Example

```typescript
import type { FavoriteSupplier } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorId": null,
  "name": null,
  "logoUrl": null,
  "scoreLabel": null,
  "currentlyDiscoverable": null,
  "savedAt": null,
} satisfies FavoriteSupplier

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FavoriteSupplier
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


