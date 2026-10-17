# materyalph_api_client.model.VendorNavigationUpdates

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**sections** | **BuiltMap&lt;String, int&gt;** | Fixed Vendor sidebar paths mapped to section counts. Orders counts currently visible nonterminal orders; completed, declined, expired and cancelled orders are excluded. Team Accounts counts manageable active non-Owner memberships with active user accounts; deleted memberships and unaccepted invitations are excluded. Without current staff-management permission its count is zero. Notifications counts unread notices only; Messages counts received sales and fulfillment messages without a read receipt, restricted to the viewer current role, organization and assignment scope. Fulfillment counts visible confirmed, processing and handover-stage orders. Disputes counts active cases; Invoices counts outstanding requests and remains pending when its notice is read. Store Profile is omitted. Zero or missing counts have no indicator. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


