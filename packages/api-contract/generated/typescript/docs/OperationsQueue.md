
# OperationsQueue


## Properties

Name | Type
------------ | -------------
`key` | string
`label` | string
`group` | string
`count` | number
`href` | string
`description` | string
`oldestAt` | Date

## Example

```typescript
import type { OperationsQueue } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "label": null,
  "group": null,
  "count": null,
  "href": null,
  "description": null,
  "oldestAt": null,
} satisfies OperationsQueue

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OperationsQueue
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


