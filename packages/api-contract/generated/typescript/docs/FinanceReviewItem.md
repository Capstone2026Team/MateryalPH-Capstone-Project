
# FinanceReviewItem


## Properties

Name | Type
------------ | -------------
`id` | string
`kind` | string
`state` | string
`reasonCode` | string
`summary` | string
`vendor` | { [key: string]: any; }
`sourceType` | string
`sourceId` | string
`expected` | { [key: string]: any; }
`reported` | { [key: string]: any; }
`resolution` | string
`createdAt` | Date
`resolvedAt` | Date

## Example

```typescript
import type { FinanceReviewItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "kind": null,
  "state": null,
  "reasonCode": null,
  "summary": null,
  "vendor": null,
  "sourceType": null,
  "sourceId": null,
  "expected": null,
  "reported": null,
  "resolution": null,
  "createdAt": null,
  "resolvedAt": null,
} satisfies FinanceReviewItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as FinanceReviewItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


