
# AuditEvent


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

## Example

```typescript
import type { AuditEvent } from '@materyalph/api-client-ts'

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
} satisfies AuditEvent

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AuditEvent
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


