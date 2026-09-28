//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/tax_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_price.g.dart';

/// InventoryPrice
///
/// Properties:
/// * [priceVersionId]
/// * [version]
/// * [amountCentavos]
/// * [taxCategory]
/// * [effectiveAt]
@BuiltValue()
abstract class InventoryPrice implements Built<InventoryPrice, InventoryPriceBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'tax_category')
  TaxCategory get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  @BuiltValueField(wireName: r'effective_at')
  String? get effectiveAt;

  InventoryPrice._();

  factory InventoryPrice([void updates(InventoryPriceBuilder b)]) = _$InventoryPrice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryPriceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryPrice> get serializer => _$InventoryPriceSerializer();
}

class _$InventoryPriceSerializer implements PrimitiveSerializer<InventoryPrice> {
  @override
  final Iterable<Type> types = const [InventoryPrice, _$InventoryPrice];

  @override
  final String wireName = r'InventoryPrice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'price_version_id';
    yield serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(TaxCategory),
    );
    yield r'effective_at';
    yield object.effectiveAt == null ? null : serializers.serialize(
      object.effectiveAt,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryPriceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceVersionId = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TaxCategory),
          ) as TaxCategory;
          result.taxCategory = valueDes;
          break;
        case r'effective_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.effectiveAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryPrice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryPriceBuilder();
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


