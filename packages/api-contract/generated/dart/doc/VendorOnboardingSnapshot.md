# materyalph_api_client.model.VendorOnboardingSnapshot

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**stepCompletion** | [**BuiltList&lt;OnboardingStepCompletion&gt;**](OnboardingStepCompletion.md) |  |
**lockVersion** | **int** |  |
**requirements** | [**BuiltList&lt;OnboardingRequirement&gt;**](OnboardingRequirement.md) |  |
**drafts** | [**BuiltList&lt;OnboardingDraftVersion&gt;**](OnboardingDraftVersion.md) |  |
**organization** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**sections** | [**BuiltMap&lt;String, VendorOnboardingSection&gt;**](VendorOnboardingSection.md) |  |
**verification** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Private verification snapshot. Each documents entry includes its latest Admin review (decision, reason, verified_document_number, verified_issue_date, expiration_kind, verified_expiration_date, evidence_source, remarks, reviewed_at), or null when not reviewed. |
**setup** | [**VendorOnboardingSnapshotSetup**](VendorOnboardingSnapshotSetup.md) |  |
**activation** | [**VendorActivationSnapshot**](VendorActivationSnapshot.md) |  |
**welcomeRequired** | **bool** |  |
**permissions** | **BuiltList&lt;String&gt;** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


