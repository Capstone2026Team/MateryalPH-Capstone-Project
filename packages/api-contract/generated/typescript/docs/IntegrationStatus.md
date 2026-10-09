
# IntegrationStatus


## Properties

Name | Type
------------ | -------------
`key` | string
`label` | string
`status` | string
`detail` | string
`environment` | string
`lastEventAt` | Date

## Example

```typescript
import type { IntegrationStatus } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "key": null,
  "label": null,
  "status": null,
  "detail": null,
  "environment": null,
  "lastEventAt": null,
} satisfies IntegrationStatus

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as IntegrationStatus
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


