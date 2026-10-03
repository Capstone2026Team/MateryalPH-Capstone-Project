//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_line.g.dart';

/// ChatQuotationLine
///
/// Properties:
/// * [variantId]
/// * [quantity]
/// * [unitPriceCentavos]
/// * [description]
/// * [unitCode]
/// * [taxCategory]
/// * [sourcePriceVersionId]
/// * [sourceTaxVersionId]
@BuiltValue()
abstract class ChatQuotationLine implements Built<ChatQuotationLine, ChatQuotationLineBuilder> {
  @BuiltValueField(wireName: r'variant_id')
  String get variantId;

  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'unit_price_centavos')
  int get unitPriceCentavos;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'unit_code')
  String get unitCode;

  @BuiltValueField(wireName: r'tax_category')
  String get taxCategory;

  @BuiltValueField(wireName: r'source_price_version_id')
  String get sourcePriceVersionId;

  @BuiltValueField(wireName: r'source_tax_version_id')
  String get sourceTaxVersionId;

  ChatQuotationLine._();

  factory ChatQuotationLine([void updates(ChatQuotationLineBuilder b)]) = _$ChatQuotationLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationLine> get serializer => _$ChatQuotationLineSerializer();
}

class _$ChatQuotationLineSerializer implements PrimitiveSerializer<ChatQuotationLine> {
  @override
  final Iterable<Type> types = const [ChatQuotationLine, _$ChatQuotationLine];

  @override
  final String wireName = r'ChatQuotationLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'variant_id';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    yield r'unit_price_centavos';
    yield serializers.serialize(
      object.unitPriceCentavos,
      specifiedType: const FullType(int),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield serializers.serialize(
      object.unitCode,
      specifiedType: const FullType(String),
    );
    yield r'tax_category';
    yield serializers.serialize(
      object.taxCategory,
      specifiedType: const FullType(String),
    );
    yield r'source_price_version_id';
    yield serializers.serialize(
      object.sourcePriceVersionId,
      specifiedType: const FullType(String),
    );
    yield r'source_tax_version_id';
    yield serializers.serialize(
      object.sourceTaxVersionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationLineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'unit_price_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unitPriceCentavos = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitCode = valueDes;
          break;
        case r'tax_category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.taxCategory = valueDes;
          break;
        case r'source_price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourcePriceVersionId = valueDes;
          break;
        case r'source_tax_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceTaxVersionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationLineBuilder();
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


