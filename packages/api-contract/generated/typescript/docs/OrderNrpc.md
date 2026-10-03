
# OrderNrpc


## Properties

Name | Type
------------ | -------------
`id` | string
`amountCentavos` | number
`reason` | string
`eligibleSubtotalCentavos` | number
`snapshotVersion` | number
`proposedAt` | Date
`affectedLines` | [Array&lt;NrpcAffectedLine&gt;](NrpcAffectedLine.md)
`terms` | [NrpcTermsVersion](NrpcTermsVersion.md)
`cancellationEffect` | string
`status` | string
`acceptedAt` | Date
`flag` | [NrpcFlag](NrpcFlag.md)

## Example

```typescript
import type { OrderNrpc } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "amountCentavos": null,
  "reason": null,
  "eligibleSubtotalCentavos": null,
  "snapshotVersion": null,
  "proposedAt": null,
  "affectedLines": null,
  "terms": null,
  "cancellationEffect": null,
  "status": null,
  "acceptedAt": null,
  "flag": null,
} satisfies OrderNrpc

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderNrpc
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


