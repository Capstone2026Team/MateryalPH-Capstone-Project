//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_rule.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_basket_rules.g.dart';

/// VendorProductAnalyticsBasketRules
///
/// Properties:
/// * [baskets]
/// * [rules]
/// * [windowDays]
@BuiltValue()
abstract class VendorProductAnalyticsBasketRules implements Built<VendorProductAnalyticsBasketRules, VendorProductAnalyticsBasketRulesBuilder> {
  @BuiltValueField(wireName: r'baskets')
  int get baskets;

  @BuiltValueField(wireName: r'rules')
  BuiltList<DashboardRule> get rules;

  @BuiltValueField(wireName: r'window_days')
  int get windowDays;

  VendorProductAnalyticsBasketRules._();

  factory VendorProductAnalyticsBasketRules([void updates(VendorProductAnalyticsBasketRulesBuilder b)]) = _$VendorProductAnalyticsBasketRules;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsBasketRulesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsBasketRules> get serializer => _$VendorProductAnalyticsBasketRulesSerializer();
}

class _$VendorProductAnalyticsBasketRulesSerializer implements PrimitiveSerializer<VendorProductAnalyticsBasketRules> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsBasketRules, _$VendorProductAnalyticsBasketRules];

  @override
  final String wireName = r'VendorProductAnalyticsBasketRules';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsBasketRules object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'baskets';
    yield serializers.serialize(
      object.baskets,
      specifiedType: const FullType(int),
    );
    yield r'rules';
    yield serializers.serialize(
      object.rules,
      specifiedType: const FullType(BuiltList, [FullType(DashboardRule)]),
    );
    yield r'window_days';
    yield serializers.serialize(
      object.windowDays,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsBasketRules object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsBasketRulesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'baskets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.baskets = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardRule)]),
          ) as BuiltList<DashboardRule>;
          result.rules.replace(valueDes);
          break;
        case r'window_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.windowDays = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsBasketRules deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsBasketRulesBuilder();
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


