//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_marketplace_disclosure.g.dart';

/// AdminDashboardMarketplaceDisclosure
///
/// Properties:
/// * [minimumPersons]
/// * [method]
/// * [description]
@BuiltValue()
abstract class AdminDashboardMarketplaceDisclosure implements Built<AdminDashboardMarketplaceDisclosure, AdminDashboardMarketplaceDisclosureBuilder> {
  @BuiltValueField(wireName: r'minimum_persons')
  int get minimumPersons;

  @BuiltValueField(wireName: r'method')
  AdminDashboardMarketplaceDisclosureMethodEnum get method;
  // enum methodEnum {  ROLL_UP_TO_PARENT,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  AdminDashboardMarketplaceDisclosure._();

  factory AdminDashboardMarketplaceDisclosure([void updates(AdminDashboardMarketplaceDisclosureBuilder b)]) = _$AdminDashboardMarketplaceDisclosure;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardMarketplaceDisclosureBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardMarketplaceDisclosure> get serializer => _$AdminDashboardMarketplaceDisclosureSerializer();
}

class _$AdminDashboardMarketplaceDisclosureSerializer implements PrimitiveSerializer<AdminDashboardMarketplaceDisclosure> {
  @override
  final Iterable<Type> types = const [AdminDashboardMarketplaceDisclosure, _$AdminDashboardMarketplaceDisclosure];

  @override
  final String wireName = r'AdminDashboardMarketplaceDisclosure';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardMarketplaceDisclosure object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minimum_persons';
    yield serializers.serialize(
      object.minimumPersons,
      specifiedType: const FullType(int),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(AdminDashboardMarketplaceDisclosureMethodEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardMarketplaceDisclosure object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardMarketplaceDisclosureBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minimum_persons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minimumPersons = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardMarketplaceDisclosureMethodEnum),
          ) as AdminDashboardMarketplaceDisclosureMethodEnum;
          result.method = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardMarketplaceDisclosure deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardMarketplaceDisclosureBuilder();
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


class AdminDashboardMarketplaceDisclosureMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ROLL_UP_TO_PARENT')
  static const AdminDashboardMarketplaceDisclosureMethodEnum ROLL_UP_TO_PARENT = _$adminDashboardMarketplaceDisclosureMethodEnum_ROLL_UP_TO_PARENT;

  static Serializer<AdminDashboardMarketplaceDisclosureMethodEnum> get serializer => _$adminDashboardMarketplaceDisclosureMethodEnumSerializer;

  const AdminDashboardMarketplaceDisclosureMethodEnum._(String name): super(name);

  static BuiltSet<AdminDashboardMarketplaceDisclosureMethodEnum> get values => _$adminDashboardMarketplaceDisclosureMethodEnumValues;
  static AdminDashboardMarketplaceDisclosureMethodEnum valueOf(String name) => _$adminDashboardMarketplaceDisclosureMethodEnumValueOf(name);
}

