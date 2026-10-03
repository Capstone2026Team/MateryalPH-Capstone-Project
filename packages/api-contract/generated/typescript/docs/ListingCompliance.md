
# ListingCompliance


## Properties

Name | Type
------------ | -------------
`regulated` | boolean
`status` | string
`badge` | string
`requiredMarking` | string
`notice` | string

## Example

```typescript
import type { ListingCompliance } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "regulated": null,
  "status": null,
  "badge": null,
  "requiredMarking": null,
  "notice": null,
} satisfies ListingCompliance

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingCompliance
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


