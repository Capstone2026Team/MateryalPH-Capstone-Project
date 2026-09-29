
# StoreHoursDay


## Properties

Name | Type
------------ | -------------
`date` | Date
`dayOfWeek` | number
`weekday` | string
`status` | string
`opensAt` | string
`closesAt` | string
`source` | string

## Example

```typescript
import type { StoreHoursDay } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "date": null,
  "dayOfWeek": null,
  "weekday": null,
  "status": null,
  "opensAt": null,
  "closesAt": null,
  "source": null,
} satisfies StoreHoursDay

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as StoreHoursDay
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


