
# ProductComplianceDecision


## Properties

Name | Type
------------ | -------------
`decision` | string
`lockVersion` | number
`reason` | string
`remarks` | string
`sourceReference` | string

## Example

```typescript
import type { ProductComplianceDecision } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "decision": null,
  "lockVersion": null,
  "reason": null,
  "remarks": null,
  "sourceReference": null,
} satisfies ProductComplianceDecision

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductComplianceDecision
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


