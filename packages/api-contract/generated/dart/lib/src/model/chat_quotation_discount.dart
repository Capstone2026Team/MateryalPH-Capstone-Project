//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_discount.g.dart';

/// ChatQuotationDiscount
///
/// Properties:
/// * [scope] - Delivery discounts require Site Delivery.
/// * [percent] - Percentage from 0 to 100, with up to two decimal places. Rounded half-up to centavos. Materials must retain a positive payable subtotal.
@BuiltValue()
abstract class ChatQuotationDiscount implements Built<ChatQuotationDiscount, ChatQuotationDiscountBuilder> {
  /// Delivery discounts require Site Delivery.
  @BuiltValueField(wireName: r'scope')
  ChatQuotationDiscountScopeEnum get scope;
  // enum scopeEnum {  MATERIALS,  DELIVERY,  };

  /// Percentage from 0 to 100, with up to two decimal places. Rounded half-up to centavos. Materials must retain a positive payable subtotal.
  @BuiltValueField(wireName: r'percent')
  String get percent;

  ChatQuotationDiscount._();

  factory ChatQuotationDiscount([void updates(ChatQuotationDiscountBuilder b)]) = _$ChatQuotationDiscount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationDiscountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationDiscount> get serializer => _$ChatQuotationDiscountSerializer();
}

class _$ChatQuotationDiscountSerializer implements PrimitiveSerializer<ChatQuotationDiscount> {
  @override
  final Iterable<Type> types = const [ChatQuotationDiscount, _$ChatQuotationDiscount];

  @override
  final String wireName = r'ChatQuotationDiscount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationDiscount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(ChatQuotationDiscountScopeEnum),
    );
    yield r'percent';
    yield serializers.serialize(
      object.percent,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationDiscount object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationDiscountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatQuotationDiscountScopeEnum),
          ) as ChatQuotationDiscountScopeEnum;
          result.scope = valueDes;
          break;
        case r'percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.percent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationDiscount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationDiscountBuilder();
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


/// Delivery discounts require Site Delivery.
class ChatQuotationDiscountScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MATERIALS')
  static const ChatQuotationDiscountScopeEnum MATERIALS = _$chatQuotationDiscountScopeEnum_MATERIALS;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ChatQuotationDiscountScopeEnum DELIVERY = _$chatQuotationDiscountScopeEnum_DELIVERY;

  static Serializer<ChatQuotationDiscountScopeEnum> get serializer => _$chatQuotationDiscountScopeEnumSerializer;

  const ChatQuotationDiscountScopeEnum._(String name): super(name);

  static BuiltSet<ChatQuotationDiscountScopeEnum> get values => _$chatQuotationDiscountScopeEnumValues;
  static ChatQuotationDiscountScopeEnum valueOf(String name) => _$chatQuotationDiscountScopeEnumValueOf(name);
}

