
# ComparableSpecification


## Properties

Name | Type
------------ | -------------
`brand` | string
`model` | string
`attributes` | [Array&lt;ComparableSpecificationAttributesInner&gt;](ComparableSpecificationAttributesInner.md)

## Example

```typescript
import type { ComparableSpecification } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "brand": null,
  "model": null,
  "attributes": null,
} satisfies ComparableSpecification

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComparableSpecification
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


