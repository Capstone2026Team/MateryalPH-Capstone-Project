
# PublicBadge

An active automatic badge, shown as text plus an icon. Admin-suppressed badges are omitted.

## Properties

Name | Type
------------ | -------------
`code` | string
`name` | string
`scopeLabel` | string
`description` | string
`earnedAt` | Date

## Example

```typescript
import type { PublicBadge } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "name": null,
  "scopeLabel": null,
  "description": null,
  "earnedAt": null,
} satisfies PublicBadge

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PublicBadge
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


