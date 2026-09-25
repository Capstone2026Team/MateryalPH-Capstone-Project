//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/store_operating_day.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_onboarding_snapshot_setup.g.dart';

/// Private Store Setup snapshot, including the canonical weekly Store Operation schedule.
///
/// Properties:
/// * [operatingSchedule]
@BuiltValue()
abstract class VendorOnboardingSnapshotSetup implements Built<VendorOnboardingSnapshotSetup, VendorOnboardingSnapshotSetupBuilder> {
  @BuiltValueField(wireName: r'operating_schedule')
  BuiltList<StoreOperatingDay>? get operatingSchedule;

  VendorOnboardingSnapshotSetup._();

  factory VendorOnboardingSnapshotSetup([void updates(VendorOnboardingSnapshotSetupBuilder b)]) = _$VendorOnboardingSnapshotSetup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOnboardingSnapshotSetupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOnboardingSnapshotSetup> get serializer => _$VendorOnboardingSnapshotSetupSerializer();
}

class _$VendorOnboardingSnapshotSetupSerializer implements PrimitiveSerializer<VendorOnboardingSnapshotSetup> {
  @override
  final Iterable<Type> types = const [VendorOnboardingSnapshotSetup, _$VendorOnboardingSnapshotSetup];

  @override
  final String wireName = r'VendorOnboardingSnapshotSetup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOnboardingSnapshotSetup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.operatingSchedule != null) {
      yield r'operating_schedule';
      yield serializers.serialize(
        object.operatingSchedule,
        specifiedType: const FullType(BuiltList, [FullType(StoreOperatingDay)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOnboardingSnapshotSetup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOnboardingSnapshotSetupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'operating_schedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(StoreOperatingDay)]),
          ) as BuiltList<StoreOperatingDay>?;
          if (valueDes == null) continue;
          result.operatingSchedule.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOnboardingSnapshotSetup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOnboardingSnapshotSetupBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


