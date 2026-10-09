//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_trend_point.g.dart';

/// GeoTrendPoint
///
/// Properties:
/// * [bucket]
/// * [grossGmvCentavos]
/// * [netGmvCentavos]
/// * [orderVolume]
/// * [suppressed]
/// * [reason]
@BuiltValue()
abstract class GeoTrendPoint implements Built<GeoTrendPoint, GeoTrendPointBuilder> {
  @BuiltValueField(wireName: r'bucket')
  Date get bucket;

  @BuiltValueField(wireName: r'gross_gmv_centavos')
  int? get grossGmvCentavos;

  @BuiltValueField(wireName: r'net_gmv_centavos')
  int? get netGmvCentavos;

  @BuiltValueField(wireName: r'order_volume')
  int? get orderVolume;

  @BuiltValueField(wireName: r'suppressed')
  bool get suppressed;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  GeoTrendPoint._();

  factory GeoTrendPoint([void updates(GeoTrendPointBuilder b)]) = _$GeoTrendPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoTrendPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoTrendPoint> get serializer => _$GeoTrendPointSerializer();
}

class _$GeoTrendPointSerializer implements PrimitiveSerializer<GeoTrendPoint> {
  @override
  final Iterable<Type> types = const [GeoTrendPoint, _$GeoTrendPoint];

  @override
  final String wireName = r'GeoTrendPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bucket';
    yield serializers.serialize(
      object.bucket,
      specifiedType: const FullType(Date),
    );
    if (object.grossGmvCentavos != null) {
      yield r'gross_gmv_centavos';
      yield serializers.serialize(
        object.grossGmvCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.netGmvCentavos != null) {
      yield r'net_gmv_centavos';
      yield serializers.serialize(
        object.netGmvCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.orderVolume != null) {
      yield r'order_volume';
      yield serializers.serialize(
        object.orderVolume,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'suppressed';
    yield serializers.serialize(
      object.suppressed,
      specifiedType: const FullType(bool),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoTrendPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoTrendPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bucket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.bucket = valueDes;
          break;
        case r'gross_gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.grossGmvCentavos = valueDes;
          break;
        case r'net_gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.netGmvCentavos = valueDes;
          break;
        case r'order_volume':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.orderVolume = valueDes;
          break;
        case r'suppressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.suppressed = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoTrendPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoTrendPointBuilder();
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


