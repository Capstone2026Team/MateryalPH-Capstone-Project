
# AutomaticRecoveryHealth


## Properties

Name | Type
------------ | -------------
`status` | string
`maxCycles` | number
`delaysMinutes` | Array&lt;number&gt;
`lastStartedAt` | Date

## Example

```typescript
import type { AutomaticRecoveryHealth } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "status": null,
  "maxCycles": null,
  "delaysMinutes": null,
  "lastStartedAt": null,
} satisfies AutomaticRecoveryHealth

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutomaticRecoveryHealth
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


