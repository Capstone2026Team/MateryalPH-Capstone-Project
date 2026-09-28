
# DiscoveryScope

Resolved MAT-01 scope. Never includes the exact origin coordinates; origin_version is an opaque identity for stale-response checks.

## Properties

Name | Type
------------ | -------------
`audience` | string
`kind` | string
`originKind` | string
`locationId` | string
`originLabel` | string
`originVersion` | string
`radiusKm` | [RadiusKm](RadiusKm.md)
`radiusMeters` | number
`distanceBasis` | string

## Example

```typescript
import type { DiscoveryScope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "audience": null,
  "kind": null,
  "originKind": null,
  "locationId": null,
  "originLabel": null,
  "originVersion": null,
  "radiusKm": null,
  "radiusMeters": null,
  "distanceBasis": null,
} satisfies DiscoveryScope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DiscoveryScope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


