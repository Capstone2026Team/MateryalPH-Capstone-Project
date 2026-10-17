//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dashboard_rule.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_categories_demand_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_categories.g.dart';

/// Category demand and Apriori rules; a category or rule needs at least minimum_buyers distinct Buyers.
///
/// Properties:
/// * [demand]
/// * [suppressedCategories]
/// * [rules]
/// * [baskets]
/// * [minimumBuyers]
@BuiltValue()
abstract class AdminDashboardCategories implements Built<AdminDashboardCategories, AdminDashboardCategoriesBuilder> {
  @BuiltValueField(wireName: r'demand')
  BuiltList<AdminDashboardCategoriesDemandInner> get demand;

  @BuiltValueField(wireName: r'suppressed_categories')
  int get suppressedCategories;

  @BuiltValueField(wireName: r'rules')
  BuiltList<DashboardRule> get rules;

  @BuiltValueField(wireName: r'baskets')
  int get baskets;

  @BuiltValueField(wireName: r'minimum_buyers')
  int get minimumBuyers;

  AdminDashboardCategories._();

  factory AdminDashboardCategories([void updates(AdminDashboardCategoriesBuilder b)]) = _$AdminDashboardCategories;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardCategoriesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardCategories> get serializer => _$AdminDashboardCategoriesSerializer();
}

class _$AdminDashboardCategoriesSerializer implements PrimitiveSerializer<AdminDashboardCategories> {
  @override
  final Iterable<Type> types = const [AdminDashboardCategories, _$AdminDashboardCategories];

  @override
  final String wireName = r'AdminDashboardCategories';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardCategories object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'demand';
    yield serializers.serialize(
      object.demand,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardCategoriesDemandInner)]),
    );
    yield r'suppressed_categories';
    yield serializers.serialize(
      object.suppressedCategories,
      specifiedType: const FullType(int),
    );
    yield r'rules';
    yield serializers.serialize(
      object.rules,
      specifiedType: const FullType(BuiltList, [FullType(DashboardRule)]),
    );
    yield r'baskets';
    yield serializers.serialize(
      object.baskets,
      specifiedType: const FullType(int),
    );
    yield r'minimum_buyers';
    yield serializers.serialize(
      object.minimumBuyers,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardCategories object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardCategoriesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'demand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardCategoriesDemandInner)]),
          ) as BuiltList<AdminDashboardCategoriesDemandInner>;
          result.demand.replace(valueDes);
          break;
        case r'suppressed_categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.suppressedCategories = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DashboardRule)]),
          ) as BuiltList<DashboardRule>;
          result.rules.replace(valueDes);
          break;
        case r'baskets':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.baskets = valueDes;
          break;
        case r'minimum_buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.minimumBuyers = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardCategories deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardCategoriesBuilder();
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


