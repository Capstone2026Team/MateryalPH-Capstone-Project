//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_quotation_change.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/chat_quotation_money.dart';
import 'package:materyalph_api_client/src/model/chat_quotation_line.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_content.g.dart';

/// ChatQuotationContent
///
/// Properties:
/// * [lines]
/// * [commercial]
/// * [fulfillmentMethod]
/// * [paymentMethod]
/// * [fulfillmentDate]
/// * [delivery]
/// * [nrpc]
/// * [changes]
/// * [originalChanges]
/// * [priceSource]
/// * [processingFeeStatus]
@BuiltValue()
abstract class ChatQuotationContent implements Built<ChatQuotationContent, ChatQuotationContentBuilder> {
  @BuiltValueField(wireName: r'lines')
  BuiltList<ChatQuotationLine> get lines;

  @BuiltValueField(wireName: r'commercial')
  ChatQuotationMoney get commercial;

  @BuiltValueField(wireName: r'fulfillment_method')
  String get fulfillmentMethod;

  @BuiltValueField(wireName: r'payment_method')
  String get paymentMethod;

  @BuiltValueField(wireName: r'fulfillment_date')
  String get fulfillmentDate;

  @BuiltValueField(wireName: r'delivery')
  BuiltMap<String, JsonObject?>? get delivery;

  @BuiltValueField(wireName: r'nrpc')
  BuiltMap<String, JsonObject?>? get nrpc;

  @BuiltValueField(wireName: r'changes')
  BuiltList<ChatQuotationChange> get changes;

  @BuiltValueField(wireName: r'original_changes')
  BuiltList<ChatQuotationChange> get originalChanges;

  @BuiltValueField(wireName: r'price_source')
  ChatQuotationContentPriceSourceEnum get priceSource;
  // enum priceSourceEnum {  PRIVATE_TRANSACTION,  };

  @BuiltValueField(wireName: r'processing_fee_status')
  String get processingFeeStatus;

  ChatQuotationContent._();

  factory ChatQuotationContent([void updates(ChatQuotationContentBuilder b)]) = _$ChatQuotationContent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationContentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationContent> get serializer => _$ChatQuotationContentSerializer();
}

class _$ChatQuotationContentSerializer implements PrimitiveSerializer<ChatQuotationContent> {
  @override
  final Iterable<Type> types = const [ChatQuotationContent, _$ChatQuotationContent];

  @override
  final String wireName = r'ChatQuotationContent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationContent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(ChatQuotationLine)]),
    );
    yield r'commercial';
    yield serializers.serialize(
      object.commercial,
      specifiedType: const FullType(ChatQuotationMoney),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(String),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(String),
    );
    yield r'fulfillment_date';
    yield serializers.serialize(
      object.fulfillmentDate,
      specifiedType: const FullType(String),
    );
    if (object.delivery != null) {
      yield r'delivery';
      yield serializers.serialize(
        object.delivery,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.nrpc != null) {
      yield r'nrpc';
      yield serializers.serialize(
        object.nrpc,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [FullType(ChatQuotationChange)]),
    );
    yield r'original_changes';
    yield serializers.serialize(
      object.originalChanges,
      specifiedType: const FullType(BuiltList, [FullType(ChatQuotationChange)]),
    );
    yield r'price_source';
    yield serializers.serialize(
      object.priceSource,
      specifiedType: const FullType(ChatQuotationContentPriceSourceEnum),
    );
    yield r'processing_fee_status';
    yield serializers.serialize(
      object.processingFeeStatus,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationContent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationContentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatQuotationLine)]),
          ) as BuiltList<ChatQuotationLine>;
          result.lines.replace(valueDes);
          break;
        case r'commercial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatQuotationMoney),
          ) as ChatQuotationMoney;
          result.commercial.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentMethod = valueDes;
          break;
        case r'fulfillment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fulfillmentDate = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.delivery.replace(valueDes);
          break;
        case r'nrpc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.nrpc.replace(valueDes);
          break;
        case r'changes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatQuotationChange)]),
          ) as BuiltList<ChatQuotationChange>;
          result.changes.replace(valueDes);
          break;
        case r'original_changes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatQuotationChange)]),
          ) as BuiltList<ChatQuotationChange>;
          result.originalChanges.replace(valueDes);
          break;
        case r'price_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatQuotationContentPriceSourceEnum),
          ) as ChatQuotationContentPriceSourceEnum;
          result.priceSource = valueDes;
          break;
        case r'processing_fee_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.processingFeeStatus = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationContent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationContentBuilder();
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


class ChatQuotationContentPriceSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRIVATE_TRANSACTION')
  static const ChatQuotationContentPriceSourceEnum PRIVATE_TRANSACTION = _$chatQuotationContentPriceSourceEnum_PRIVATE_TRANSACTION;

  static Serializer<ChatQuotationContentPriceSourceEnum> get serializer => _$chatQuotationContentPriceSourceEnumSerializer;

  const ChatQuotationContentPriceSourceEnum._(String name): super(name);

  static BuiltSet<ChatQuotationContentPriceSourceEnum> get values => _$chatQuotationContentPriceSourceEnumValues;
  static ChatQuotationContentPriceSourceEnum valueOf(String name) => _$chatQuotationContentPriceSourceEnumValueOf(name);
}

