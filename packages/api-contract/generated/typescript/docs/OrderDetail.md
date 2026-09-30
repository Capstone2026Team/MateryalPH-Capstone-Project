
# OrderDetail

Buyer responses add available_actions and payment; Vendor responses add buyer, auto_accept, reservations, permissions, primary_action, nrpc_terms and decline_reasons.

## Properties

Name | Type
------------ | -------------
`id` | string
`reference` | string
`checkout` | [OrderCheckoutRef](OrderCheckoutRef.md)
`vendor` | [OrderVendorRef](OrderVendorRef.md)
`procurementType` | string
`fulfillmentMethod` | string
`paymentMethod` | string
`submittedAt` | Date
`acceptedAt` | Date
`closedAt` | Date
`terminalReasonCode` | string
`confirmationSource` | string
`states` | [Array&lt;OrderStateRow&gt;](OrderStateRow.md)
`deadlines` | [OrderDeadlines](OrderDeadlines.md)
`commercialVersion` | [OrderCommercialVersion](OrderCommercialVersion.md)
`changes` | [Array&lt;OrderChange&gt;](OrderChange.md)
`expectedFulfillmentDate` | Date
`lines` | [Array&lt;OrderLine&gt;](OrderLine.md)
`destination` | [OrderDestination](OrderDestination.md)
`delivery` | [OrderDelivery](OrderDelivery.md)
`money` | [MoneyBreakdown](MoneyBreakdown.md)
`nrpc` | [OrderNrpc](OrderNrpc.md)
`timeline` | [Array&lt;OrderTimelineEvent&gt;](OrderTimelineEvent.md)
`lockVersion` | number
`availableActions` | Array&lt;string&gt;
`payment` | [OrderPaymentAvailability](OrderPaymentAvailability.md)
`buyer` | [OrderBuyerRef](OrderBuyerRef.md)
`autoAccept` | [AutoAcceptOutcome](AutoAcceptOutcome.md)
`reservations` | [Array&lt;OrderReservation&gt;](OrderReservation.md)
`permissions` | [VendorOrderPermissions](VendorOrderPermissions.md)
`primaryAction` | [VendorOrderPrimaryAction](VendorOrderPrimaryAction.md)
`nrpcTerms` | [NrpcTermsRef](NrpcTermsRef.md)
`declineReasons` | [Array&lt;VendorOrderDeclineReason&gt;](VendorOrderDeclineReason.md)

## Example

```typescript
import type { OrderDetail } from '@materyalph/api-client-ts'

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "reference": null,
  "checkout": null,
  "vendor": null,
  "procurementType": null,
  "fulfillmentMethod": null,
  "paymentMethod": null,
  "submittedAt": null,
  "acceptedAt": null,
  "closedAt": null,
  "terminalReasonCode": null,
  "confirmationSource": null,
  "states": null,
  "deadlines": null,
  "commercialVersion": null,
  "changes": null,
  "expectedFulfillmentDate": null,
  "lines": null,
  "destination": null,
  "delivery": null,
  "money": null,
  "nrpc": null,
  "timeline": null,
  "lockVersion": null,
  "availableActions": null,
  "payment": null,
  "buyer": null,
  "autoAccept": null,
  "reservations": null,
  "permissions": null,
  "primaryAction": null,
  "nrpcTerms": null,
  "declineReasons": null,
} satisfies OrderDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as OrderDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


