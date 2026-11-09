
# ProductComplianceQueueEnvelopeMeta


## Properties

Name | Type
------------ | -------------
`currentPage` | number
`lastPage` | number
`total` | number
`counts` | { [key: string]: number; }

## Example

```typescript
import type { ProductComplianceQueueEnvelopeMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "currentPage": null,
  "lastPage": null,
  "total": null,
  "counts": null,
} satisfies ProductComplianceQueueEnvelopeMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProductComplianceQueueEnvelopeMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


