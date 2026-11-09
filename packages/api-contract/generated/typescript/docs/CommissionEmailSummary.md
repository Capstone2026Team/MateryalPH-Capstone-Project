
# CommissionEmailSummary


## Properties

Name | Type
------------ | -------------
`total` | number
`sent` | number
`failed` | number
`queued` | number
`blocked` | number

## Example

```typescript
import type { CommissionEmailSummary } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "total": null,
  "sent": null,
  "failed": null,
  "queued": null,
  "blocked": null,
} satisfies CommissionEmailSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as CommissionEmailSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


