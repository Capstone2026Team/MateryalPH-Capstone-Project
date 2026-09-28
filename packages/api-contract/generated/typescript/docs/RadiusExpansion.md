
# RadiusExpansion

A suggestion only. The next radius is never applied without Buyer confirmation; 50 km has no further expansion.

## Properties

Name | Type
------------ | -------------
`eligibleVerifiedCount` | number
`suggestedRadiusKm` | number
`atMaximum` | boolean
`reason` | string
`requiresConfirmation` | boolean

## Example

```typescript
import type { RadiusExpansion } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "eligibleVerifiedCount": null,
  "suggestedRadiusKm": null,
  "atMaximum": null,
  "reason": null,
  "requiresConfirmation": null,
} satisfies RadiusExpansion

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RadiusExpansion
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


