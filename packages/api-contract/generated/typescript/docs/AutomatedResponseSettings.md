
# AutomatedResponseSettings


## Properties

Name | Type
------------ | -------------
`enabled` | boolean
`welcomeMessage` | string
`options` | [Array&lt;AutomatedResponseOption&gt;](AutomatedResponseOption.md)
`lockVersion` | number

## Example

```typescript
import type { AutomatedResponseSettings } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "enabled": null,
  "welcomeMessage": null,
  "options": null,
  "lockVersion": null,
} satisfies AutomatedResponseSettings

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AutomatedResponseSettings
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


