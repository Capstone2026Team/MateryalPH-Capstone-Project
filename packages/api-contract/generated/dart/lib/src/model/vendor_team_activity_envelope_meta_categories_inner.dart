//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_activity_envelope_meta_categories_inner.g.dart';

/// VendorTeamActivityEnvelopeMetaCategoriesInner
///
/// Properties:
/// * [category]
/// * [count]
@BuiltValue()
abstract class VendorTeamActivityEnvelopeMetaCategoriesInner implements Built<VendorTeamActivityEnvelopeMetaCategoriesInner, VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder> {
  @BuiltValueField(wireName: r'category')
  VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum get category;
  // enum categoryEnum {  SALES,  INVENTORY,  FULFILLMENT,  DISPUTES,  TEAM,  OTHER,  };

  @BuiltValueField(wireName: r'count')
  int get count;

  VendorTeamActivityEnvelopeMetaCategoriesInner._();

  factory VendorTeamActivityEnvelopeMetaCategoriesInner([void updates(VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder b)]) = _$VendorTeamActivityEnvelopeMetaCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamActivityEnvelopeMetaCategoriesInner> get serializer => _$VendorTeamActivityEnvelopeMetaCategoriesInnerSerializer();
}

class _$VendorTeamActivityEnvelopeMetaCategoriesInnerSerializer implements PrimitiveSerializer<VendorTeamActivityEnvelopeMetaCategoriesInner> {
  @override
  final Iterable<Type> types = const [VendorTeamActivityEnvelopeMetaCategoriesInner, _$VendorTeamActivityEnvelopeMetaCategoriesInner];

  @override
  final String wireName = r'VendorTeamActivityEnvelopeMetaCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamActivityEnvelopeMetaCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamActivityEnvelopeMetaCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum),
          ) as VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum;
          result.category = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamActivityEnvelopeMetaCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamActivityEnvelopeMetaCategoriesInnerBuilder();
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


class VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SALES')
  static const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum SALES = _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_SALES;
  @BuiltValueEnumConst(wireName: r'INVENTORY')
  static const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum INVENTORY = _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_INVENTORY;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum FULFILLMENT = _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'DISPUTES')
  static const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum DISPUTES = _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_DISPUTES;
  @BuiltValueEnumConst(wireName: r'TEAM')
  static const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum TEAM = _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_TEAM;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum OTHER = _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum_OTHER;

  static Serializer<VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum> get serializer => _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumSerializer;

  const VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum._(String name): super(name);

  static BuiltSet<VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum> get values => _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumValues;
  static VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum valueOf(String name) => _$vendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnumValueOf(name);
}

