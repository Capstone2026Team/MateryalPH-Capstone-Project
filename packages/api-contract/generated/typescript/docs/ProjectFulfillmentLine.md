
# ProjectFulfillmentLine


## Properties

Name | Type
------------ | -------------
`lineId` | string
`name` | string
`unitCode` | string
`requiredQuantity` | string
`vendorQuantity` | string
`separateQuantity` | string
`substituteQuantity` | string
`remainingQuantity` | string
`status` | string
`missingReason` | string

## Example

```typescript
import type { ProjectFulfillmentLine } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "lineId": null,
  "name": null,
  "unitCode": null,
  "requiredQuantity": null,
  "vendorQuantity": null,
  "separateQuantity": null,
  "substituteQuantity": null,
  "remainingQuantity": null,
  "status": null,
  "missingReason": null,
} satisfies ProjectFulfillmentLine

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProjectFulfillmentLine
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


