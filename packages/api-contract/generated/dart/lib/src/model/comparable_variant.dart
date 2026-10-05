//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/comparable_specification.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comparable_variant.g.dart';

/// ComparableVariant
///
/// Properties:
/// * [groupId]
/// * [displayName]
/// * [material]
/// * [category]
/// * [specification]
/// * [unit]
@BuiltValue()
abstract class ComparableVariant implements Built<ComparableVariant, ComparableVariantBuilder> {
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

  ComparableVariant._();

  factory ComparableVariant([void updates(ComparableVariantBuilder b)]) = _$ComparableVariant;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComparableVariantBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComparableVariant> get serializer => _$ComparableVariantSerializer();
}

class _$ComparableVariantSerializer implements PrimitiveSerializer<ComparableVariant> {
  @override
  final Iterable<Type> types = const [ComparableVariant, _$ComparableVariant];

  @override
  final String wireName = r'ComparableVariant';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComparableVariant object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ComparableVariant object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComparableVariantBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComparableVariant deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComparableVariantBuilder();
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


