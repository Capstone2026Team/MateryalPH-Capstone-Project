
# ComparableGroupCreate


## Properties

Name | Type
------------ | -------------
`materialId` | string
`code` | string
`displayName` | string
`brand` | string
`model` | string
`specification` | { [key: string]: string; }
`canonicalUnitId` | string
`conversionVersion` | string

## Example

```typescript
import type { ComparableGroupCreate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "materialId": null,
  "code": null,
  "displayName": null,
  "brand": null,
  "model": null,
  "specification": null,
  "canonicalUnitId": null,
  "conversionVersion": null,
} satisfies ComparableGroupCreate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComparableGroupCreate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


