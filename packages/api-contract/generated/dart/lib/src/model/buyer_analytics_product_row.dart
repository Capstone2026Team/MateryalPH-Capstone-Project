//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_price_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_product_row.g.dart';

/// BuyerAnalyticsProductRow
///
/// Properties:
/// * [material]
/// * [category]
/// * [regulated] - True when the material is on the DTI-BPS mandatory PS/ICC list.
/// * [unit]
/// * [variantCount]
/// * [vendorCount] - Distinct Vendors with a current eligible offer of any variant.
/// * [price]
@BuiltValue(instantiable: false)
abstract class BuyerAnalyticsProductRow  {
  @BuiltValueField(wireName: r'material')
  AnalyticsMaterialRef get material;

  @BuiltValueField(wireName: r'category')
  AnalyticsCategoryRef get category;

  /// True when the material is on the DTI-BPS mandatory PS/ICC list.
  @BuiltValueField(wireName: r'regulated')
  bool get regulated;

  @BuiltValueField(wireName: r'unit')
  AnalyticsUnit get unit;

  @BuiltValueField(wireName: r'variant_count')
  int get variantCount;

  /// Distinct Vendors with a current eligible offer of any variant.
  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'price')
  AnalyticsPriceRange get price;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsProductRow> get serializer => _$BuyerAnalyticsProductRowSerializer();
}

class _$BuyerAnalyticsProductRowSerializer implements PrimitiveSerializer<BuyerAnalyticsProductRow> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsProductRow];

  @override
  final String wireName = r'BuyerAnalyticsProductRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsProductRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'material';
    yield serializers.serialize(
      object.material,
      specifiedType: const FullType(AnalyticsMaterialRef),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(AnalyticsCategoryRef),
    );
    yield r'regulated';
    yield serializers.serialize(
      object.regulated,
      specifiedType: const FullType(bool),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(AnalyticsUnit),
    );
    yield r'variant_count';
    yield serializers.serialize(
      object.variantCount,
      specifiedType: const FullType(int),
    );
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(AnalyticsPriceRange),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsProductRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  BuyerAnalyticsProductRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($BuyerAnalyticsProductRow)) as $BuyerAnalyticsProductRow;
  }
}


/// a concrete implementation of [BuyerAnalyticsProductRow], since [BuyerAnalyticsProductRow] is not instantiable
@BuiltValue(instantiable: true)
abstract class $BuyerAnalyticsProductRow implements BuyerAnalyticsProductRow, Built<$BuyerAnalyticsProductRow, $BuyerAnalyticsProductRowBuilder> {
  $BuyerAnalyticsProductRow._();

  factory $BuyerAnalyticsProductRow([void Function($BuyerAnalyticsProductRowBuilder)? updates]) = _$$BuyerAnalyticsProductRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($BuyerAnalyticsProductRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$BuyerAnalyticsProductRow> get serializer => _$$BuyerAnalyticsProductRowSerializer();
}

class _$$BuyerAnalyticsProductRowSerializer implements PrimitiveSerializer<$BuyerAnalyticsProductRow> {
  @override
  final Iterable<Type> types = const [$BuyerAnalyticsProductRow, _$$BuyerAnalyticsProductRow];

  @override
  final String wireName = r'$BuyerAnalyticsProductRow';

  @override
  Object serialize(
    Serializers serializers,
    $BuyerAnalyticsProductRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(BuyerAnalyticsProductRow))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsProductRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'material':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsMaterialRef),
          ) as AnalyticsMaterialRef;
          result.material.replace(valueDes);
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCategoryRef),
          ) as AnalyticsCategoryRef;
          result.category.replace(valueDes);
          break;
        case r'regulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.regulated = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsUnit),
          ) as AnalyticsUnit;
          result.unit.replace(valueDes);
          break;
        case r'variant_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.variantCount = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsPriceRange),
          ) as AnalyticsPriceRange;
          result.price.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $BuyerAnalyticsProductRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $BuyerAnalyticsProductRowBuilder();
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

