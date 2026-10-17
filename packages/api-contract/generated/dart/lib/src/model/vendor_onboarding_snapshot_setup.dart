//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/store_operating_day.dart';
import 'package:materyalph_api_client/src/model/vendor_delivery_setup.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_onboarding_snapshot_setup.g.dart';

/// Private Store Setup snapshot, including the canonical weekly Store Operation schedule, the effective vacation_mode boolean and its Vacation Mode window.
///
/// Properties:
/// * [operatingSchedule]
/// * [deliverySetup]
/// * [vacationMode] - True while new procurement is paused.
/// * [vacationStatus] - SCHEDULED when a future start date is saved. ACTIVE with null dates is a legacy open-ended pause the Owner can turn off.
/// * [vacationStartsOn] - Asia/Manila calendar date.
/// * [vacationEndsOn] - Inclusive last Asia/Manila day.
@BuiltValue()
abstract class VendorOnboardingSnapshotSetup implements Built<VendorOnboardingSnapshotSetup, VendorOnboardingSnapshotSetupBuilder> {
  @BuiltValueField(wireName: r'operating_schedule')
  BuiltList<StoreOperatingDay>? get operatingSchedule;

  @BuiltValueField(wireName: r'delivery_setup')
  VendorDeliverySetup? get deliverySetup;

  /// True while new procurement is paused.
  @BuiltValueField(wireName: r'vacation_mode')
  bool? get vacationMode;

  /// SCHEDULED when a future start date is saved. ACTIVE with null dates is a legacy open-ended pause the Owner can turn off.
  @BuiltValueField(wireName: r'vacation_status')
  VendorOnboardingSnapshotSetupVacationStatusEnum? get vacationStatus;
  // enum vacationStatusEnum {  OFF,  SCHEDULED,  ACTIVE,  };

  /// Asia/Manila calendar date.
  @BuiltValueField(wireName: r'vacation_starts_on')
  String? get vacationStartsOn;

  /// Inclusive last Asia/Manila day.
  @BuiltValueField(wireName: r'vacation_ends_on')
  String? get vacationEndsOn;

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
    if (object.deliverySetup != null) {
      yield r'delivery_setup';
      yield serializers.serialize(
        object.deliverySetup,
        specifiedType: const FullType(VendorDeliverySetup),
      );
    }
    if (object.vacationMode != null) {
      yield r'vacation_mode';
      yield serializers.serialize(
        object.vacationMode,
        specifiedType: const FullType(bool),
      );
    }
    if (object.vacationStatus != null) {
      yield r'vacation_status';
      yield serializers.serialize(
        object.vacationStatus,
        specifiedType: const FullType(VendorOnboardingSnapshotSetupVacationStatusEnum),
      );
    }
    if (object.vacationStartsOn != null) {
      yield r'vacation_starts_on';
      yield serializers.serialize(
        object.vacationStartsOn,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.vacationEndsOn != null) {
      yield r'vacation_ends_on';
      yield serializers.serialize(
        object.vacationEndsOn,
        specifiedType: const FullType.nullable(String),
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
        case r'delivery_setup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorDeliverySetup),
          ) as VendorDeliverySetup?;
          if (valueDes == null) continue;
          result.deliverySetup.replace(valueDes);
          break;
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.vacationMode = valueDes;
          break;
        case r'vacation_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorOnboardingSnapshotSetupVacationStatusEnum),
          ) as VendorOnboardingSnapshotSetupVacationStatusEnum?;
          if (valueDes == null) continue;
          result.vacationStatus = valueDes;
          break;
        case r'vacation_starts_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vacationStartsOn = valueDes;
          break;
        case r'vacation_ends_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vacationEndsOn = valueDes;
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


/// SCHEDULED when a future start date is saved. ACTIVE with null dates is a legacy open-ended pause the Owner can turn off.
class VendorOnboardingSnapshotSetupVacationStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OFF')
  static const VendorOnboardingSnapshotSetupVacationStatusEnum OFF = _$vendorOnboardingSnapshotSetupVacationStatusEnum_OFF;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const VendorOnboardingSnapshotSetupVacationStatusEnum SCHEDULED = _$vendorOnboardingSnapshotSetupVacationStatusEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const VendorOnboardingSnapshotSetupVacationStatusEnum ACTIVE = _$vendorOnboardingSnapshotSetupVacationStatusEnum_ACTIVE;

  static Serializer<VendorOnboardingSnapshotSetupVacationStatusEnum> get serializer => _$vendorOnboardingSnapshotSetupVacationStatusEnumSerializer;

  const VendorOnboardingSnapshotSetupVacationStatusEnum._(String name): super(name);

  static BuiltSet<VendorOnboardingSnapshotSetupVacationStatusEnum> get values => _$vendorOnboardingSnapshotSetupVacationStatusEnumValues;
  static VendorOnboardingSnapshotSetupVacationStatusEnum valueOf(String name) => _$vendorOnboardingSnapshotSetupVacationStatusEnumValueOf(name);
}

