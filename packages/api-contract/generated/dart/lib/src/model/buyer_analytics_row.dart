//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/comparable_specification.dart';
import 'package:materyalph_api_client/src/model/analytics_current_counts.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/analytics_trend.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:materyalph_api_client/src/model/buyer_analytics_point.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_row.g.dart';

/// BuyerAnalyticsRow
///
/// Properties:
/// * [groupId]
/// * [displayName]
/// * [material]
/// * [category]
/// * [specification]
/// * [unit]
/// * [startPoint]
/// * [endPoint]
/// * [trend]
/// * [current]
@BuiltValue(instantiable: false)
abstract class BuyerAnalyticsRow  {
  @BuiltValueField(wireName: r'group_id')
  String get groupId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'material')
  AnalyticsMaterialRef get material;

  @BuiltValueField(wireName: r'category')
  AnalyticsCategoryRef get category;

  @BuiltValueField(wireName: r'specification')
  ComparableSpecification get specification;

  @BuiltValueField(wireName: r'unit')
  AnalyticsUnit get unit;

  @BuiltValueField(wireName: r'start_point')
  BuyerAnalyticsPoint get startPoint;

  @BuiltValueField(wireName: r'end_point')
  BuyerAnalyticsPoint get endPoint;

  @BuiltValueField(wireName: r'trend')
  AnalyticsTrend get trend;

  @BuiltValueField(wireName: r'current')
  AnalyticsCurrentCounts get current;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsRow> get serializer => _$BuyerAnalyticsRowSerializer();
}

class _$BuyerAnalyticsRowSerializer implements PrimitiveSerializer<BuyerAnalyticsRow> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsRow];

  @override
  final String wireName = r'BuyerAnalyticsRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'group_id';
    yield serializers.serialize(
      object.groupId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
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
    yield r'specification';
    yield serializers.serialize(
      object.specification,
      specifiedType: const FullType(ComparableSpecification),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(AnalyticsUnit),
    );
    yield r'start_point';
    yield serializers.serialize(
      object.startPoint,
      specifiedType: const FullType(BuyerAnalyticsPoint),
    );
    yield r'end_point';
    yield serializers.serialize(
      object.endPoint,
      specifiedType: const FullType(BuyerAnalyticsPoint),
    );
    yield r'trend';
    yield serializers.serialize(
      object.trend,
      specifiedType: const FullType(AnalyticsTrend),
    );
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(AnalyticsCurrentCounts),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  BuyerAnalyticsRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($BuyerAnalyticsRow)) as $BuyerAnalyticsRow;
  }
}


/// a concrete implementation of [BuyerAnalyticsRow], since [BuyerAnalyticsRow] is not instantiable
@BuiltValue(instantiable: true)
abstract class $BuyerAnalyticsRow implements BuyerAnalyticsRow, Built<$BuyerAnalyticsRow, $BuyerAnalyticsRowBuilder> {
  $BuyerAnalyticsRow._();

  factory $BuyerAnalyticsRow([void Function($BuyerAnalyticsRowBuilder)? updates]) = _$$BuyerAnalyticsRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($BuyerAnalyticsRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$BuyerAnalyticsRow> get serializer => _$$BuyerAnalyticsRowSerializer();
}

class _$$BuyerAnalyticsRowSerializer implements PrimitiveSerializer<$BuyerAnalyticsRow> {
  @override
  final Iterable<Type> types = const [$BuyerAnalyticsRow, _$$BuyerAnalyticsRow];

  @override
  final String wireName = r'$BuyerAnalyticsRow';

  @override
  Object serialize(
    Serializers serializers,
    $BuyerAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(BuyerAnalyticsRow))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'group_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.groupId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
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
        case r'specification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComparableSpecification),
          ) as ComparableSpecification;
          result.specification.replace(valueDes);
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsUnit),
          ) as AnalyticsUnit;
          result.unit.replace(valueDes);
          break;
        case r'start_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsPoint),
          ) as BuyerAnalyticsPoint;
          result.startPoint.replace(valueDes);
          break;
        case r'end_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAnalyticsPoint),
          ) as BuyerAnalyticsPoint;
          result.endPoint.replace(valueDes);
          break;
        case r'trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsTrend),
          ) as AnalyticsTrend;
          result.trend.replace(valueDes);
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCurrentCounts),
          ) as AnalyticsCurrentCounts;
          result.current.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $BuyerAnalyticsRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $BuyerAnalyticsRowBuilder();
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

