//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_areas_points_inner.g.dart';

/// AdminDashboardAreasPointsInner
///
/// Properties:
/// * [name]
/// * [vendors]
/// * [orders]
/// * [segment]
@BuiltValue()
abstract class AdminDashboardAreasPointsInner implements Built<AdminDashboardAreasPointsInner, AdminDashboardAreasPointsInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vendors')
  int get vendors;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'segment')
  String get segment;

  AdminDashboardAreasPointsInner._();

  factory AdminDashboardAreasPointsInner([void updates(AdminDashboardAreasPointsInnerBuilder b)]) = _$AdminDashboardAreasPointsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardAreasPointsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardAreasPointsInner> get serializer => _$AdminDashboardAreasPointsInnerSerializer();
}

class _$AdminDashboardAreasPointsInnerSerializer implements PrimitiveSerializer<AdminDashboardAreasPointsInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardAreasPointsInner, _$AdminDashboardAreasPointsInner];

  @override
  final String wireName = r'AdminDashboardAreasPointsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardAreasPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'segment';
    yield serializers.serialize(
      object.segment,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardAreasPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardAreasPointsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'segment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.segment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardAreasPointsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardAreasPointsInnerBuilder();
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


