
# TaxPackageReview


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`actualDueDate` | string
`dueDateSource` | string
`reason` | string
`reconciled` | boolean

## Example

```typescript
import type { TaxPackageReview } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "actualDueDate": null,
  "dueDateSource": null,
  "reason": null,
  "reconciled": null,
} satisfies TaxPackageReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as TaxPackageReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


