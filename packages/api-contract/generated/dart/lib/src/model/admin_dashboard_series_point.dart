//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_series_point.g.dart';

/// Suppressed days are gaps (null), never zero.
///
/// Properties:
/// * [date]
/// * [grossGmvCentavos]
/// * [netGmvCentavos]
/// * [orderVolume]
/// * [suppressed]
/// * [grossAverageCentavos]
/// * [volumeAverage]
@BuiltValue()
abstract class AdminDashboardSeriesPoint implements Built<AdminDashboardSeriesPoint, AdminDashboardSeriesPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'gross_gmv_centavos')
  int? get grossGmvCentavos;

  @BuiltValueField(wireName: r'net_gmv_centavos')
  int? get netGmvCentavos;

  @BuiltValueField(wireName: r'order_volume')
  int? get orderVolume;

  @BuiltValueField(wireName: r'suppressed')
  bool get suppressed;

  @BuiltValueField(wireName: r'gross_average_centavos')
  int? get grossAverageCentavos;

  @BuiltValueField(wireName: r'volume_average')
  num? get volumeAverage;

  AdminDashboardSeriesPoint._();

  factory AdminDashboardSeriesPoint([void updates(AdminDashboardSeriesPointBuilder b)]) = _$AdminDashboardSeriesPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardSeriesPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardSeriesPoint> get serializer => _$AdminDashboardSeriesPointSerializer();
}

class _$AdminDashboardSeriesPointSerializer implements PrimitiveSerializer<AdminDashboardSeriesPoint> {
  @override
  final Iterable<Type> types = const [AdminDashboardSeriesPoint, _$AdminDashboardSeriesPoint];

  @override
  final String wireName = r'AdminDashboardSeriesPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardSeriesPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
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
    if (object.grossAverageCentavos != null) {
      yield r'gross_average_centavos';
      yield serializers.serialize(
        object.grossAverageCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.volumeAverage != null) {
      yield r'volume_average';
      yield serializers.serialize(
        object.volumeAverage,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardSeriesPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardSeriesPointBuilder result,
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
        case r'gross_average_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.grossAverageCentavos = valueDes;
          break;
        case r'volume_average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.volumeAverage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardSeriesPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardSeriesPointBuilder();
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


