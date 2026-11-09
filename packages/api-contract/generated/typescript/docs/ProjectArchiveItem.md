
# ProjectArchiveItem


## Properties

Name | Type
------------ | -------------
`id` | string
`type` | string
`name` | string
`budgetCentavos` | number
`lockVersion` | number
`projectId` | string
`projectName` | string
`parentArchived` | boolean
`archivedAt` | Date
`deleteAfter` | Date
`remainingDays` | number
`canRestore` | boolean
`canDelete` | boolean

## Example

```typescript
import type { ProjectArchiveItem } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "type": null,
  "name": null,
  "budgetCentavos": null,
  "lockVersion": null,
  "projectId": null,
  "projectName": null,
  "parentArchived": null,
  "archivedAt": null,
  "deleteAfter": null,
  "remainingDays": null,
  "canRestore": null,
  "canDelete": null,
} satisfies ProjectArchiveItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectArchiveItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


