//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_rule.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_products_basket_rules.g.dart';

/// Co-ordered materials in the last 90 days across at least two distinct Buyers.
///
/// Properties:
/// * [baskets]
/// * [rules]
/// * [windowDays]
@BuiltValue()
abstract class VendorDashboardOrdersProductsBasketRules implements Built<VendorDashboardOrdersProductsBasketRules, VendorDashboardOrdersProductsBasketRulesBuilder> {
  @BuiltValueField(wireName: r'baskets')
  int get baskets;

  @BuiltValueField(wireName: r'rules')
  BuiltList<DashboardRule> get rules;

  @BuiltValueField(wireName: r'window_days')
  int get windowDays;

  VendorDashboardOrdersProductsBasketRules._();

  factory VendorDashboardOrdersProductsBasketRules([void updates(VendorDashboardOrdersProductsBasketRulesBuilder b)]) = _$VendorDashboardOrdersProductsBasketRules;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersProductsBasketRulesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersProductsBasketRules> get serializer => _$VendorDashboardOrdersProductsBasketRulesSerializer();
}

class _$VendorDashboardOrdersProductsBasketRulesSerializer implements PrimitiveSerializer<VendorDashboardOrdersProductsBasketRules> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersProductsBasketRules, _$VendorDashboardOrdersProductsBasketRules];

  @override
  final String wireName = r'VendorDashboardOrdersProductsBasketRules';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersProductsBasketRules object, {
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
    VendorDashboardOrdersProductsBasketRules object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersProductsBasketRulesBuilder result,
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
  VendorDashboardOrdersProductsBasketRules deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersProductsBasketRulesBuilder();
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


