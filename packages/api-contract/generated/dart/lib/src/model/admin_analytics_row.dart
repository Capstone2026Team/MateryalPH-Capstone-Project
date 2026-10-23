//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/admin_analytics_point.dart';
import 'package:materyalph_api_client/src/model/comparable_specification.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/analytics_current_counts.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/analytics_trend.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_analytics_row.g.dart';

/// AdminAnalyticsRow
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
/// * [image] - Photo of the cheapest current in-scope offer that has one, present only with materials_analytics.inspect_sources and null otherwise. Never its listing or store identity.
@BuiltValue(instantiable: false)
abstract class AdminAnalyticsRow  {
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
  AdminAnalyticsPoint get startPoint;

  @BuiltValueField(wireName: r'end_point')
  AdminAnalyticsPoint get endPoint;

  @BuiltValueField(wireName: r'trend')
  AnalyticsTrend get trend;

  @BuiltValueField(wireName: r'current')
  AnalyticsCurrentCounts get current;

  /// Photo of the cheapest current in-scope offer that has one, present only with materials_analytics.inspect_sources and null otherwise. Never its listing or store identity.
  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAnalyticsRow> get serializer => _$AdminAnalyticsRowSerializer();
}

class _$AdminAnalyticsRowSerializer implements PrimitiveSerializer<AdminAnalyticsRow> {
  @override
  final Iterable<Type> types = const [AdminAnalyticsRow];

  @override
  final String wireName = r'AdminAnalyticsRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAnalyticsRow object, {
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
      specifiedType: const FullType(AdminAnalyticsPoint),
    );
    yield r'end_point';
    yield serializers.serialize(
      object.endPoint,
      specifiedType: const FullType(AdminAnalyticsPoint),
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
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(ListingImage),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  AdminAnalyticsRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($AdminAnalyticsRow)) as $AdminAnalyticsRow;
  }
}


/// a concrete implementation of [AdminAnalyticsRow], since [AdminAnalyticsRow] is not instantiable
@BuiltValue(instantiable: true)
abstract class $AdminAnalyticsRow implements AdminAnalyticsRow, Built<$AdminAnalyticsRow, $AdminAnalyticsRowBuilder> {
  $AdminAnalyticsRow._();

  factory $AdminAnalyticsRow([void Function($AdminAnalyticsRowBuilder)? updates]) = _$$AdminAnalyticsRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($AdminAnalyticsRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$AdminAnalyticsRow> get serializer => _$$AdminAnalyticsRowSerializer();
}

class _$$AdminAnalyticsRowSerializer implements PrimitiveSerializer<$AdminAnalyticsRow> {
  @override
  final Iterable<Type> types = const [$AdminAnalyticsRow, _$$AdminAnalyticsRow];

  @override
  final String wireName = r'$AdminAnalyticsRow';

  @override
  Object serialize(
    Serializers serializers,
    $AdminAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(AdminAnalyticsRow))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAnalyticsRowBuilder result,
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
            specifiedType: const FullType(AdminAnalyticsPoint),
          ) as AdminAnalyticsPoint;
          result.startPoint.replace(valueDes);
          break;
        case r'end_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAnalyticsPoint),
          ) as AdminAnalyticsPoint;
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
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $AdminAnalyticsRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $AdminAnalyticsRowBuilder();
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

