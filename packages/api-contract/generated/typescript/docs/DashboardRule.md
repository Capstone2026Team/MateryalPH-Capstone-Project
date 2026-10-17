
# DashboardRule

Apriori association rule: items ordered together more often than chance (lift above 1). Co-occurrence, not causation.

## Properties

Name | Type
------------ | -------------
`antecedent` | Array&lt;string&gt;
`consequent` | Array&lt;string&gt;
`support` | number
`supportCount` | number
`confidence` | number
`lift` | number

## Example

```typescript
import type { DashboardRule } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "antecedent": null,
  "consequent": null,
  "support": null,
  "supportCount": null,
  "confidence": null,
  "lift": null,
} satisfies DashboardRule

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DashboardRule
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


