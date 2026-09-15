//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_checklist_item.g.dart';

/// VendorChecklistItem
///
/// Properties:
/// * [id]
/// * [section]
/// * [label]
/// * [requirementLevel]
/// * [status]
/// * [blocking]
/// * [reason]
/// * [nextAction]
/// * [versionId]
/// * [updatedAt]
/// * [recentAuthenticationRequired]
@BuiltValue()
abstract class VendorChecklistItem implements Built<VendorChecklistItem, VendorChecklistItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'section')
  VendorChecklistItemSectionEnum get section;
  // enum sectionEnum {  STORE_VERIFICATION,  STORE_SETUP,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'requirement_level')
  VendorChecklistItemRequirementLevelEnum get requirementLevel;
  // enum requirementLevelEnum {  REQUIRED,  OPTIONAL,  CONDITIONALLY_REQUIRED,  };

  @BuiltValueField(wireName: r'status')
  VendorChecklistItemStatusEnum get status;
  // enum statusEnum {  NOT_STARTED,  IN_PROGRESS,  SUBMITTED,  PENDING_VERIFICATION,  APPROVED,  COMPLETED,  CHANGES_REQUIRED,  REJECTED,  EXPIRED,  NOT_APPLICABLE,  };

  @BuiltValueField(wireName: r'blocking')
  bool get blocking;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'next_action')
  String get nextAction;

  @BuiltValueField(wireName: r'version_id')
  String? get versionId;

  @BuiltValueField(wireName: r'updated_at')
  String get updatedAt;

  @BuiltValueField(wireName: r'recent_authentication_required')
  bool get recentAuthenticationRequired;

  VendorChecklistItem._();

  factory VendorChecklistItem([void updates(VendorChecklistItemBuilder b)]) = _$VendorChecklistItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorChecklistItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorChecklistItem> get serializer => _$VendorChecklistItemSerializer();
}

class _$VendorChecklistItemSerializer implements PrimitiveSerializer<VendorChecklistItem> {
  @override
  final Iterable<Type> types = const [VendorChecklistItem, _$VendorChecklistItem];

  @override
  final String wireName = r'VendorChecklistItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorChecklistItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'section';
    yield serializers.serialize(
      object.section,
      specifiedType: const FullType(VendorChecklistItemSectionEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'requirement_level';
    yield serializers.serialize(
      object.requirementLevel,
      specifiedType: const FullType(VendorChecklistItemRequirementLevelEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorChecklistItemStatusEnum),
    );
    yield r'blocking';
    yield serializers.serialize(
      object.blocking,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'next_action';
    yield serializers.serialize(
      object.nextAction,
      specifiedType: const FullType(String),
    );
    yield r'version_id';
    yield object.versionId == null ? null : serializers.serialize(
      object.versionId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
    yield r'recent_authentication_required';
    yield serializers.serialize(
      object.recentAuthenticationRequired,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorChecklistItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorChecklistItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'section':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorChecklistItemSectionEnum),
          ) as VendorChecklistItemSectionEnum;
          result.section = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'requirement_level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorChecklistItemRequirementLevelEnum),
          ) as VendorChecklistItemRequirementLevelEnum;
          result.requirementLevel = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorChecklistItemStatusEnum),
          ) as VendorChecklistItemStatusEnum;
          result.status = valueDes;
          break;
        case r'blocking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.blocking = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'next_action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nextAction = valueDes;
          break;
        case r'version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.versionId = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        case r'recent_authentication_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.recentAuthenticationRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorChecklistItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorChecklistItemBuilder();
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


class VendorChecklistItemSectionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_VERIFICATION')
  static const VendorChecklistItemSectionEnum STORE_VERIFICATION = _$vendorChecklistItemSectionEnum_STORE_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'STORE_SETUP')
  static const VendorChecklistItemSectionEnum STORE_SETUP = _$vendorChecklistItemSectionEnum_STORE_SETUP;

  static Serializer<VendorChecklistItemSectionEnum> get serializer => _$vendorChecklistItemSectionEnumSerializer;

  const VendorChecklistItemSectionEnum._(String name): super(name);

  static BuiltSet<VendorChecklistItemSectionEnum> get values => _$vendorChecklistItemSectionEnumValues;
  static VendorChecklistItemSectionEnum valueOf(String name) => _$vendorChecklistItemSectionEnumValueOf(name);
}

class VendorChecklistItemRequirementLevelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUIRED')
  static const VendorChecklistItemRequirementLevelEnum REQUIRED = _$vendorChecklistItemRequirementLevelEnum_REQUIRED;
  @BuiltValueEnumConst(wireName: r'OPTIONAL')
  static const VendorChecklistItemRequirementLevelEnum OPTIONAL = _$vendorChecklistItemRequirementLevelEnum_OPTIONAL;
  @BuiltValueEnumConst(wireName: r'CONDITIONALLY_REQUIRED')
  static const VendorChecklistItemRequirementLevelEnum CONDITIONALLY_REQUIRED = _$vendorChecklistItemRequirementLevelEnum_CONDITIONALLY_REQUIRED;

  static Serializer<VendorChecklistItemRequirementLevelEnum> get serializer => _$vendorChecklistItemRequirementLevelEnumSerializer;

  const VendorChecklistItemRequirementLevelEnum._(String name): super(name);

  static BuiltSet<VendorChecklistItemRequirementLevelEnum> get values => _$vendorChecklistItemRequirementLevelEnumValues;
  static VendorChecklistItemRequirementLevelEnum valueOf(String name) => _$vendorChecklistItemRequirementLevelEnumValueOf(name);
}

class VendorChecklistItemStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_STARTED')
  static const VendorChecklistItemStatusEnum NOT_STARTED = _$vendorChecklistItemStatusEnum_NOT_STARTED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const VendorChecklistItemStatusEnum IN_PROGRESS = _$vendorChecklistItemStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'SUBMITTED')
  static const VendorChecklistItemStatusEnum SUBMITTED = _$vendorChecklistItemStatusEnum_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const VendorChecklistItemStatusEnum PENDING_VERIFICATION = _$vendorChecklistItemStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const VendorChecklistItemStatusEnum APPROVED = _$vendorChecklistItemStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const VendorChecklistItemStatusEnum COMPLETED = _$vendorChecklistItemStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const VendorChecklistItemStatusEnum CHANGES_REQUIRED = _$vendorChecklistItemStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorChecklistItemStatusEnum REJECTED = _$vendorChecklistItemStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorChecklistItemStatusEnum EXPIRED = _$vendorChecklistItemStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'NOT_APPLICABLE')
  static const VendorChecklistItemStatusEnum NOT_APPLICABLE = _$vendorChecklistItemStatusEnum_NOT_APPLICABLE;

  static Serializer<VendorChecklistItemStatusEnum> get serializer => _$vendorChecklistItemStatusEnumSerializer;

  const VendorChecklistItemStatusEnum._(String name): super(name);

  static BuiltSet<VendorChecklistItemStatusEnum> get values => _$vendorChecklistItemStatusEnumValues;
  static VendorChecklistItemStatusEnum valueOf(String name) => _$vendorChecklistItemStatusEnumValueOf(name);
}

