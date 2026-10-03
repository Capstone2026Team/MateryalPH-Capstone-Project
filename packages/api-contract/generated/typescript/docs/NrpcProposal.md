
# NrpcProposal

Manual only. 0 < amount ≤ the payable value of the affected lines; line principals sum exactly to the amount. No platform cap.

## Properties

Name | Type
------------ | -------------
`amountCentavos` | number
`reason` | string
`lines` | [Array&lt;NrpcLineAllocation&gt;](NrpcLineAllocation.md)

## Example

```typescript
import type { NrpcProposal } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "amountCentavos": null,
  "reason": null,
  "lines": null,
} satisfies NrpcProposal

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as NrpcProposal
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


