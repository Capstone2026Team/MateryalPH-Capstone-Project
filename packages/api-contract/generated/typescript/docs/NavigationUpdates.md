
# NavigationUpdates


## Properties

Name | Type
------------ | -------------
`sections` | { [key: string]: number; }
`cartQuantity` | string
`cartVersion` | number

## Example

```typescript
import type { NavigationUpdates } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "sections": null,
  "cartQuantity": null,
  "cartVersion": null,
} satisfies NavigationUpdates

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NavigationUpdates
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


