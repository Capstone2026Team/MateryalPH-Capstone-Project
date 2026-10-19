
# SupportTicket


## Properties

Name | Type
------------ | -------------
`id` | string
`ticketNumber` | string
`fullName` | string
`email` | string
`userType` | [SupportUserType](SupportUserType.md)
`category` | [SupportCategory](SupportCategory.md)
`subject` | string
`referenceType` | string
`reference` | string
`status` | [SupportStatus](SupportStatus.md)
`assignedAdminId` | string
`assignedAdminName` | string
`lockVersion` | number
`createdAt` | Date
`updatedAt` | Date

## Example

```typescript
import type { SupportTicket } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "ticketNumber": null,
  "fullName": null,
  "email": null,
  "userType": null,
  "category": null,
  "subject": null,
  "referenceType": null,
  "reference": null,
  "status": null,
  "assignedAdminId": null,
  "assignedAdminName": null,
  "lockVersion": null,
  "createdAt": null,
  "updatedAt": null,
} satisfies SupportTicket

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SupportTicket
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


