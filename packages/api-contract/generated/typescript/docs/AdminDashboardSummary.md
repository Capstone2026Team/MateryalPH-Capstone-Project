
# AdminDashboardSummary


## Properties

Name | Type
------------ | -------------
`generatedAt` | Date
`activeVendors` | number
`inactiveVendors` | number
`activeBuyers` | number
`pendingDocumentReviews` | number
`auditEvents` | number
`canViewAudit` | boolean

## Example

```typescript
import type { AdminDashboardSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "generatedAt": null,
  "activeVendors": null,
  "inactiveVendors": null,
  "activeBuyers": null,
  "pendingDocumentReviews": null,
  "auditEvents": null,
  "canViewAudit": null,
} satisfies AdminDashboardSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


