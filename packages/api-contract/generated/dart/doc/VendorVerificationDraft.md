# materyalph_api_client.model.VendorVerificationDraft

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**draftLockVersion** | **int** | Version of this workstream draft; zero for its first save. Stale versions return 409. | [optional]
**lockVersion** | **int** |  |
**businessType** | **String** |  | [optional]
**registeredName** | **String** |  | [optional]
**storeName** | **String** |  | [optional]
**dateEstablished** | [**Date**](Date.md) |  | [optional]
**storeEmail** | **String** |  | [optional]
**storePhone** | **String** |  | [optional]
**contacts** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**classification** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**address** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**representative** | [**VendorVerificationDraftRepresentative**](VendorVerificationDraftRepresentative.md) |  | [optional]
**legalIdentity** | [**VendorVerificationDraftLegalIdentity**](VendorVerificationDraftLegalIdentity.md) |  | [optional]
**taxProfile** | [**VendorVerificationDraftTaxProfile**](VendorVerificationDraftTaxProfile.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


