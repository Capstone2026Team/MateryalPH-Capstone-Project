//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/supplier_tier.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_estimate.g.dart';

/// RouteEstimate
///
/// Properties:
/// * [requestVersion]
/// * [originVersion]
/// * [tier]
/// * [supplierId]
/// * [straightLineMeters]
/// * [distanceMeters]
/// * [durationSeconds]
/// * [durationBasis]
/// * [encodedPolyline]
/// * [computedAt]
/// * [cached]
@BuiltValue()
abstract class RouteEstimate implements Built<RouteEstimate, RouteEstimateBuilder> {
  @BuiltValueField(wireName: r'request_version')
  String get requestVersion;

  @BuiltValueField(wireName: r'origin_version')
  String get originVersion;

  @BuiltValueField(wireName: r'tier')
  SupplierTier get tier;
  // enum tierEnum {  VERIFIED_VENDOR,  DIRECTORY_SUPPLIER,  };

  @BuiltValueField(wireName: r'supplier_id')
  String get supplierId;

  @BuiltValueField(wireName: r'straight_line_meters')
  int get straightLineMeters;

  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'duration_seconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'duration_basis')
  RouteEstimateDurationBasisEnum get durationBasis;
  // enum durationBasisEnum {  TRAFFIC_AWARE,  TRAFFIC_UNAWARE,  };

  @BuiltValueField(wireName: r'encoded_polyline')
  String get encodedPolyline;

  @BuiltValueField(wireName: r'computed_at')
  DateTime get computedAt;

  @BuiltValueField(wireName: r'cached')
  bool get cached;

  RouteEstimate._();

  factory RouteEstimate([void updates(RouteEstimateBuilder b)]) = _$RouteEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteEstimate> get serializer => _$RouteEstimateSerializer();
}

class _$RouteEstimateSerializer implements PrimitiveSerializer<RouteEstimate> {
  @override
  final Iterable<Type> types = const [RouteEstimate, _$RouteEstimate];

  @override
  final String wireName = r'RouteEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'request_version';
    yield serializers.serialize(
      object.requestVersion,
      specifiedType: const FullType(String),
    );
    yield r'origin_version';
    yield serializers.serialize(
      object.originVersion,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(SupplierTier),
    );
    yield r'supplier_id';
    yield serializers.serialize(
      object.supplierId,
      specifiedType: const FullType(String),
    );
    yield r'straight_line_meters';
    yield serializers.serialize(
      object.straightLineMeters,
      specifiedType: const FullType(int),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'duration_seconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'duration_basis';
    yield serializers.serialize(
      object.durationBasis,
      specifiedType: const FullType(RouteEstimateDurationBasisEnum),
    );
    yield r'encoded_polyline';
    yield serializers.serialize(
      object.encodedPolyline,
      specifiedType: const FullType(String),
    );
    yield r'computed_at';
    yield serializers.serialize(
      object.computedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'cached';
    yield serializers.serialize(
      object.cached,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'request_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestVersion = valueDes;
          break;
        case r'origin_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originVersion = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierTier),
          ) as SupplierTier;
          result.tier = valueDes;
          break;
        case r'supplier_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.supplierId = valueDes;
          break;
        case r'straight_line_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.straightLineMeters = valueDes;
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'duration_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
          break;
        case r'duration_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteEstimateDurationBasisEnum),
          ) as RouteEstimateDurationBasisEnum;
          result.durationBasis = valueDes;
          break;
        case r'encoded_polyline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.encodedPolyline = valueDes;
          break;
        case r'computed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.computedAt = valueDes;
          break;
        case r'cached':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cached = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteEstimateBuilder();
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


class RouteEstimateDurationBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TRAFFIC_AWARE')
  static const RouteEstimateDurationBasisEnum TRAFFIC_AWARE = _$routeEstimateDurationBasisEnum_TRAFFIC_AWARE;
  @BuiltValueEnumConst(wireName: r'TRAFFIC_UNAWARE')
  static const RouteEstimateDurationBasisEnum TRAFFIC_UNAWARE = _$routeEstimateDurationBasisEnum_TRAFFIC_UNAWARE;

  static Serializer<RouteEstimateDurationBasisEnum> get serializer => _$routeEstimateDurationBasisEnumSerializer;

  const RouteEstimateDurationBasisEnum._(String name): super(name);

  static BuiltSet<RouteEstimateDurationBasisEnum> get values => _$routeEstimateDurationBasisEnumValues;
  static RouteEstimateDurationBasisEnum valueOf(String name) => _$routeEstimateDurationBasisEnumValueOf(name);
}

