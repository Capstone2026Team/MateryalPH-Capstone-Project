
# ProjectCreate


## Properties

Name | Type
------------ | -------------
`name` | string
`budgetCentavos` | number
`startsOn` | string
`endsOn` | string
`locationId` | string

## Example

```typescript
import type { ProjectCreate } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "name": null,
  "budgetCentavos": null,
  "startsOn": null,
  "endsOn": null,
  "locationId": null,
} satisfies ProjectCreate

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectCreate
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


