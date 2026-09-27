
# ComplianceExtraction


## Properties

Name | Type
------------ | -------------
`source` | string
`status` | string
`confidence` | number
`suggestions` | { [key: string]: string; }
`assistanceOnly` | boolean

## Example

```typescript
import type { ComplianceExtraction } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "source": null,
  "status": null,
  "confidence": null,
  "suggestions": null,
  "assistanceOnly": null,
} satisfies ComplianceExtraction

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ComplianceExtraction
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


