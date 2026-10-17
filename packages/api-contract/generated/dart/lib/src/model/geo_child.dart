//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/geo_rate.dart';
import 'package:materyalph_api_client/src/model/geo_child_registered_buyers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_child.g.dart';

/// GeoChild
///
/// Properties:
/// * [code]
/// * [name]
/// * [level]
/// * [levelLabel]
/// * [drillable]
/// * [vendorCount]
/// * [registeredBuyers]
/// * [grossGmvCentavos]
/// * [netGmvCentavos]
/// * [orderVolume]
/// * [fulfillmentRate]
/// * [cancellationRate]
/// * [disputeRate]
/// * [medianResponseSeconds]
/// * [responseSuppressed]
/// * [suppressed]
/// * [suppressionReason]
/// * [suppressionNote]
@BuiltValue()
abstract class GeoChild implements Built<GeoChild, GeoChildBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'level')
  String get level;

  @BuiltValueField(wireName: r'level_label')
  String get levelLabel;

  @BuiltValueField(wireName: r'drillable')
  bool get drillable;

  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'registered_buyers')
  GeoChildRegisteredBuyers get registeredBuyers;

  @BuiltValueField(wireName: r'gross_gmv_centavos')
  GeoChildRegisteredBuyers get grossGmvCentavos;

  @BuiltValueField(wireName: r'net_gmv_centavos')
  GeoChildRegisteredBuyers get netGmvCentavos;

  @BuiltValueField(wireName: r'order_volume')
  GeoChildRegisteredBuyers get orderVolume;

  @BuiltValueField(wireName: r'fulfillment_rate')
  GeoRate get fulfillmentRate;

  @BuiltValueField(wireName: r'cancellation_rate')
  GeoRate get cancellationRate;

  @BuiltValueField(wireName: r'dispute_rate')
  GeoRate get disputeRate;

  @BuiltValueField(wireName: r'median_response_seconds')
  int? get medianResponseSeconds;

  @BuiltValueField(wireName: r'response_suppressed')
  bool get responseSuppressed;

  @BuiltValueField(wireName: r'suppressed')
  bool get suppressed;

  @BuiltValueField(wireName: r'suppression_reason')
  GeoChildSuppressionReasonEnum? get suppressionReason;
  // enum suppressionReasonEnum {  SMALL_CELL,  COMPLEMENTARY,  ,  };

  @BuiltValueField(wireName: r'suppression_note')
  String? get suppressionNote;

  GeoChild._();

  factory GeoChild([void updates(GeoChildBuilder b)]) = _$GeoChild;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoChildBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoChild> get serializer => _$GeoChildSerializer();
}

class _$GeoChildSerializer implements PrimitiveSerializer<GeoChild> {
  @override
  final Iterable<Type> types = const [GeoChild, _$GeoChild];

  @override
  final String wireName = r'GeoChild';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoChild object, {
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
    yield r'level';
    yield serializers.serialize(
      object.level,
      specifiedType: const FullType(String),
    );
    yield r'level_label';
    yield serializers.serialize(
      object.levelLabel,
      specifiedType: const FullType(String),
    );
    yield r'drillable';
    yield serializers.serialize(
      object.drillable,
      specifiedType: const FullType(bool),
    );
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'registered_buyers';
    yield serializers.serialize(
      object.registeredBuyers,
      specifiedType: const FullType(GeoChildRegisteredBuyers),
    );
    yield r'gross_gmv_centavos';
    yield serializers.serialize(
      object.grossGmvCentavos,
      specifiedType: const FullType(GeoChildRegisteredBuyers),
    );
    yield r'net_gmv_centavos';
    yield serializers.serialize(
      object.netGmvCentavos,
      specifiedType: const FullType(GeoChildRegisteredBuyers),
    );
    yield r'order_volume';
    yield serializers.serialize(
      object.orderVolume,
      specifiedType: const FullType(GeoChildRegisteredBuyers),
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
    if (object.medianResponseSeconds != null) {
      yield r'median_response_seconds';
      yield serializers.serialize(
        object.medianResponseSeconds,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'response_suppressed';
    yield serializers.serialize(
      object.responseSuppressed,
      specifiedType: const FullType(bool),
    );
    yield r'suppressed';
    yield serializers.serialize(
      object.suppressed,
      specifiedType: const FullType(bool),
    );
    if (object.suppressionReason != null) {
      yield r'suppression_reason';
      yield serializers.serialize(
        object.suppressionReason,
        specifiedType: const FullType.nullable(GeoChildSuppressionReasonEnum),
      );
    }
    if (object.suppressionNote != null) {
      yield r'suppression_note';
      yield serializers.serialize(
        object.suppressionNote,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoChild object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoChildBuilder result,
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
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.level = valueDes;
          break;
        case r'level_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.levelLabel = valueDes;
          break;
        case r'drillable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.drillable = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'registered_buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoChildRegisteredBuyers),
          ) as GeoChildRegisteredBuyers;
          result.registeredBuyers.replace(valueDes);
          break;
        case r'gross_gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoChildRegisteredBuyers),
          ) as GeoChildRegisteredBuyers;
          result.grossGmvCentavos.replace(valueDes);
          break;
        case r'net_gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoChildRegisteredBuyers),
          ) as GeoChildRegisteredBuyers;
          result.netGmvCentavos.replace(valueDes);
          break;
        case r'order_volume':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoChildRegisteredBuyers),
          ) as GeoChildRegisteredBuyers;
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
        case r'median_response_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.medianResponseSeconds = valueDes;
          break;
        case r'response_suppressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.responseSuppressed = valueDes;
          break;
        case r'suppressed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.suppressed = valueDes;
          break;
        case r'suppression_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GeoChildSuppressionReasonEnum),
          ) as GeoChildSuppressionReasonEnum?;
          if (valueDes == null) continue;
          result.suppressionReason = valueDes;
          break;
        case r'suppression_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.suppressionNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoChild deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoChildBuilder();
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


class GeoChildSuppressionReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SMALL_CELL')
  static const GeoChildSuppressionReasonEnum SMALL_CELL = _$geoChildSuppressionReasonEnum_SMALL_CELL;
  @BuiltValueEnumConst(wireName: r'COMPLEMENTARY')
  static const GeoChildSuppressionReasonEnum COMPLEMENTARY = _$geoChildSuppressionReasonEnum_COMPLEMENTARY;

  static Serializer<GeoChildSuppressionReasonEnum> get serializer => _$geoChildSuppressionReasonEnumSerializer;

  const GeoChildSuppressionReasonEnum._(String name): super(name);

  static BuiltSet<GeoChildSuppressionReasonEnum> get values => _$geoChildSuppressionReasonEnumValues;
  static GeoChildSuppressionReasonEnum valueOf(String name) => _$geoChildSuppressionReasonEnumValueOf(name);
}

