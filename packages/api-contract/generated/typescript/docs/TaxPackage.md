
# TaxPackage


## Properties

Name | Type
------------ | -------------
`id` | string
`packageType` | string
`state` | string
`periodStart` | string
`periodEnd` | string
`withholdingEntity` | string
`nominalDueDate` | string
`actualDueDate` | string
`dueDateSource` | string
`dueDateStatus` | string
`dueDateReviewerId` | number
`lockVersion` | number
`snapshot` | { [key: string]: any; }
`contentHash` | string
`submissionState` | string

## Example

```typescript
import type { TaxPackage } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "packageType": null,
  "state": null,
  "periodStart": null,
  "periodEnd": null,
  "withholdingEntity": null,
  "nominalDueDate": null,
  "actualDueDate": null,
  "dueDateSource": null,
  "dueDateStatus": null,
  "dueDateReviewerId": null,
  "lockVersion": null,
  "snapshot": null,
  "contentHash": null,
  "submissionState": null,
} satisfies TaxPackage

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as TaxPackage
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


