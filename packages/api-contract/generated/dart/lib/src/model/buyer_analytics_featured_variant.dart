//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/buyer_materials_analytics_detail_group.dart';
import 'package:materyalph_api_client/src/model/buyer_analytics_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_featured_variant.g.dart';

/// The most-offered variant, whose average and trend represent the product without blending variants.
///
/// Properties:
/// * [group]
/// * [series]
@BuiltValue()
abstract class BuyerAnalyticsFeaturedVariant implements Built<BuyerAnalyticsFeaturedVariant, BuyerAnalyticsFeaturedVariantBuilder> {
  @BuiltValueField(wireName: r'group')
  BuyerMaterialsAnalyticsDetailGroup get group;

  @BuiltValueField(wireName: r'series')
  BuiltList<BuyerAnalyticsPoint> get series;

  BuyerAnalyticsFeaturedVariant._();

  factory BuyerAnalyticsFeaturedVariant([void updates(BuyerAnalyticsFeaturedVariantBuilder b)]) = _$BuyerAnalyticsFeaturedVariant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAnalyticsFeaturedVariantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsFeaturedVariant> get serializer => _$BuyerAnalyticsFeaturedVariantSerializer();
}

class _$BuyerAnalyticsFeaturedVariantSerializer implements PrimitiveSerializer<BuyerAnalyticsFeaturedVariant> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsFeaturedVariant, _$BuyerAnalyticsFeaturedVariant];

  @override
  final String wireName = r'BuyerAnalyticsFeaturedVariant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsFeaturedVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'group';
    yield serializers.serialize(
      object.group,
      specifiedType: const FullType(BuyerMaterialsAnalyticsDetailGroup),
    );
    yield r'series';
    yield serializers.serialize(
      object.series,
      specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsPoint)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsFeaturedVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsFeaturedVariantBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMaterialsAnalyticsDetailGroup),
          ) as BuyerMaterialsAnalyticsDetailGroup;
          result.group.replace(valueDes);
          break;
        case r'series':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyerAnalyticsPoint)]),
          ) as BuiltList<BuyerAnalyticsPoint>;
          result.series.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAnalyticsFeaturedVariant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAnalyticsFeaturedVariantBuilder();
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


