
# NotificationItem


## Properties

Name | Type
------------ | -------------
`id` | string
`category` | string
`title` | string
`body` | string
`mandatory` | boolean
`readAt` | string
`createdAt` | string

## Example

```typescript
import type { NotificationItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "category": null,
  "title": null,
  "body": null,
  "mandatory": null,
  "readAt": null,
  "createdAt": null,
} satisfies NotificationItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NotificationItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


