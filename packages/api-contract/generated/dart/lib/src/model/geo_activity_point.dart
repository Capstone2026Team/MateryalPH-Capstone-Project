//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_activity_point.g.dart';

/// GeoActivityPoint
///
/// Properties:
/// * [date]
/// * [buyerDau]
/// * [buyerWau]
/// * [buyerMau]
/// * [vendorDau]
/// * [vendorWau]
/// * [vendorMau]
@BuiltValue()
abstract class GeoActivityPoint implements Built<GeoActivityPoint, GeoActivityPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'buyer_dau')
  int? get buyerDau;

  @BuiltValueField(wireName: r'buyer_wau')
  int? get buyerWau;

  @BuiltValueField(wireName: r'buyer_mau')
  int? get buyerMau;

  @BuiltValueField(wireName: r'vendor_dau')
  int? get vendorDau;

  @BuiltValueField(wireName: r'vendor_wau')
  int? get vendorWau;

  @BuiltValueField(wireName: r'vendor_mau')
  int? get vendorMau;

  GeoActivityPoint._();

  factory GeoActivityPoint([void updates(GeoActivityPointBuilder b)]) = _$GeoActivityPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoActivityPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoActivityPoint> get serializer => _$GeoActivityPointSerializer();
}

class _$GeoActivityPointSerializer implements PrimitiveSerializer<GeoActivityPoint> {
  @override
  final Iterable<Type> types = const [GeoActivityPoint, _$GeoActivityPoint];

  @override
  final String wireName = r'GeoActivityPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoActivityPoint object, {
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
    if (object.buyerWau != null) {
      yield r'buyer_wau';
      yield serializers.serialize(
        object.buyerWau,
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
    if (object.vendorDau != null) {
      yield r'vendor_dau';
      yield serializers.serialize(
        object.vendorDau,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.vendorWau != null) {
      yield r'vendor_wau';
      yield serializers.serialize(
        object.vendorWau,
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
    GeoActivityPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoActivityPointBuilder result,
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
        case r'buyer_wau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.buyerWau = valueDes;
          break;
        case r'buyer_mau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.buyerMau = valueDes;
          break;
        case r'vendor_dau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorDau = valueDes;
          break;
        case r'vendor_wau':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorWau = valueDes;
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
  GeoActivityPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoActivityPointBuilder();
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


