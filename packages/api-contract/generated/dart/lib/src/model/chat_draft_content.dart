//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/chat_draft_line.dart';
import 'package:materyalph_api_client/src/model/chat_quotation_discount.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_draft_content.g.dart';

/// ChatDraftContent
///
/// Properties:
/// * [lines]
/// * [fulfillmentMethod]
/// * [paymentMethod] - Legacy editor preference, ignored. The Buyer selects payment before accepting the quotation.
/// * [fulfillmentDate]
/// * [deadlineHours]
/// * [vendorDiscountCentavos] - Legacy fixed materials discount. Omit when discount is supplied.
/// * [discount]
/// * [delivery]
/// * [nrpc]
@BuiltValue()
abstract class ChatDraftContent implements Built<ChatDraftContent, ChatDraftContentBuilder> {
  @BuiltValueField(wireName: r'lines')
  BuiltList<ChatDraftLine> get lines;

  @BuiltValueField(wireName: r'fulfillment_method')
  ChatDraftContentFulfillmentMethodEnum get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  PICKUP,  DELIVERY,  };

  /// Legacy editor preference, ignored. The Buyer selects payment before accepting the quotation.
  @Deprecated('paymentMethod has been deprecated')
  @BuiltValueField(wireName: r'payment_method')
  ChatDraftContentPaymentMethodEnum? get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  @BuiltValueField(wireName: r'fulfillment_date')
  String get fulfillmentDate;

  @BuiltValueField(wireName: r'deadline_hours')
  int? get deadlineHours;

  /// Legacy fixed materials discount. Omit when discount is supplied.
  @Deprecated('vendorDiscountCentavos has been deprecated')
  @BuiltValueField(wireName: r'vendor_discount_centavos')
  int? get vendorDiscountCentavos;

  @BuiltValueField(wireName: r'discount')
  ChatQuotationDiscount? get discount;

  @BuiltValueField(wireName: r'delivery')
  BuiltMap<String, JsonObject?>? get delivery;

  @BuiltValueField(wireName: r'nrpc')
  BuiltMap<String, JsonObject?>? get nrpc;

  ChatDraftContent._();

  factory ChatDraftContent([void updates(ChatDraftContentBuilder b)]) = _$ChatDraftContent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatDraftContentBuilder b) => b
      ..deadlineHours = 24;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatDraftContent> get serializer => _$ChatDraftContentSerializer();
}

class _$ChatDraftContentSerializer implements PrimitiveSerializer<ChatDraftContent> {
  @override
  final Iterable<Type> types = const [ChatDraftContent, _$ChatDraftContent];

  @override
  final String wireName = r'ChatDraftContent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatDraftContent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(ChatDraftLine)]),
    );
    yield r'fulfillment_method';
    yield serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType(ChatDraftContentFulfillmentMethodEnum),
    );
    if (object.paymentMethod != null) {
      yield r'payment_method';
      yield serializers.serialize(
        object.paymentMethod,
        specifiedType: const FullType(ChatDraftContentPaymentMethodEnum),
      );
    }
    yield r'fulfillment_date';
    yield serializers.serialize(
      object.fulfillmentDate,
      specifiedType: const FullType(String),
    );
    if (object.deadlineHours != null) {
      yield r'deadline_hours';
      yield serializers.serialize(
        object.deadlineHours,
        specifiedType: const FullType(int),
      );
    }
    if (object.vendorDiscountCentavos != null) {
      yield r'vendor_discount_centavos';
      yield serializers.serialize(
        object.vendorDiscountCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.discount != null) {
      yield r'discount';
      yield serializers.serialize(
        object.discount,
        specifiedType: const FullType(ChatQuotationDiscount),
      );
    }
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatDraftContent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatDraftContentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatDraftLine)]),
          ) as BuiltList<ChatDraftLine>;
          result.lines.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatDraftContentFulfillmentMethodEnum),
          ) as ChatDraftContentFulfillmentMethodEnum;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChatDraftContentPaymentMethodEnum),
          ) as ChatDraftContentPaymentMethodEnum?;
          if (valueDes == null) continue;
          result.paymentMethod = valueDes;
          break;
        case r'fulfillment_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fulfillmentDate = valueDes;
          break;
        case r'deadline_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deadlineHours = valueDes;
          break;
        case r'vendor_discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorDiscountCentavos = valueDes;
          break;
        case r'discount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChatQuotationDiscount),
          ) as ChatQuotationDiscount?;
          if (valueDes == null) continue;
          result.discount.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatDraftContent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatDraftContentBuilder();
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


class ChatDraftContentFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ChatDraftContentFulfillmentMethodEnum PICKUP = _$chatDraftContentFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ChatDraftContentFulfillmentMethodEnum DELIVERY = _$chatDraftContentFulfillmentMethodEnum_DELIVERY;

  static Serializer<ChatDraftContentFulfillmentMethodEnum> get serializer => _$chatDraftContentFulfillmentMethodEnumSerializer;

  const ChatDraftContentFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<ChatDraftContentFulfillmentMethodEnum> get values => _$chatDraftContentFulfillmentMethodEnumValues;
  static ChatDraftContentFulfillmentMethodEnum valueOf(String name) => _$chatDraftContentFulfillmentMethodEnumValueOf(name);
}

/// Legacy editor preference, ignored. The Buyer selects payment before accepting the quotation.
class ChatDraftContentPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const ChatDraftContentPaymentMethodEnum ONLINE = _$chatDraftContentPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const ChatDraftContentPaymentMethodEnum CASH_ON_DELIVERY = _$chatDraftContentPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const ChatDraftContentPaymentMethodEnum IN_STORE = _$chatDraftContentPaymentMethodEnum_IN_STORE;

  static Serializer<ChatDraftContentPaymentMethodEnum> get serializer => _$chatDraftContentPaymentMethodEnumSerializer;

  const ChatDraftContentPaymentMethodEnum._(String name): super(name);

  static BuiltSet<ChatDraftContentPaymentMethodEnum> get values => _$chatDraftContentPaymentMethodEnumValues;
  static ChatDraftContentPaymentMethodEnum valueOf(String name) => _$chatDraftContentPaymentMethodEnumValueOf(name);
}

