
# PsgcResolution

Best resolved versioned PSGC codes. Coordinates stay authoritative; UNRESOLVED is a valid saved state.

## Properties

Name | Type
------------ | -------------
`resolution` | string
`version` | string
`reason` | string
`region` | [PsgcAreaRef](PsgcAreaRef.md)
`province` | [PsgcAreaRef](PsgcAreaRef.md)
`cityMunicipality` | [PsgcAreaRef](PsgcAreaRef.md)
`barangay` | [PsgcAreaRef](PsgcAreaRef.md)

## Example

```typescript
import type { PsgcResolution } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "resolution": null,
  "version": null,
  "reason": null,
  "region": null,
  "province": null,
  "cityMunicipality": null,
  "barangay": null,
} satisfies PsgcResolution

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PsgcResolution
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


