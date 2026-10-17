
# SiteInspectionDecision


## Properties

Name | Type
------------ | -------------
`lockVersion` | number
`scheduledFor` | Date
`note` | string
`reason` | string
`measuredVolumeM3` | string

## Example

```typescript
import type { SiteInspectionDecision } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lockVersion": null,
  "scheduledFor": null,
  "note": null,
  "reason": null,
  "measuredVolumeM3": null,
} satisfies SiteInspectionDecision

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SiteInspectionDecision
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


