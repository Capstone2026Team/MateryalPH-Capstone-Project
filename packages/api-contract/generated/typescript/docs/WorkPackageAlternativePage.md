
# WorkPackageAlternativePage


## Properties

Name | Type
------------ | -------------
`line` | { [key: string]: any; }
`status` | string
`locationId` | string
`radiusKm` | number
`items` | [Array&lt;WorkPackageAlternative&gt;](WorkPackageAlternative.md)
`page` | number
`hasMore` | boolean
`total` | number

## Example

```typescript
import type { WorkPackageAlternativePage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "line": null,
  "status": null,
  "locationId": null,
  "radiusKm": null,
  "items": null,
  "page": null,
  "hasMore": null,
  "total": null,
} satisfies WorkPackageAlternativePage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as WorkPackageAlternativePage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


