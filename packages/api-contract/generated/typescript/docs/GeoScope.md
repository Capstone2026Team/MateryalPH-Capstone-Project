
# GeoScope


## Properties

Name | Type
------------ | -------------
`code` | string
`name` | string
`level` | string
`levelLabel` | string
`label` | string
`breadcrumbs` | [Array&lt;GeoBreadcrumb&gt;](GeoBreadcrumb.md)
`childrenLabel` | string
`drillable` | boolean
`psgcVersion` | [GeoScopePsgcVersion](GeoScopePsgcVersion.md)

## Example

```typescript
import type { GeoScope } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "name": null,
  "level": null,
  "levelLabel": null,
  "label": null,
  "breadcrumbs": null,
  "childrenLabel": null,
  "drillable": null,
  "psgcVersion": null,
} satisfies GeoScope

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as GeoScope
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


