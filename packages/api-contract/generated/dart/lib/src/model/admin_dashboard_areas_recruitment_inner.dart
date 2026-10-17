//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_areas_recruitment_inner.g.dart';

/// AdminDashboardAreasRecruitmentInner
///
/// Properties:
/// * [code]
/// * [name]
/// * [vendors]
/// * [orders]
/// * [ordersPerVendor]
@BuiltValue()
abstract class AdminDashboardAreasRecruitmentInner implements Built<AdminDashboardAreasRecruitmentInner, AdminDashboardAreasRecruitmentInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vendors')
  int get vendors;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'orders_per_vendor')
  num get ordersPerVendor;

  AdminDashboardAreasRecruitmentInner._();

  factory AdminDashboardAreasRecruitmentInner([void updates(AdminDashboardAreasRecruitmentInnerBuilder b)]) = _$AdminDashboardAreasRecruitmentInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardAreasRecruitmentInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardAreasRecruitmentInner> get serializer => _$AdminDashboardAreasRecruitmentInnerSerializer();
}

class _$AdminDashboardAreasRecruitmentInnerSerializer implements PrimitiveSerializer<AdminDashboardAreasRecruitmentInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardAreasRecruitmentInner, _$AdminDashboardAreasRecruitmentInner];

  @override
  final String wireName = r'AdminDashboardAreasRecruitmentInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardAreasRecruitmentInner object, {
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
    yield r'orders_per_vendor';
    yield serializers.serialize(
      object.ordersPerVendor,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardAreasRecruitmentInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardAreasRecruitmentInnerBuilder result,
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
        case r'orders_per_vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.ordersPerVendor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardAreasRecruitmentInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardAreasRecruitmentInnerBuilder();
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


