
# GeoBoundaryCollection

Simplified GeoJSON per child area; properties are code, name and level only. Areas without imported geometry are listed for the tile fallback.

## Properties

Name | Type
------------ | -------------
`type` | string
`features` | Array&lt;{ [key: string]: any; }&gt;
`missingCodes` | Array&lt;string&gt;
`psgcVersion` | [GeoBoundaryCollectionPsgcVersion](GeoBoundaryCollectionPsgcVersion.md)

## Example

```typescript
import type { GeoBoundaryCollection } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "type": null,
  "features": null,
  "missingCodes": null,
  "psgcVersion": null,
} satisfies GeoBoundaryCollection

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoBoundaryCollection
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


