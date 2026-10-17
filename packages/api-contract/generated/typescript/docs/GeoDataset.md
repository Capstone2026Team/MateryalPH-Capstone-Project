
# GeoDataset


## Properties

Name | Type
------------ | -------------
`environment` | string
`label` | string
`demo` | boolean
`lastAggregatedAt` | Date
`throughDate` | string
`revision` | number
`available` | boolean

## Example

```typescript
import type { GeoDataset } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "environment": null,
  "label": null,
  "demo": null,
  "lastAggregatedAt": null,
  "throughDate": null,
  "revision": null,
  "available": null,
} satisfies GeoDataset

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoDataset
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


