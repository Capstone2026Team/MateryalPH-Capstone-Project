
# Cart


## Properties

Name | Type
------------ | -------------
`id` | string
`lockVersion` | number
`currentAsOf` | Date
`destination` | [CartDestination](CartDestination.md)
`groups` | [Array&lt;CartVendorGroup&gt;](CartVendorGroup.md)
`savedForLater` | [Array&lt;CartLine&gt;](CartLine.md)
`summary` | [CartSummary](CartSummary.md)

## Example

```typescript
import type { Cart } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "lockVersion": null,
  "currentAsOf": null,
  "destination": null,
  "groups": null,
  "savedForLater": null,
  "summary": null,
} satisfies Cart

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as Cart
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


