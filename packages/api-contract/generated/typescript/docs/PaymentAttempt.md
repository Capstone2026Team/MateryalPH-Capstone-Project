
# PaymentAttempt

Client view of one payment attempt. Everything before a verified provider capture reads PENDING; a redirect never yields PAID. The hosted checkout link is returned only to its payer while open.

## Properties

Name | Type
------------ | -------------
`id` | string
`purpose` | string
`status` | string
`attemptNumber` | number
`orderId` | string
`statementId` | string
`channelCode` | string
`channelName` | string
`principalCentavos` | number
`processingFeeCentavos` | number
`totalCentavos` | number
`feeBearer` | string
`expiresAt` | Date
`paidAt` | Date
`createdAt` | Date
`environment` | string
`evidenceOrigin` | string
`checkoutUrl` | string
`canCheckStatus` | boolean
`message` | string

## Example

```typescript
import type { PaymentAttempt } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "purpose": null,
  "status": null,
  "attemptNumber": null,
  "orderId": null,
  "statementId": null,
  "channelCode": null,
  "channelName": null,
  "principalCentavos": null,
  "processingFeeCentavos": null,
  "totalCentavos": null,
  "feeBearer": null,
  "expiresAt": null,
  "paidAt": null,
  "createdAt": null,
  "environment": null,
  "evidenceOrigin": null,
  "checkoutUrl": null,
  "canCheckStatus": null,
  "message": null,
} satisfies PaymentAttempt

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PaymentAttempt
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


