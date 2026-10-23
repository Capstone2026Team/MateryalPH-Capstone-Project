//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/vendor_own_offer.dart';
import 'package:materyalph_api_client/src/model/vendor_analytics_row.dart';
import 'package:materyalph_api_client/src/model/comparable_specification.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/vendor_analytics_point.dart';
import 'package:materyalph_api_client/src/model/analytics_trend.dart';
import 'package:materyalph_api_client/src/model/vendor_current_competitors.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_materials_analytics_detail_group.g.dart';

/// VendorMaterialsAnalyticsDetailGroup
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
/// * [currentCompetitors]
/// * [ownOffer]
/// * [image] - The Vendor's own listing photo for this variant, or null. A competitor photo is never returned (MAT-05).
/// * [description]
@BuiltValue()
abstract class VendorMaterialsAnalyticsDetailGroup implements VendorAnalyticsRow, Built<VendorMaterialsAnalyticsDetailGroup, VendorMaterialsAnalyticsDetailGroupBuilder> {
  @BuiltValueField(wireName: r'description')
  String? get description;

  VendorMaterialsAnalyticsDetailGroup._();

  factory VendorMaterialsAnalyticsDetailGroup([void updates(VendorMaterialsAnalyticsDetailGroupBuilder b)]) = _$VendorMaterialsAnalyticsDetailGroup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorMaterialsAnalyticsDetailGroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorMaterialsAnalyticsDetailGroup> get serializer => _$VendorMaterialsAnalyticsDetailGroupSerializer();
}

class _$VendorMaterialsAnalyticsDetailGroupSerializer implements PrimitiveSerializer<VendorMaterialsAnalyticsDetailGroup> {
  @override
  final Iterable<Type> types = const [VendorMaterialsAnalyticsDetailGroup, _$VendorMaterialsAnalyticsDetailGroup];

  @override
  final String wireName = r'VendorMaterialsAnalyticsDetailGroup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorMaterialsAnalyticsDetailGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(ListingImage),
      );
    }
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
      specifiedType: const FullType(VendorAnalyticsPoint),
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
    yield r'current_competitors';
    yield serializers.serialize(
      object.currentCompetitors,
      specifiedType: const FullType(VendorCurrentCompetitors),
    );
    if (object.ownOffer != null) {
      yield r'own_offer';
      yield serializers.serialize(
        object.ownOffer,
        specifiedType: const FullType.nullable(VendorOwnOffer),
      );
    }
    yield r'end_point';
    yield serializers.serialize(
      object.endPoint,
      specifiedType: const FullType(VendorAnalyticsPoint),
    );
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(AnalyticsUnit),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorMaterialsAnalyticsDetailGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorMaterialsAnalyticsDetailGroupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
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
            specifiedType: const FullType(VendorAnalyticsPoint),
          ) as VendorAnalyticsPoint;
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
        case r'current_competitors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorCurrentCompetitors),
          ) as VendorCurrentCompetitors;
          result.currentCompetitors.replace(valueDes);
          break;
        case r'own_offer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorOwnOffer),
          ) as VendorOwnOffer?;
          if (valueDes == null) continue;
          result.ownOffer.replace(valueDes);
          break;
        case r'end_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAnalyticsPoint),
          ) as VendorAnalyticsPoint;
          result.endPoint.replace(valueDes);
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsUnit),
          ) as AnalyticsUnit;
          result.unit.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorMaterialsAnalyticsDetailGroup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorMaterialsAnalyticsDetailGroupBuilder();
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


