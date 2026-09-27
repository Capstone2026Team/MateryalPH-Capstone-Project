
# ComplianceEvidence


## Properties

Name | Type
------------ | -------------
`evidenceId` | string
`fileId` | string
`path` | [CompliancePath](CompliancePath.md)
`evidenceKind` | string
`contentType` | string
`byteSize` | number
`scanState` | string
`extraction` | [ComplianceExtraction](ComplianceExtraction.md)

## Example

```typescript
import type { ComplianceEvidence } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "evidenceId": null,
  "fileId": null,
  "path": null,
  "evidenceKind": null,
  "contentType": null,
  "byteSize": null,
  "scanState": null,
  "extraction": null,
} satisfies ComplianceEvidence

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComplianceEvidence
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


