
# GeoDemand


## Properties

Name | Type
------------ | -------------
`scope` | [GeoScope](GeoScope.md)
`dataset` | [GeoDataset](GeoDataset.md)
`measure` | string
`unit` | string
`dimension` | string
`columns` | [Array&lt;GeoDemandColumnsInner&gt;](GeoDemandColumnsInner.md)
`rows` | [Array&lt;GeoDemandRowsInner&gt;](GeoDemandRowsInner.md)
`columnPagination` | [PageMeta](PageMeta.md)
`notComparableLines` | number
`definition` | string

## Example

```typescript
import type { GeoDemand } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "scope": null,
  "dataset": null,
  "measure": null,
  "unit": null,
  "dimension": null,
  "columns": null,
  "rows": null,
  "columnPagination": null,
  "notComparableLines": null,
  "definition": null,
} satisfies GeoDemand

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoDemand
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


