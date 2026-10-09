
# GeoActiveUsers


## Properties

Name | Type
------------ | -------------
`dau` | [GeoCell](GeoCell.md)
`wau` | [GeoCell](GeoCell.md)
`mau` | [GeoCell](GeoCell.md)

## Example

```typescript
import type { GeoActiveUsers } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "dau": null,
  "wau": null,
  "mau": null,
} satisfies GeoActiveUsers

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoActiveUsers
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


