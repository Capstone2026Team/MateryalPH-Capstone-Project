//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/vendor_own_offer.dart';
import 'package:materyalph_api_client/src/model/comparable_specification.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/vendor_analytics_point.dart';
import 'package:materyalph_api_client/src/model/analytics_trend.dart';
import 'package:materyalph_api_client/src/model/vendor_current_competitors.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_analytics_row.g.dart';

/// VendorAnalyticsRow
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
@BuiltValue(instantiable: false)
abstract class VendorAnalyticsRow  {
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
  VendorAnalyticsPoint get startPoint;

  @BuiltValueField(wireName: r'end_point')
  VendorAnalyticsPoint get endPoint;

  @BuiltValueField(wireName: r'trend')
  AnalyticsTrend get trend;

  @BuiltValueField(wireName: r'current_competitors')
  VendorCurrentCompetitors get currentCompetitors;

  @BuiltValueField(wireName: r'own_offer')
  VendorOwnOffer? get ownOffer;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAnalyticsRow> get serializer => _$VendorAnalyticsRowSerializer();
}

class _$VendorAnalyticsRowSerializer implements PrimitiveSerializer<VendorAnalyticsRow> {
  @override
  final Iterable<Type> types = const [VendorAnalyticsRow];

  @override
  final String wireName = r'VendorAnalyticsRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAnalyticsRow object, {
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
      specifiedType: const FullType(VendorAnalyticsPoint),
    );
    yield r'end_point';
    yield serializers.serialize(
      object.endPoint,
      specifiedType: const FullType(VendorAnalyticsPoint),
    );
    yield r'trend';
    yield serializers.serialize(
      object.trend,
      specifiedType: const FullType(AnalyticsTrend),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  VendorAnalyticsRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($VendorAnalyticsRow)) as $VendorAnalyticsRow;
  }
}


/// a concrete implementation of [VendorAnalyticsRow], since [VendorAnalyticsRow] is not instantiable
@BuiltValue(instantiable: true)
abstract class $VendorAnalyticsRow implements VendorAnalyticsRow, Built<$VendorAnalyticsRow, $VendorAnalyticsRowBuilder> {
  $VendorAnalyticsRow._();

  factory $VendorAnalyticsRow([void Function($VendorAnalyticsRowBuilder)? updates]) = _$$VendorAnalyticsRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($VendorAnalyticsRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$VendorAnalyticsRow> get serializer => _$$VendorAnalyticsRowSerializer();
}

class _$$VendorAnalyticsRowSerializer implements PrimitiveSerializer<$VendorAnalyticsRow> {
  @override
  final Iterable<Type> types = const [$VendorAnalyticsRow, _$$VendorAnalyticsRow];

  @override
  final String wireName = r'$VendorAnalyticsRow';

  @override
  Object serialize(
    Serializers serializers,
    $VendorAnalyticsRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(VendorAnalyticsRow))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAnalyticsRowBuilder result,
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
            specifiedType: const FullType(VendorAnalyticsPoint),
          ) as VendorAnalyticsPoint;
          result.startPoint.replace(valueDes);
          break;
        case r'end_point':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAnalyticsPoint),
          ) as VendorAnalyticsPoint;
          result.endPoint.replace(valueDes);
          break;
        case r'trend':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsTrend),
          ) as AnalyticsTrend;
          result.trend.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $VendorAnalyticsRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $VendorAnalyticsRowBuilder();
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

