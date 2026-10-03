
# GooglePlacePhoto


## Properties

Name | Type
------------ | -------------
`uri` | string
`authors` | [Array&lt;GoogleContentAuthor&gt;](GoogleContentAuthor.md)
`googleMapsUri` | string

## Example

```typescript
import type { GooglePlacePhoto } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "uri": null,
  "authors": null,
  "googleMapsUri": null,
} satisfies GooglePlacePhoto

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GooglePlacePhoto
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


