
# DashboardAction

Work waiting for this role; present only when the role may act on it.

## Properties

Name | Type
------------ | -------------
`key` | string
`label` | string
`count` | number
`severity` | string
`href` | string
`detail` | string

## Example

```typescript
import type { DashboardAction } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "label": null,
  "count": null,
  "severity": null,
  "href": null,
  "detail": null,
} satisfies DashboardAction

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DashboardAction
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


