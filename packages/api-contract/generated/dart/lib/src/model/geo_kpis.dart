//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_cell.dart';
import 'package:materyalph_api_client/src/model/geo_kpis_active_users.dart';
import 'package:materyalph_api_client/src/model/geo_rate.dart';
import 'package:materyalph_api_client/src/model/geo_response_time.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_kpis.g.dart';

/// GeoKpis
///
/// Properties:
/// * [vendorCount]
/// * [registeredBuyers]
/// * [grossGmvCentavos]
/// * [netGmvCentavos]
/// * [orderVolume]
/// * [fulfillmentRate]
/// * [cancellationRate]
/// * [disputeRate]
/// * [responseTime]
/// * [activeUsers]
@BuiltValue()
abstract class GeoKpis implements Built<GeoKpis, GeoKpisBuilder> {
  @BuiltValueField(wireName: r'vendor_count')
  GeoCell get vendorCount;

  @BuiltValueField(wireName: r'registered_buyers')
  GeoCell get registeredBuyers;

  @BuiltValueField(wireName: r'gross_gmv_centavos')
  GeoCell get grossGmvCentavos;

  @BuiltValueField(wireName: r'net_gmv_centavos')
  GeoCell get netGmvCentavos;

  @BuiltValueField(wireName: r'order_volume')
  GeoCell get orderVolume;

  @BuiltValueField(wireName: r'fulfillment_rate')
  GeoRate get fulfillmentRate;

  @BuiltValueField(wireName: r'cancellation_rate')
  GeoRate get cancellationRate;

  @BuiltValueField(wireName: r'dispute_rate')
  GeoRate get disputeRate;

  @BuiltValueField(wireName: r'response_time')
  GeoResponseTime get responseTime;

  @BuiltValueField(wireName: r'active_users')
  GeoKpisActiveUsers get activeUsers;

  GeoKpis._();

  factory GeoKpis([void updates(GeoKpisBuilder b)]) = _$GeoKpis;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoKpisBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoKpis> get serializer => _$GeoKpisSerializer();
}

class _$GeoKpisSerializer implements PrimitiveSerializer<GeoKpis> {
  @override
  final Iterable<Type> types = const [GeoKpis, _$GeoKpis];

  @override
  final String wireName = r'GeoKpis';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(GeoCell),
    );
    yield r'registered_buyers';
    yield serializers.serialize(
      object.registeredBuyers,
      specifiedType: const FullType(GeoCell),
    );
    yield r'gross_gmv_centavos';
    yield serializers.serialize(
      object.grossGmvCentavos,
      specifiedType: const FullType(GeoCell),
    );
    yield r'net_gmv_centavos';
    yield serializers.serialize(
      object.netGmvCentavos,
      specifiedType: const FullType(GeoCell),
    );
    yield r'order_volume';
    yield serializers.serialize(
      object.orderVolume,
      specifiedType: const FullType(GeoCell),
    );
    yield r'fulfillment_rate';
    yield serializers.serialize(
      object.fulfillmentRate,
      specifiedType: const FullType(GeoRate),
    );
    yield r'cancellation_rate';
    yield serializers.serialize(
      object.cancellationRate,
      specifiedType: const FullType(GeoRate),
    );
    yield r'dispute_rate';
    yield serializers.serialize(
      object.disputeRate,
      specifiedType: const FullType(GeoRate),
    );
    yield r'response_time';
    yield serializers.serialize(
      object.responseTime,
      specifiedType: const FullType(GeoResponseTime),
    );
    yield r'active_users';
    yield serializers.serialize(
      object.activeUsers,
      specifiedType: const FullType(GeoKpisActiveUsers),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoKpisBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.vendorCount.replace(valueDes);
          break;
        case r'registered_buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.registeredBuyers.replace(valueDes);
          break;
        case r'gross_gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.grossGmvCentavos.replace(valueDes);
          break;
        case r'net_gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.netGmvCentavos.replace(valueDes);
          break;
        case r'order_volume':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoCell),
          ) as GeoCell;
          result.orderVolume.replace(valueDes);
          break;
        case r'fulfillment_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoRate),
          ) as GeoRate;
          result.fulfillmentRate.replace(valueDes);
          break;
        case r'cancellation_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoRate),
          ) as GeoRate;
          result.cancellationRate.replace(valueDes);
          break;
        case r'dispute_rate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoRate),
          ) as GeoRate;
          result.disputeRate.replace(valueDes);
          break;
        case r'response_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoResponseTime),
          ) as GeoResponseTime;
          result.responseTime.replace(valueDes);
          break;
        case r'active_users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoKpisActiveUsers),
          ) as GeoKpisActiveUsers;
          result.activeUsers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoKpis deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoKpisBuilder();
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


