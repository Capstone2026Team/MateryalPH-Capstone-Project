
# PlatformSettingListMeta


## Properties

Name | Type
------------ | -------------
`fixed` | [Array&lt;FixedSetting&gt;](FixedSetting.md)
`canManage` | boolean
`correlationId` | string

## Example

```typescript
import type { PlatformSettingListMeta } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "fixed": null,
  "canManage": null,
  "correlationId": null,
} satisfies PlatformSettingListMeta

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PlatformSettingListMeta
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


