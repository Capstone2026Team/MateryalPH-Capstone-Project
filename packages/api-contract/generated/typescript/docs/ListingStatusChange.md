
# ListingStatusChange


## Properties

Name | Type
------------ | -------------
`fromStatus` | string
`toStatus` | string
`source` | string
`reasonCode` | string
`reason` | string
`publicationVersion` | number
`createdAt` | string

## Example

```typescript
import type { ListingStatusChange } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fromStatus": null,
  "toStatus": null,
  "source": null,
  "reasonCode": null,
  "reason": null,
  "publicationVersion": null,
  "createdAt": null,
} satisfies ListingStatusChange

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ListingStatusChange
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


