//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_areas_unusual_inner.g.dart';

/// AdminDashboardAreasUnusualInner
///
/// Properties:
/// * [code]
/// * [name]
/// * [vendors]
/// * [orders]
/// * [gmvCentavos]
@BuiltValue()
abstract class AdminDashboardAreasUnusualInner implements Built<AdminDashboardAreasUnusualInner, AdminDashboardAreasUnusualInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vendors')
  int get vendors;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'gmv_centavos')
  int get gmvCentavos;

  AdminDashboardAreasUnusualInner._();

  factory AdminDashboardAreasUnusualInner([void updates(AdminDashboardAreasUnusualInnerBuilder b)]) = _$AdminDashboardAreasUnusualInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardAreasUnusualInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardAreasUnusualInner> get serializer => _$AdminDashboardAreasUnusualInnerSerializer();
}

class _$AdminDashboardAreasUnusualInnerSerializer implements PrimitiveSerializer<AdminDashboardAreasUnusualInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardAreasUnusualInner, _$AdminDashboardAreasUnusualInner];

  @override
  final String wireName = r'AdminDashboardAreasUnusualInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardAreasUnusualInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'vendors';
    yield serializers.serialize(
      object.vendors,
      specifiedType: const FullType(int),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'gmv_centavos';
    yield serializers.serialize(
      object.gmvCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardAreasUnusualInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardAreasUnusualInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendors = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.gmvCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardAreasUnusualInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardAreasUnusualInnerBuilder();
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


