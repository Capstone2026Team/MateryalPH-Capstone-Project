//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_setup_draft_delivery.dart';
import 'package:materyalph_api_client/src/model/store_operating_day.dart';
import 'package:materyalph_api_client/src/model/vendor_setup_draft_vehicles_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_setup_draft.g.dart';

/// VendorSetupDraft
///
/// Properties:
/// * [draftLockVersion] - Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT.
/// * [organizationLockVersion]
/// * [formState] - Encrypted JSON setup form progress. Unfinished vehicle entries are not operational configurations. Returned privately as setup.form_state.
/// * [vacationMode] - Owner-only immediate pause of all new procurement. Existing work and messaging remain available. Does not alter weekly hours or activation.
/// * [publicStoreName]
/// * [description]
/// * [bulkCapability]
/// * [fulfillmentMethod]
/// * [publicEmail]
/// * [publicPhone]
/// * [operatingSchedule] - Complete replacement of the normal weekly schedule. All seven distinct weekdays are required. Closed days have null times; Open days need a same-day opening and later closing time.
/// * [delivery]
/// * [vehicles]
@BuiltValue()
abstract class VendorSetupDraft implements Built<VendorSetupDraft, VendorSetupDraftBuilder> {
  /// Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT.
  @BuiltValueField(wireName: r'draft_lock_version')
  int? get draftLockVersion;

  @BuiltValueField(wireName: r'organization_lock_version')
  int get organizationLockVersion;

  /// Encrypted JSON setup form progress. Unfinished vehicle entries are not operational configurations. Returned privately as setup.form_state.
  @BuiltValueField(wireName: r'form_state')
  String? get formState;

  /// Owner-only immediate pause of all new procurement. Existing work and messaging remain available. Does not alter weekly hours or activation.
  @BuiltValueField(wireName: r'vacation_mode')
  bool? get vacationMode;

  @BuiltValueField(wireName: r'public_store_name')
  String? get publicStoreName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'bulk_capability')
  bool? get bulkCapability;

  @BuiltValueField(wireName: r'fulfillment_method')
  VendorSetupDraftFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  SELF_PICKUP,  VENDOR_DELIVERY,  BOTH,  };

  @BuiltValueField(wireName: r'public_email')
  String? get publicEmail;

  @BuiltValueField(wireName: r'public_phone')
  String? get publicPhone;

  /// Complete replacement of the normal weekly schedule. All seven distinct weekdays are required. Closed days have null times; Open days need a same-day opening and later closing time.
  @BuiltValueField(wireName: r'operating_schedule')
  BuiltList<StoreOperatingDay>? get operatingSchedule;

  @BuiltValueField(wireName: r'delivery')
  VendorSetupDraftDelivery? get delivery;

  @BuiltValueField(wireName: r'vehicles')
  BuiltList<VendorSetupDraftVehiclesInner>? get vehicles;

  VendorSetupDraft._();

  factory VendorSetupDraft([void updates(VendorSetupDraftBuilder b)]) = _$VendorSetupDraft;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorSetupDraftBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorSetupDraft> get serializer => _$VendorSetupDraftSerializer();
}

class _$VendorSetupDraftSerializer implements PrimitiveSerializer<VendorSetupDraft> {
  @override
  final Iterable<Type> types = const [VendorSetupDraft, _$VendorSetupDraft];

