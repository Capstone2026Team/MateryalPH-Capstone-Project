
# DeliveryNavigationRoute


## Properties

Name | Type
------------ | -------------
`origin` | [DeliveryNavigationRoutePoint](DeliveryNavigationRoutePoint.md)
`destination` | [DeliveryNavigationRoutePoint](DeliveryNavigationRoutePoint.md)
`distanceMeters` | number
`durationSeconds` | number
`encodedPolyline` | string
`durationBasis` | string
`computedAt` | Date

## Example

```typescript
import type { DeliveryNavigationRoute } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "origin": null,
  "destination": null,
  "distanceMeters": null,
  "durationSeconds": null,
  "encodedPolyline": null,
  "durationBasis": null,
  "computedAt": null,
} satisfies DeliveryNavigationRoute

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as DeliveryNavigationRoute
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


