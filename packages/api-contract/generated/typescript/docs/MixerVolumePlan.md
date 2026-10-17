
# MixerVolumePlan

Ready-mixed concrete trip plan. Each full load is limited by Mixer Capacity and by payload at the concrete\'s density; the last trip carries the rest.

## Properties

Name | Type
------------ | -------------
`totalM3` | number
`fullLoadM3` | number
`fullTrips` | number
`lastTripM3` | number

## Example

```typescript
import type { MixerVolumePlan } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "totalM3": null,
  "fullLoadM3": null,
  "fullTrips": null,
  "lastTripM3": null,
} satisfies MixerVolumePlan

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MixerVolumePlan
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


