
# ProjectView


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`status` | string
`budgetCentavos` | number
`startsOn` | string
`endsOn` | string
`lockVersion` | number
`budget` | [ProjectBudget](ProjectBudget.md)
`sites` | [Array&lt;ProjectSite&gt;](ProjectSite.md)
`packages` | [WorkPackagePage](WorkPackagePage.md)

## Example

```typescript
import type { ProjectView } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "status": null,
  "budgetCentavos": null,
  "startsOn": null,
  "endsOn": null,
  "lockVersion": null,
  "budget": null,
  "sites": null,
  "packages": null,
} satisfies ProjectView

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectView
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


