//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_staff_update.g.dart';

/// VendorStaffUpdate
///
/// Properties:
/// * [fullName]
/// * [role]
/// * [lockVersion]
@BuiltValue()
abstract class VendorStaffUpdate implements Built<VendorStaffUpdate, VendorStaffUpdateBuilder> {
  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'role')
  VendorStaffUpdateRoleEnum get role;
  // enum roleEnum {  STORE_MANAGER,  STORE_STAFF,  CUSTOMER_SERVICE,  INVENTORY,  FULFILLMENT,  };

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  VendorStaffUpdate._();

  factory VendorStaffUpdate([void updates(VendorStaffUpdateBuilder b)]) = _$VendorStaffUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorStaffUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorStaffUpdate> get serializer => _$VendorStaffUpdateSerializer();
}

class _$VendorStaffUpdateSerializer implements PrimitiveSerializer<VendorStaffUpdate> {
  @override
  final Iterable<Type> types = const [VendorStaffUpdate, _$VendorStaffUpdate];

  @override
  final String wireName = r'VendorStaffUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorStaffUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(VendorStaffUpdateRoleEnum),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorStaffUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorStaffUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorStaffUpdateRoleEnum),
          ) as VendorStaffUpdateRoleEnum;
          result.role = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorStaffUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorStaffUpdateBuilder();
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


class VendorStaffUpdateRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_MANAGER')
  static const VendorStaffUpdateRoleEnum STORE_MANAGER = _$vendorStaffUpdateRoleEnum_STORE_MANAGER;
  @BuiltValueEnumConst(wireName: r'STORE_STAFF')
  static const VendorStaffUpdateRoleEnum STORE_STAFF = _$vendorStaffUpdateRoleEnum_STORE_STAFF;
  @BuiltValueEnumConst(wireName: r'CUSTOMER_SERVICE')
  static const VendorStaffUpdateRoleEnum CUSTOMER_SERVICE = _$vendorStaffUpdateRoleEnum_CUSTOMER_SERVICE;
  @BuiltValueEnumConst(wireName: r'INVENTORY')
  static const VendorStaffUpdateRoleEnum INVENTORY = _$vendorStaffUpdateRoleEnum_INVENTORY;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const VendorStaffUpdateRoleEnum FULFILLMENT = _$vendorStaffUpdateRoleEnum_FULFILLMENT;

  static Serializer<VendorStaffUpdateRoleEnum> get serializer => _$vendorStaffUpdateRoleEnumSerializer;

  const VendorStaffUpdateRoleEnum._(String name): super(name);

  static BuiltSet<VendorStaffUpdateRoleEnum> get values => _$vendorStaffUpdateRoleEnumValues;
  static VendorStaffUpdateRoleEnum valueOf(String name) => _$vendorStaffUpdateRoleEnumValueOf(name);
}

