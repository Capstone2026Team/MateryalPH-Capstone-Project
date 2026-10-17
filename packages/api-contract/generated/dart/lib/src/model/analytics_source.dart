//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'analytics_source.g.dart';

/// AnalyticsSource
///
/// Properties:
/// * [observationId]
/// * [storeName]
/// * [listingId]
/// * [displayName]
/// * [variantLabel]
/// * [priceVersion]
/// * [ordinaryPayableCentavos]
/// * [normalizedPhpExact]
/// * [taxCategory]
/// * [capturedAt]
/// * [priceEffectiveAt]
/// * [selectedForAverage]
/// * [exclusionReason]
/// * [geography]
@BuiltValue()
abstract class AnalyticsSource implements Built<AnalyticsSource, AnalyticsSourceBuilder> {
  @BuiltValueField(wireName: r'observation_id')
  String get observationId;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'price_version')
  int get priceVersion;

  @BuiltValueField(wireName: r'ordinary_payable_centavos')
  int get ordinaryPayableCentavos;

  @BuiltValueField(wireName: r'normalized_php_exact')
  String get normalizedPhpExact;

  @BuiltValueField(wireName: r'tax_category')
  String get taxCategory;

  @BuiltValueField(wireName: r'captured_at')
  DateTime get capturedAt;

  @BuiltValueField(wireName: r'price_effective_at')
  DateTime? get priceEffectiveAt;

  @BuiltValueField(wireName: r'selected_for_average')
  bool get selectedForAverage;

  @BuiltValueField(wireName: r'exclusion_reason')
  String? get exclusionReason;

  @BuiltValueField(wireName: r'geography')
  BuiltMap<String, JsonObject?> get geography;

  AnalyticsSource._();

  factory AnalyticsSource([void updates(AnalyticsSourceBuilder b)]) = _$AnalyticsSource;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnalyticsSourceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnalyticsSource> get serializer => _$AnalyticsSourceSerializer();
}

class _$AnalyticsSourceSerializer implements PrimitiveSerializer<AnalyticsSource> {
  @override
  final Iterable<Type> types = const [AnalyticsSource, _$AnalyticsSource];

  @override
  final String wireName = r'AnalyticsSource';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnalyticsSource object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'observation_id';
    yield serializers.serialize(
      object.observationId,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'price_version';
    yield serializers.serialize(
      object.priceVersion,
      specifiedType: const FullType(int),
    );
    yield r'ordinary_payable_centavos';
    yield serializers.serialize(
      object.ordinaryPayableCentavos,
      specifiedType: const FullType(int),
    );
    yield r'normalized_php_exact';
    yield serializers.serialize(
      object.normalizedPhpExact,
      specifiedType: const FullType(String),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(String),
    );
    yield r'captured_at';
    yield serializers.serialize(
      object.capturedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.priceEffectiveAt != null) {
      yield r'price_effective_at';
      yield serializers.serialize(
        object.priceEffectiveAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'selected_for_average';
    yield serializers.serialize(
      object.selectedForAverage,
      specifiedType: const FullType(bool),
    );
    if (object.exclusionReason != null) {
      yield r'exclusion_reason';
      yield serializers.serialize(
        object.exclusionReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'geography';
    yield serializers.serialize(
      object.geography,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnalyticsSource object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnalyticsSourceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'observation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.observationId = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'price_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceVersion = valueDes;
          break;
        case r'ordinary_payable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordinaryPayableCentavos = valueDes;
          break;
        case r'normalized_php_exact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.normalizedPhpExact = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxCategory = valueDes;
          break;
        case r'captured_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.capturedAt = valueDes;
          break;
        case r'price_effective_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.priceEffectiveAt = valueDes;
          break;
        case r'selected_for_average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.selectedForAverage = valueDes;
          break;
        case r'exclusion_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.exclusionReason = valueDes;
          break;
        case r'geography':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.geography.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnalyticsSource deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnalyticsSourceBuilder();
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


