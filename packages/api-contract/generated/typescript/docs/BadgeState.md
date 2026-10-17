
# BadgeState


## Properties

Name | Type
------------ | -------------
`code` | string
`name` | string
`description` | string
`status` | string
`scopes` | [Array&lt;BadgeStateScopesInner&gt;](BadgeStateScopesInner.md)
`suppression` | { [key: string]: any; }

## Example

```typescript
import type { BadgeState } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "name": null,
  "description": null,
  "status": null,
  "scopes": null,
  "suppression": null,
} satisfies BadgeState

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BadgeState
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


