//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_volume_tier.g.dart';

/// CAT-PRICE-01 immutable volume tier price version. Applies to an order line whose quantity reaches minimum_quantity; the highest reached tier wins.
///
/// Properties:
/// * [priceVersionId]
/// * [version]
/// * [minimumQuantity] - Minimum line quantity in the variant sale unit (four decimals).
/// * [amountCentavos] - VAT-inclusive unit price in centavos.
/// * [includedVatCentavos]
@BuiltValue()
abstract class CatalogVolumeTier implements Built<CatalogVolumeTier, CatalogVolumeTierBuilder> {
  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'version')
  int get version;

  /// Minimum line quantity in the variant sale unit (four decimals).
  @BuiltValueField(wireName: r'minimum_quantity')
  String get minimumQuantity;

  /// VAT-inclusive unit price in centavos.
  @BuiltValueField(wireName: r'amount_centavos')
  int get amountCentavos;

  @BuiltValueField(wireName: r'included_vat_centavos')
  int get includedVatCentavos;

  CatalogVolumeTier._();

  factory CatalogVolumeTier([void updates(CatalogVolumeTierBuilder b)]) = _$CatalogVolumeTier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogVolumeTierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogVolumeTier> get serializer => _$CatalogVolumeTierSerializer();
}

class _$CatalogVolumeTierSerializer implements PrimitiveSerializer<CatalogVolumeTier> {
  @override
  final Iterable<Type> types = const [CatalogVolumeTier, _$CatalogVolumeTier];

  @override
  final String wireName = r'CatalogVolumeTier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogVolumeTier object, {
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
    yield r'minimum_quantity';
    yield serializers.serialize(
      object.minimumQuantity,
      specifiedType: const FullType(String),
    );
    yield r'amount_centavos';
    yield serializers.serialize(
      object.amountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'included_vat_centavos';
    yield serializers.serialize(
      object.includedVatCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogVolumeTier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogVolumeTierBuilder result,
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
        case r'minimum_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.minimumQuantity = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountCentavos = valueDes;
          break;
        case r'included_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.includedVatCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogVolumeTier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogVolumeTierBuilder();
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


