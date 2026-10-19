import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  final wire = <String, Object?>{
    'id': 'address',
    'key': 'registered_business_address',
    'label': 'Registered business address',
    'level': 'REQUIRED',
    'status': 'NOT_STARTED',
    'progress_status': 'COMPLETED',
    'lock_version': 1,
  };
  final step = standardSerializers.deserializeWith(
      VendorOnboardingStep.serializer, wire)!;
  if (step.status != VendorOnboardingStepStatusEnum.NOT_STARTED ||
      step.progressStatus != VendorOnboardingStepProgressStatusEnum.COMPLETED) {
    throw StateError('Saved completion must not replace the Admin decision.');
  }
  final restored = standardSerializers.serializeWith(
      VendorOnboardingStep.serializer, step) as Map<String, Object?>;
  if (restored['progress_status'] != 'COMPLETED' ||
      restored['status'] != 'NOT_STARTED') {
    throw StateError('Saved completion must survive a codec round trip.');
  }
  wire.remove('progress_status');
  if (standardSerializers
          .deserializeWith(VendorOnboardingStep.serializer, wire)!
          .progressStatus !=
      null) {
    throw StateError('Older snapshots must remain readable.');
  }
  print(
      'Onboarding progress contract passed: independent completion, review status and optional-field compatibility.');
}
