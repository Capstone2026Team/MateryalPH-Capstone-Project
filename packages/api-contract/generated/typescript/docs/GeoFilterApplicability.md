
# GeoFilterApplicability


## Properties

Name | Type
------------ | -------------
`filter` | string
`appliesTo` | Array&lt;string&gt;
`notApplicableTo` | Array&lt;string&gt;
`note` | string

## Example

```typescript
import type { GeoFilterApplicability } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "filter": null,
  "appliesTo": null,
  "notApplicableTo": null,
  "note": null,
} satisfies GeoFilterApplicability

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoFilterApplicability
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


