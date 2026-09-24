//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_commission_acceptance.g.dart';

/// VendorCommissionAcceptance
///
/// Properties:
/// * [organizationLockVersion]
/// * [agreementVersionId]
/// * [accepted]
@BuiltValue()
abstract class VendorCommissionAcceptance implements Built<VendorCommissionAcceptance, VendorCommissionAcceptanceBuilder> {
  @BuiltValueField(wireName: r'organization_lock_version')
  int get organizationLockVersion;

  @BuiltValueField(wireName: r'agreement_version_id')
  String get agreementVersionId;

  @BuiltValueField(wireName: r'accepted')
  VendorCommissionAcceptanceAcceptedEnum get accepted;
  // enum acceptedEnum {  true,  };

  VendorCommissionAcceptance._();

  factory VendorCommissionAcceptance([void updates(VendorCommissionAcceptanceBuilder b)]) = _$VendorCommissionAcceptance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCommissionAcceptanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCommissionAcceptance> get serializer => _$VendorCommissionAcceptanceSerializer();
}

class _$VendorCommissionAcceptanceSerializer implements PrimitiveSerializer<VendorCommissionAcceptance> {
  @override
  final Iterable<Type> types = const [VendorCommissionAcceptance, _$VendorCommissionAcceptance];

  @override
  final String wireName = r'VendorCommissionAcceptance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCommissionAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'organization_lock_version';
    yield serializers.serialize(
      object.organizationLockVersion,
      specifiedType: const FullType(int),
    );
    yield r'agreement_version_id';
    yield serializers.serialize(
      object.agreementVersionId,
      specifiedType: const FullType(String),
    );
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(VendorCommissionAcceptanceAcceptedEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCommissionAcceptance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCommissionAcceptanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'organization_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.organizationLockVersion = valueDes;
          break;
        case r'agreement_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.agreementVersionId = valueDes;
          break;
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorCommissionAcceptanceAcceptedEnum),
          ) as VendorCommissionAcceptanceAcceptedEnum;
          result.accepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorCommissionAcceptance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCommissionAcceptanceBuilder();
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


class VendorCommissionAcceptanceAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const VendorCommissionAcceptanceAcceptedEnum true_ = _$vendorCommissionAcceptanceAcceptedEnum_true_;

  static Serializer<VendorCommissionAcceptanceAcceptedEnum> get serializer => _$vendorCommissionAcceptanceAcceptedEnumSerializer;

  const VendorCommissionAcceptanceAcceptedEnum._(String name): super(name);

  static BuiltSet<VendorCommissionAcceptanceAcceptedEnum> get values => _$vendorCommissionAcceptanceAcceptedEnumValues;
  static VendorCommissionAcceptanceAcceptedEnum valueOf(String name) => _$vendorCommissionAcceptanceAcceptedEnumValueOf(name);
}

