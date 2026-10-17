
# ComplianceLookup


## Properties

Name | Type
------------ | -------------
`markingType` | [MarkingType](MarkingType.md)
`number` | string
`result` | [ComplianceReferenceResult](ComplianceReferenceResult.md)
`reason` | string
`message` | string
`canVerifyAutomatically` | boolean
`register` | [ComplianceLookupRegister](ComplianceLookupRegister.md)
`record` | [ComplianceRegisterRecord](ComplianceRegisterRecord.md)

## Example

```typescript
import type { ComplianceLookup } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "markingType": null,
  "number": null,
  "result": null,
  "reason": null,
  "message": null,
  "canVerifyAutomatically": null,
  "register": null,
  "record": null,
} satisfies ComplianceLookup

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComplianceLookup
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


