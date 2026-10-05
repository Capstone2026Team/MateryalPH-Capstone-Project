//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/admin_analytics_point.dart';
import 'package:materyalph_api_client/src/model/admin_analytics_row.dart';
import 'package:materyalph_api_client/src/model/comparable_specification.dart';
import 'package:materyalph_api_client/src/model/analytics_current_counts.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/analytics_trend.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_materials_analytics_detail_group.g.dart';

/// AdminMaterialsAnalyticsDetailGroup
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
/// * [description]
@BuiltValue()
abstract class AdminMaterialsAnalyticsDetailGroup implements AdminAnalyticsRow, Built<AdminMaterialsAnalyticsDetailGroup, AdminMaterialsAnalyticsDetailGroupBuilder> {
  @BuiltValueField(wireName: r'description')
  String? get description;

  AdminMaterialsAnalyticsDetailGroup._();

  factory AdminMaterialsAnalyticsDetailGroup([void updates(AdminMaterialsAnalyticsDetailGroupBuilder b)]) = _$AdminMaterialsAnalyticsDetailGroup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMaterialsAnalyticsDetailGroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMaterialsAnalyticsDetailGroup> get serializer => _$AdminMaterialsAnalyticsDetailGroupSerializer();
}

class _$AdminMaterialsAnalyticsDetailGroupSerializer implements PrimitiveSerializer<AdminMaterialsAnalyticsDetailGroup> {
  @override
  final Iterable<Type> types = const [AdminMaterialsAnalyticsDetailGroup, _$AdminMaterialsAnalyticsDetailGroup];

  @override
  final String wireName = r'AdminMaterialsAnalyticsDetailGroup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMaterialsAnalyticsDetailGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'end_point';
    yield serializers.serialize(
      object.endPoint,
      specifiedType: const FullType(AdminAnalyticsPoint),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(AnalyticsUnit),
    );
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(AnalyticsCurrentCounts),
    );
    yield r'material';
    yield serializers.serialize(
      object.material,
      specifiedType: const FullType(AnalyticsMaterialRef),
    );
    yield r'trend';
    yield serializers.serialize(
      object.trend,
      specifiedType: const FullType(AnalyticsTrend),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'group_id';
    yield serializers.serialize(
      object.groupId,
      specifiedType: const FullType(String),
    );
    yield r'start_point';
    yield serializers.serialize(
      object.startPoint,
      specifiedType: const FullType(AdminAnalyticsPoint),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'specification';
    yield serializers.serialize(
      object.specification,
      specifiedType: const FullType(ComparableSpecification),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(AnalyticsCategoryRef),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMaterialsAnalyticsDetailGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminMaterialsAnalyticsDetailGroupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'end_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAnalyticsPoint),
          ) as AdminAnalyticsPoint;
          result.endPoint.replace(valueDes);
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsUnit),
          ) as AnalyticsUnit;
          result.unit.replace(valueDes);
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCurrentCounts),
          ) as AnalyticsCurrentCounts;
          result.current.replace(valueDes);
          break;
        case r'material':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsMaterialRef),
          ) as AnalyticsMaterialRef;
          result.material.replace(valueDes);
          break;
        case r'trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsTrend),
          ) as AnalyticsTrend;
          result.trend.replace(valueDes);
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'group_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.groupId = valueDes;
          break;
        case r'start_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAnalyticsPoint),
          ) as AdminAnalyticsPoint;
          result.startPoint.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'specification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComparableSpecification),
          ) as ComparableSpecification;
          result.specification.replace(valueDes);
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCategoryRef),
          ) as AnalyticsCategoryRef;
          result.category.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMaterialsAnalyticsDetailGroup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMaterialsAnalyticsDetailGroupBuilder();
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


