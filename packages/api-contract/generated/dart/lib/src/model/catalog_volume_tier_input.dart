//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_volume_tier_input.g.dart';

/// CatalogVolumeTierInput
///
/// Properties:
/// * [minimumQuantity] - Greater than 1 and higher than the previous tier.
/// * [priceCentavos] - VAT-inclusive unit price, lower than the ordinary price and the previous tier.
@BuiltValue()
abstract class CatalogVolumeTierInput implements Built<CatalogVolumeTierInput, CatalogVolumeTierInputBuilder> {
  /// Greater than 1 and higher than the previous tier.
  @BuiltValueField(wireName: r'minimum_quantity')
  String get minimumQuantity;

  /// VAT-inclusive unit price, lower than the ordinary price and the previous tier.
  @BuiltValueField(wireName: r'price_centavos')
  int get priceCentavos;

  CatalogVolumeTierInput._();

  factory CatalogVolumeTierInput([void updates(CatalogVolumeTierInputBuilder b)]) = _$CatalogVolumeTierInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogVolumeTierInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogVolumeTierInput> get serializer => _$CatalogVolumeTierInputSerializer();
}

class _$CatalogVolumeTierInputSerializer implements PrimitiveSerializer<CatalogVolumeTierInput> {
  @override
  final Iterable<Type> types = const [CatalogVolumeTierInput, _$CatalogVolumeTierInput];

  @override
  final String wireName = r'CatalogVolumeTierInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogVolumeTierInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minimum_quantity';
    yield serializers.serialize(
      object.minimumQuantity,
      specifiedType: const FullType(String),
    );
    yield r'price_centavos';
    yield serializers.serialize(
      object.priceCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogVolumeTierInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogVolumeTierInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minimum_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.minimumQuantity = valueDes;
          break;
        case r'price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogVolumeTierInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogVolumeTierInputBuilder();
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


