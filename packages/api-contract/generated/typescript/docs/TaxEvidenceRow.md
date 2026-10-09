
# TaxEvidenceRow


## Properties

Name | Type
------------ | -------------
`id` | string
`evidenceType` | string
`origin` | string
`validFrom` | Date
`validUntil` | Date
`reviewState` | string
`reviewedAt` | Date
`taxProfileVersion` | number
`taxableYear` | number
`vendor` | [GeoDemandColumnsInner](GeoDemandColumnsInner.md)
`decisionHref` | string
`createdAt` | Date
`note` | string

## Example

```typescript
import type { TaxEvidenceRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "evidenceType": null,
  "origin": null,
  "validFrom": null,
  "validUntil": null,
  "reviewState": null,
  "reviewedAt": null,
  "taxProfileVersion": null,
  "taxableYear": null,
  "vendor": null,
  "decisionHref": null,
  "createdAt": null,
  "note": null,
} satisfies TaxEvidenceRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as TaxEvidenceRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


