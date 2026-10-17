//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_insights_access.g.dart';

/// AdminDashboardInsightsAccess
///
/// Properties:
/// * [marketplace]
/// * [vendorHealth]
@BuiltValue()
abstract class AdminDashboardInsightsAccess implements Built<AdminDashboardInsightsAccess, AdminDashboardInsightsAccessBuilder> {
  @BuiltValueField(wireName: r'marketplace')
  bool get marketplace;

  @BuiltValueField(wireName: r'vendor_health')
  bool get vendorHealth;

  AdminDashboardInsightsAccess._();

  factory AdminDashboardInsightsAccess([void updates(AdminDashboardInsightsAccessBuilder b)]) = _$AdminDashboardInsightsAccess;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardInsightsAccessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardInsightsAccess> get serializer => _$AdminDashboardInsightsAccessSerializer();
}

class _$AdminDashboardInsightsAccessSerializer implements PrimitiveSerializer<AdminDashboardInsightsAccess> {
  @override
  final Iterable<Type> types = const [AdminDashboardInsightsAccess, _$AdminDashboardInsightsAccess];

  @override
  final String wireName = r'AdminDashboardInsightsAccess';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardInsightsAccess object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'marketplace';
    yield serializers.serialize(
      object.marketplace,
      specifiedType: const FullType(bool),
    );
    yield r'vendor_health';
    yield serializers.serialize(
      object.vendorHealth,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardInsightsAccess object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardInsightsAccessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'marketplace':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.marketplace = valueDes;
          break;
        case r'vendor_health':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vendorHealth = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardInsightsAccess deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardInsightsAccessBuilder();
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


