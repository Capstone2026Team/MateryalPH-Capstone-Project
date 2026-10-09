
# PrivacyRequestDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`requestType` | string
`state` | string
`subjectAccountType` | string
`subjectDisplay` | string
`intakeChannel` | string
`receivedAt` | Date
`targetDate` | Date
`handler` | string
`handlerUserId` | number
`identityVerified` | boolean
`lockVersion` | number
`createdAt` | Date
`scope` | string
`responseSummary` | string
`legalException` | string
`identityVerificationMethod` | string
`identityVerifiedAt` | Date
`subjectMaskedEmail` | string
`completedAt` | Date
`events` | [Array&lt;PrivacyRequestEvent&gt;](PrivacyRequestEvent.md)
`allowedActions` | Array&lt;string&gt;
`handlers` | [Array&lt;PrivacyHandler&gt;](PrivacyHandler.md)

## Example

```typescript
import type { PrivacyRequestDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "requestType": null,
  "state": null,
  "subjectAccountType": null,
  "subjectDisplay": null,
  "intakeChannel": null,
  "receivedAt": null,
  "targetDate": null,
  "handler": null,
  "handlerUserId": null,
  "identityVerified": null,
  "lockVersion": null,
  "createdAt": null,
  "scope": null,
  "responseSummary": null,
  "legalException": null,
  "identityVerificationMethod": null,
  "identityVerifiedAt": null,
  "subjectMaskedEmail": null,
  "completedAt": null,
  "events": null,
  "allowedActions": null,
  "handlers": null,
} satisfies PrivacyRequestDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PrivacyRequestDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


