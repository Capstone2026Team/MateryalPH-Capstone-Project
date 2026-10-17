
# AuditEventDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`createdAt` | Date
`actor` | string
`actorRole` | string
`action` | string
`resourceType` | string
`resourceId` | string
`organization` | string
`organizationId` | string
`succeeded` | boolean
`reason` | string
`correlationId` | string
`hasDetail` | boolean
`before` | any
`after` | any
`redactionNote` | string

## Example

```typescript
import type { AuditEventDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "createdAt": null,
  "actor": null,
  "actorRole": null,
  "action": null,
  "resourceType": null,
  "resourceId": null,
  "organization": null,
  "organizationId": null,
  "succeeded": null,
  "reason": null,
  "correlationId": null,
  "hasDetail": null,
  "before": null,
  "after": null,
  "redactionNote": null,
} satisfies AuditEventDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AuditEventDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


