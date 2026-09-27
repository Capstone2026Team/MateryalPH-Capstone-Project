
# VendorTeamActivity


## Properties

Name | Type
------------ | -------------
`id` | string
`actorName` | string
`actorRole` | string
`action` | string
`resourceType` | string
`resourceId` | string
`createdAt` | Date
`succeeded` | boolean
`before` | { [key: string]: any; }
`after` | { [key: string]: any; }

## Example

```typescript
import type { VendorTeamActivity } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "actorName": null,
  "actorRole": null,
  "action": null,
  "resourceType": null,
  "resourceId": null,
  "createdAt": null,
  "succeeded": null,
  "before": null,
  "after": null,
} satisfies VendorTeamActivity

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeamActivity
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


