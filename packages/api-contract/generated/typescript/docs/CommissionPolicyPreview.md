
# CommissionPolicyPreview


## Properties

Name | Type
------------ | -------------
`vendorCount` | number
`noticeHours` | number
`noticeRequired` | boolean
`exampleCommissionCentavos` | number
`monthlyBasisCentavos` | number
`estimatedMonthlyChangeCentavos` | number
`volumePeriod` | string
`currentTerms` | string
`newTerms` | string
`emailSubject` | string
`emailHtml` | string

## Example

```typescript
import type { CommissionPolicyPreview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "vendorCount": null,
  "noticeHours": null,
  "noticeRequired": null,
  "exampleCommissionCentavos": null,
  "monthlyBasisCentavos": null,
  "estimatedMonthlyChangeCentavos": null,
  "volumePeriod": null,
  "currentTerms": null,
  "newTerms": null,
  "emailSubject": null,
  "emailHtml": null,
} satisfies CommissionPolicyPreview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CommissionPolicyPreview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


