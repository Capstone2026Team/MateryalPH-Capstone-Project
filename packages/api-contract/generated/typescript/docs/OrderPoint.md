
# OrderPoint

A labelled Buyer location. Coordinates are never returned.

## Properties

Name | Type
------------ | -------------
`locationId` | string
`label` | string
`kind` | string
`formattedAddress` | string

## Example

```typescript
import type { OrderPoint } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "locationId": null,
  "label": null,
  "kind": null,
  "formattedAddress": null,
} satisfies OrderPoint

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderPoint
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


