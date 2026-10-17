//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_activity_point.g.dart';

/// AdminDashboardActivityPoint
///
/// Properties:
/// * [date]
/// * [buyerDau]
/// * [vendorDau]
/// * [buyerMau]
/// * [vendorMau]
@BuiltValue()
abstract class AdminDashboardActivityPoint implements Built<AdminDashboardActivityPoint, AdminDashboardActivityPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'buyer_dau')
  int? get buyerDau;

  @BuiltValueField(wireName: r'vendor_dau')
  int? get vendorDau;

  @BuiltValueField(wireName: r'buyer_mau')
  int? get buyerMau;

  @BuiltValueField(wireName: r'vendor_mau')
  int? get vendorMau;

  AdminDashboardActivityPoint._();

  factory AdminDashboardActivityPoint([void updates(AdminDashboardActivityPointBuilder b)]) = _$AdminDashboardActivityPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardActivityPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardActivityPoint> get serializer => _$AdminDashboardActivityPointSerializer();
}

class _$AdminDashboardActivityPointSerializer implements PrimitiveSerializer<AdminDashboardActivityPoint> {
  @override
  final Iterable<Type> types = const [AdminDashboardActivityPoint, _$AdminDashboardActivityPoint];

  @override
  final String wireName = r'AdminDashboardActivityPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardActivityPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    if (object.buyerDau != null) {
      yield r'buyer_dau';
      yield serializers.serialize(
        object.buyerDau,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.vendorDau != null) {
      yield r'vendor_dau';
      yield serializers.serialize(
        object.vendorDau,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.buyerMau != null) {
      yield r'buyer_mau';
      yield serializers.serialize(
        object.buyerMau,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.vendorMau != null) {
      yield r'vendor_mau';
      yield serializers.serialize(
        object.vendorMau,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardActivityPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardActivityPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'buyer_dau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.buyerDau = valueDes;
          break;
        case r'vendor_dau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorDau = valueDes;
          break;
        case r'buyer_mau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.buyerMau = valueDes;
          break;
        case r'vendor_mau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorMau = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardActivityPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardActivityPointBuilder();
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


