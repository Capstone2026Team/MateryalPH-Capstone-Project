
# PlatformSettingVersion


## Properties

Name | Type
------------ | -------------
`version` | number
`value` | any
`previousValue` | any
`source` | string
`reason` | string
`changedBy` | string
`changedRole` | string
`correlationId` | string
`effectiveFrom` | Date

## Example

```typescript
import type { PlatformSettingVersion } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "version": null,
  "value": null,
  "previousValue": null,
  "source": null,
  "reason": null,
  "changedBy": null,
  "changedRole": null,
  "correlationId": null,
  "effectiveFrom": null,
} satisfies PlatformSettingVersion

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PlatformSettingVersion
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


