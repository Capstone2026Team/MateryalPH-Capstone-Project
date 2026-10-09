
# PlatformSettingUpdateRequest

Needs platform_settings.manage and recent re-authentication. 409 SETTING_VERSION_CONFLICT for a stale version; 422 SETTING_INVALID with field errors.

## Properties

Name | Type
------------ | -------------
`value` | any
`expectedVersion` | number
`reason` | string

## Example

```typescript
import type { PlatformSettingUpdateRequest } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "value": null,
  "expectedVersion": null,
  "reason": null,
} satisfies PlatformSettingUpdateRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PlatformSettingUpdateRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


