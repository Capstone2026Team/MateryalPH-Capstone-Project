//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_vendor_health_classes_inner.g.dart';

/// AdminDashboardVendorHealthClassesInner
///
/// Properties:
/// * [key]
/// * [label]
/// * [count]
@BuiltValue()
abstract class AdminDashboardVendorHealthClassesInner implements Built<AdminDashboardVendorHealthClassesInner, AdminDashboardVendorHealthClassesInnerBuilder> {
  @BuiltValueField(wireName: r'key')
  AdminDashboardVendorHealthClassesInnerKeyEnum get key;
  // enum keyEnum {  HEALTHY,  WATCH,  BELOW_WATCH_LEVEL,  BUILDING_TRACK_RECORD,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'count')
  int get count;

  AdminDashboardVendorHealthClassesInner._();

  factory AdminDashboardVendorHealthClassesInner([void updates(AdminDashboardVendorHealthClassesInnerBuilder b)]) = _$AdminDashboardVendorHealthClassesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardVendorHealthClassesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardVendorHealthClassesInner> get serializer => _$AdminDashboardVendorHealthClassesInnerSerializer();
}

class _$AdminDashboardVendorHealthClassesInnerSerializer implements PrimitiveSerializer<AdminDashboardVendorHealthClassesInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardVendorHealthClassesInner, _$AdminDashboardVendorHealthClassesInner];

  @override
  final String wireName = r'AdminDashboardVendorHealthClassesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardVendorHealthClassesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(AdminDashboardVendorHealthClassesInnerKeyEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardVendorHealthClassesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardVendorHealthClassesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardVendorHealthClassesInnerKeyEnum),
          ) as AdminDashboardVendorHealthClassesInnerKeyEnum;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardVendorHealthClassesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardVendorHealthClassesInnerBuilder();
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


class AdminDashboardVendorHealthClassesInnerKeyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'HEALTHY')
  static const AdminDashboardVendorHealthClassesInnerKeyEnum HEALTHY = _$adminDashboardVendorHealthClassesInnerKeyEnum_HEALTHY;
  @BuiltValueEnumConst(wireName: r'WATCH')
  static const AdminDashboardVendorHealthClassesInnerKeyEnum WATCH = _$adminDashboardVendorHealthClassesInnerKeyEnum_WATCH;
  @BuiltValueEnumConst(wireName: r'BELOW_WATCH_LEVEL')
  static const AdminDashboardVendorHealthClassesInnerKeyEnum BELOW_WATCH_LEVEL = _$adminDashboardVendorHealthClassesInnerKeyEnum_BELOW_WATCH_LEVEL;
  @BuiltValueEnumConst(wireName: r'BUILDING_TRACK_RECORD')
  static const AdminDashboardVendorHealthClassesInnerKeyEnum BUILDING_TRACK_RECORD = _$adminDashboardVendorHealthClassesInnerKeyEnum_BUILDING_TRACK_RECORD;

  static Serializer<AdminDashboardVendorHealthClassesInnerKeyEnum> get serializer => _$adminDashboardVendorHealthClassesInnerKeyEnumSerializer;

  const AdminDashboardVendorHealthClassesInnerKeyEnum._(String name): super(name);

  static BuiltSet<AdminDashboardVendorHealthClassesInnerKeyEnum> get values => _$adminDashboardVendorHealthClassesInnerKeyEnumValues;
  static AdminDashboardVendorHealthClassesInnerKeyEnum valueOf(String name) => _$adminDashboardVendorHealthClassesInnerKeyEnumValueOf(name);
}

