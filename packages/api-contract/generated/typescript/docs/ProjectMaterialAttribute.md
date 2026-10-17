
# ProjectMaterialAttribute


## Properties

Name | Type
------------ | -------------
`code` | string
`label` | string
`valueType` | string
`allowedValues` | Array&lt;string&gt;
`unitCode` | string
`offeredValues` | Array&lt;string&gt;

## Example

```typescript
import type { ProjectMaterialAttribute } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "label": null,
  "valueType": null,
  "allowedValues": null,
  "unitCode": null,
  "offeredValues": null,
} satisfies ProjectMaterialAttribute

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectMaterialAttribute
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


