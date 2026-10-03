
# AdminCancellationRequestRow


## Properties

Name | Type
------------ | -------------
`id` | string
`orderReference` | string
`vendorName` | string
`reasonCode` | string
`requestedAt` | Date
`responseDueAt` | Date
`overdue` | boolean

## Example

```typescript
import type { AdminCancellationRequestRow } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "orderReference": null,
  "vendorName": null,
  "reasonCode": null,
  "requestedAt": null,
  "responseDueAt": null,
  "overdue": null,
} satisfies AdminCancellationRequestRow

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminCancellationRequestRow
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


