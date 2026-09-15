
# VendorTeam


## Properties

Name | Type
------------ | -------------
`members` | [Array&lt;VendorTeamMember&gt;](VendorTeamMember.md)
`page` | number
`lastPage` | number
`total` | number

## Example

```typescript
import type { VendorTeam } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "members": null,
  "page": null,
  "lastPage": null,
  "total": null,
} satisfies VendorTeam

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as VendorTeam
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


