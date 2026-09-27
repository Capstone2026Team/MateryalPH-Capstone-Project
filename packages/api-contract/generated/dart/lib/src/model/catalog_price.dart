//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/tax_category.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_price.g.dart';

/// Immutable ordinary public price version, VAT-inclusive payable amount in centavos.
///
/// Properties:
/// * [priceVersionId]
/// * [version]
/// * [amountCentavos]
/// * [taxCategory]
/// * [taxBasis]
/// * [includedVatCentavos]
/// * [effectiveAt]
@BuiltValue()
abstract class CatalogPrice implements Built<CatalogPrice, CatalogPriceBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'tax_category')
  TaxCategory get taxCategory;
  // enum taxCategoryEnum {  VAT_12,  VAT_ZERO,  VAT_EXEMPT,  NON_VAT,  };

  @BuiltValueField(wireName: r'tax_basis')
  String? get taxBasis;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  @BuiltValueField(wireName: r'effective_at')
  String? get effectiveAt;

  CatalogPrice._();

  factory CatalogPrice([void updates(CatalogPriceBuilder b)]) = _$CatalogPrice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogPriceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogPrice> get serializer => _$CatalogPriceSerializer();
}

class _$CatalogPriceSerializer implements PrimitiveSerializer<CatalogPrice> {
  @override
  final Iterable<Type> types = const [CatalogPrice, _$CatalogPrice];

  @override
  final String wireName = r'CatalogPrice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogPrice object, {
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
    if (object.taxBasis != null) {
      yield r'tax_basis';
      yield serializers.serialize(
        object.taxBasis,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
    if (object.effectiveAt != null) {
      yield r'effective_at';
      yield serializers.serialize(
        object.effectiveAt,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogPriceBuilder result,
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
        case r'tax_basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.taxBasis = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
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
  CatalogPrice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogPriceBuilder();
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


