
# VendorOperatingDay


## Properties

Name | Type
------------ | -------------
`weekday` | number
`opensAt` | string
`closesAt` | string
`closed` | boolean

## Example

```typescript
import type { VendorOperatingDay } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "weekday": null,
  "opensAt": null,
  "closesAt": null,
  "closed": null,
} satisfies VendorOperatingDay

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorOperatingDay
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


