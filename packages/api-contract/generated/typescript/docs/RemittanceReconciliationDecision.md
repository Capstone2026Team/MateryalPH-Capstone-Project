
# RemittanceReconciliationDecision


## Properties

Name | Type
------------ | -------------
`id` | string
`assessmentId` | string
`environment` | string
`origin` | string
`method` | string
`actorRole` | string
`reason` | string
`reconciledAt` | Date

## Example

```typescript
import type { RemittanceReconciliationDecision } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "assessmentId": null,
  "environment": null,
  "origin": null,
  "method": null,
  "actorRole": null,
  "reason": null,
  "reconciledAt": null,
} satisfies RemittanceReconciliationDecision

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RemittanceReconciliationDecision
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