  @override
  final String wireName = r'VendorSetupDraft';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorSetupDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.draftLockVersion != null) {
      yield r'draft_lock_version';
      yield serializers.serialize(
        object.draftLockVersion,
        specifiedType: const FullType(int),
      );
    }
    yield r'organization_lock_version';
    yield serializers.serialize(
      object.organizationLockVersion,
      specifiedType: const FullType(int),
    );
    if (object.formState != null) {
      yield r'form_state';
      yield serializers.serialize(
        object.formState,
        specifiedType: const FullType(String),
      );
    }
    if (object.vacationMode != null) {
      yield r'vacation_mode';
      yield serializers.serialize(
        object.vacationMode,
        specifiedType: const FullType(bool),
      );
    }
    if (object.publicStoreName != null) {
      yield r'public_store_name';
      yield serializers.serialize(
        object.publicStoreName,
        specifiedType: const FullType(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.bulkCapability != null) {
      yield r'bulk_capability';
      yield serializers.serialize(
        object.bulkCapability,
        specifiedType: const FullType(bool),
      );
    }
    if (object.fulfillmentMethod != null) {
      yield r'fulfillment_method';
      yield serializers.serialize(
        object.fulfillmentMethod,
        specifiedType: const FullType(VendorSetupDraftFulfillmentMethodEnum),
      );
    }
    if (object.publicEmail != null) {
      yield r'public_email';
      yield serializers.serialize(
        object.publicEmail,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.publicPhone != null) {
      yield r'public_phone';
      yield serializers.serialize(
        object.publicPhone,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.operatingSchedule != null) {
      yield r'operating_schedule';
      yield serializers.serialize(
        object.operatingSchedule,
        specifiedType: const FullType(BuiltList, [FullType(StoreOperatingDay)]),
      );
    }
    if (object.delivery != null) {
      yield r'delivery';
      yield serializers.serialize(
        object.delivery,
        specifiedType: const FullType(VendorSetupDraftDelivery),
      );
    }
    if (object.vehicles != null) {
      yield r'vehicles';
      yield serializers.serialize(
        object.vehicles,
        specifiedType: const FullType(BuiltList, [FullType(VendorSetupDraftVehiclesInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorSetupDraft object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorSetupDraftBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'draft_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.draftLockVersion = valueDes;
          break;
        case r'organization_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.organizationLockVersion = valueDes;
          break;
        case r'form_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formState = valueDes;
          break;
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.vacationMode = valueDes;
          break;
        case r'public_store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicStoreName = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'bulk_capability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.bulkCapability = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorSetupDraftFulfillmentMethodEnum),
          ) as VendorSetupDraftFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'public_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicEmail = valueDes;
          break;
        case r'public_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicPhone = valueDes;
          break;
        case r'operating_schedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(StoreOperatingDay)]),
          ) as BuiltList<StoreOperatingDay>?;
          if (valueDes == null) continue;
          result.operatingSchedule.replace(valueDes);
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorSetupDraftDelivery),
          ) as VendorSetupDraftDelivery?;
          if (valueDes == null) continue;
          result.delivery = valueDes.toBuilder();
          break;
        case r'vehicles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(VendorSetupDraftVehiclesInner)]),
          ) as BuiltList<VendorSetupDraftVehiclesInner>?;
          if (valueDes == null) continue;
          result.vehicles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorSetupDraft deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorSetupDraftBuilder();
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


class VendorSetupDraftFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SELF_PICKUP')
  static const VendorSetupDraftFulfillmentMethodEnum SELF_PICKUP = _$vendorSetupDraftFulfillmentMethodEnum_SELF_PICKUP;
  @BuiltValueEnumConst(wireName: r'VENDOR_DELIVERY')
  static const VendorSetupDraftFulfillmentMethodEnum VENDOR_DELIVERY = _$vendorSetupDraftFulfillmentMethodEnum_VENDOR_DELIVERY;
  @BuiltValueEnumConst(wireName: r'BOTH')
  static const VendorSetupDraftFulfillmentMethodEnum BOTH = _$vendorSetupDraftFulfillmentMethodEnum_BOTH;

  static Serializer<VendorSetupDraftFulfillmentMethodEnum> get serializer => _$vendorSetupDraftFulfillmentMethodEnumSerializer;

  const VendorSetupDraftFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<VendorSetupDraftFulfillmentMethodEnum> get values => _$vendorSetupDraftFulfillmentMethodEnumValues;
  static VendorSetupDraftFulfillmentMethodEnum valueOf(String name) => _$vendorSetupDraftFulfillmentMethodEnumValueOf(name);
}

