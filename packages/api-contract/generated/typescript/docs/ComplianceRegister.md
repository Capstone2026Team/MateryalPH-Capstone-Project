
# ComplianceRegister


## Properties

Name | Type
------------ | -------------
`id` | string
`registerKind` | string
`sourceReference` | string
`snapshotDate` | Date
`status` | string
`rowCount` | number
`rejectedRowCount` | number
`activatedAt` | string
`supersededAt` | string
`createdAt` | string
`columnMapping` | { [key: string]: any; }
`rejectedRows` | Array&lt;{ [key: string]: any; }&gt;

## Example

```typescript
import type { ComplianceRegister } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "registerKind": null,
  "sourceReference": null,
  "snapshotDate": null,
  "status": null,
  "rowCount": null,
  "rejectedRowCount": null,
  "activatedAt": null,
  "supersededAt": null,
  "createdAt": null,
  "columnMapping": null,
  "rejectedRows": null,
} satisfies ComplianceRegister

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComplianceRegister
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


