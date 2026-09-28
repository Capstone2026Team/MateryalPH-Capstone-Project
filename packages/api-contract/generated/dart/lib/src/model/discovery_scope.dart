//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/radius_km.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discovery_scope.g.dart';

/// Resolved MAT-01 scope. Never includes the exact origin coordinates; origin_version is an opaque identity for stale-response checks.
///
/// Properties:
/// * [audience]
/// * [kind]
/// * [originKind]
/// * [locationId]
/// * [originLabel]
/// * [originVersion]
/// * [radiusKm]
/// * [radiusMeters]
/// * [distanceBasis]
@BuiltValue()
abstract class DiscoveryScope implements Built<DiscoveryScope, DiscoveryScopeBuilder> {
  @BuiltValueField(wireName: r'audience')
  DiscoveryScopeAudienceEnum get audience;
  // enum audienceEnum {  BUYER,  };

  @BuiltValueField(wireName: r'kind')
  DiscoveryScopeKindEnum get kind;
  // enum kindEnum {  RADIUS,  };

  @BuiltValueField(wireName: r'origin_kind')
  DiscoveryScopeOriginKindEnum get originKind;
  // enum originKindEnum {  SAVED_LOCATION,  DEVICE,  MAP_PIN,  SEARCH,  };

  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'origin_label')
  String? get originLabel;

  @BuiltValueField(wireName: r'origin_version')
  String get originVersion;

  @BuiltValueField(wireName: r'radius_km')
  RadiusKm get radiusKm;
  // enum radiusKmEnum {  5,  10,  20,  30,  40,  50,  };

  @BuiltValueField(wireName: r'radius_meters')
  int get radiusMeters;

  @BuiltValueField(wireName: r'distance_basis')
  DiscoveryScopeDistanceBasisEnum get distanceBasis;
  // enum distanceBasisEnum {  GEODESIC_STRAIGHT_LINE,  };

  DiscoveryScope._();

  factory DiscoveryScope([void updates(DiscoveryScopeBuilder b)]) = _$DiscoveryScope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiscoveryScopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiscoveryScope> get serializer => _$DiscoveryScopeSerializer();
}

class _$DiscoveryScopeSerializer implements PrimitiveSerializer<DiscoveryScope> {
  @override
  final Iterable<Type> types = const [DiscoveryScope, _$DiscoveryScope];

  @override
  final String wireName = r'DiscoveryScope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiscoveryScope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(DiscoveryScopeAudienceEnum),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(DiscoveryScopeKindEnum),
    );
    yield r'origin_kind';
    yield serializers.serialize(
      object.originKind,
      specifiedType: const FullType(DiscoveryScopeOriginKindEnum),
    );
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.originLabel != null) {
      yield r'origin_label';
      yield serializers.serialize(
        object.originLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'origin_version';
    yield serializers.serialize(
      object.originVersion,
      specifiedType: const FullType(String),
    );
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(RadiusKm),
    );
    yield r'radius_meters';
    yield serializers.serialize(
      object.radiusMeters,
      specifiedType: const FullType(int),
    );
    yield r'distance_basis';
    yield serializers.serialize(
      object.distanceBasis,
      specifiedType: const FullType(DiscoveryScopeDistanceBasisEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DiscoveryScope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DiscoveryScopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScopeAudienceEnum),
          ) as DiscoveryScopeAudienceEnum;
          result.audience = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScopeKindEnum),
          ) as DiscoveryScopeKindEnum;
          result.kind = valueDes;
          break;
        case r'origin_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScopeOriginKindEnum),
          ) as DiscoveryScopeOriginKindEnum;
          result.originKind = valueDes;
          break;
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'origin_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.originLabel = valueDes;
          break;
        case r'origin_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originVersion = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RadiusKm),
          ) as RadiusKm;
          result.radiusKm = valueDes;
          break;
        case r'radius_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.radiusMeters = valueDes;
          break;
        case r'distance_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScopeDistanceBasisEnum),
          ) as DiscoveryScopeDistanceBasisEnum;
          result.distanceBasis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DiscoveryScope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiscoveryScopeBuilder();
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


class DiscoveryScopeAudienceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DiscoveryScopeAudienceEnum BUYER = _$discoveryScopeAudienceEnum_BUYER;

  static Serializer<DiscoveryScopeAudienceEnum> get serializer => _$discoveryScopeAudienceEnumSerializer;

  const DiscoveryScopeAudienceEnum._(String name): super(name);

  static BuiltSet<DiscoveryScopeAudienceEnum> get values => _$discoveryScopeAudienceEnumValues;
  static DiscoveryScopeAudienceEnum valueOf(String name) => _$discoveryScopeAudienceEnumValueOf(name);
}

class DiscoveryScopeKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RADIUS')
  static const DiscoveryScopeKindEnum RADIUS = _$discoveryScopeKindEnum_RADIUS;

  static Serializer<DiscoveryScopeKindEnum> get serializer => _$discoveryScopeKindEnumSerializer;

  const DiscoveryScopeKindEnum._(String name): super(name);

  static BuiltSet<DiscoveryScopeKindEnum> get values => _$discoveryScopeKindEnumValues;
  static DiscoveryScopeKindEnum valueOf(String name) => _$discoveryScopeKindEnumValueOf(name);
}

class DiscoveryScopeOriginKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SAVED_LOCATION')
  static const DiscoveryScopeOriginKindEnum SAVED_LOCATION = _$discoveryScopeOriginKindEnum_SAVED_LOCATION;
  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const DiscoveryScopeOriginKindEnum DEVICE = _$discoveryScopeOriginKindEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const DiscoveryScopeOriginKindEnum MAP_PIN = _$discoveryScopeOriginKindEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const DiscoveryScopeOriginKindEnum SEARCH = _$discoveryScopeOriginKindEnum_SEARCH;

  static Serializer<DiscoveryScopeOriginKindEnum> get serializer => _$discoveryScopeOriginKindEnumSerializer;

  const DiscoveryScopeOriginKindEnum._(String name): super(name);

  static BuiltSet<DiscoveryScopeOriginKindEnum> get values => _$discoveryScopeOriginKindEnumValues;
  static DiscoveryScopeOriginKindEnum valueOf(String name) => _$discoveryScopeOriginKindEnumValueOf(name);
}

class DiscoveryScopeDistanceBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GEODESIC_STRAIGHT_LINE')
  static const DiscoveryScopeDistanceBasisEnum GEODESIC_STRAIGHT_LINE = _$discoveryScopeDistanceBasisEnum_GEODESIC_STRAIGHT_LINE;

  static Serializer<DiscoveryScopeDistanceBasisEnum> get serializer => _$discoveryScopeDistanceBasisEnumSerializer;

  const DiscoveryScopeDistanceBasisEnum._(String name): super(name);

  static BuiltSet<DiscoveryScopeDistanceBasisEnum> get values => _$discoveryScopeDistanceBasisEnumValues;
  static DiscoveryScopeDistanceBasisEnum valueOf(String name) => _$discoveryScopeDistanceBasisEnumValueOf(name);
}

