
# GeoDashboardPeriod


## Properties

Name | Type
------------ | -------------
`from` | Date
`to` | Date
`granularity` | string

## Example

```typescript
import type { GeoDashboardPeriod } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "from": null,
  "to": null,
  "granularity": null,
} satisfies GeoDashboardPeriod

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoDashboardPeriod
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


