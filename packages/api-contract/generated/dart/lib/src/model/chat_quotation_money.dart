//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_money.g.dart';

/// ChatQuotationMoney
///
/// Properties:
/// * [materialsPayableCentavos]
/// * [materialsVatCentavos]
/// * [vendorDiscountCentavos]
/// * [deliveryCentavos]
/// * [nrpcCentavos]
/// * [commercialTotalCentavos]
@BuiltValue()
abstract class ChatQuotationMoney implements Built<ChatQuotationMoney, ChatQuotationMoneyBuilder> {
  @BuiltValueField(wireName: r'materials_payable_centavos')
  int get materialsPayableCentavos;

  @BuiltValueField(wireName: r'materials_vat_centavos')
  int get materialsVatCentavos;

  @BuiltValueField(wireName: r'vendor_discount_centavos')
  int get vendorDiscountCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int get deliveryCentavos;

  @BuiltValueField(wireName: r'nrpc_centavos')
  int get nrpcCentavos;

  @BuiltValueField(wireName: r'commercial_total_centavos')
  int get commercialTotalCentavos;

  ChatQuotationMoney._();

  factory ChatQuotationMoney([void updates(ChatQuotationMoneyBuilder b)]) = _$ChatQuotationMoney;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationMoneyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationMoney> get serializer => _$ChatQuotationMoneySerializer();
}

class _$ChatQuotationMoneySerializer implements PrimitiveSerializer<ChatQuotationMoney> {
  @override
  final Iterable<Type> types = const [ChatQuotationMoney, _$ChatQuotationMoney];

  @override
  final String wireName = r'ChatQuotationMoney';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationMoney object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'materials_payable_centavos';
    yield serializers.serialize(
      object.materialsPayableCentavos,
      specifiedType: const FullType(int),
    );
    yield r'materials_vat_centavos';
    yield serializers.serialize(
      object.materialsVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vendor_discount_centavos';
    yield serializers.serialize(
      object.vendorDiscountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType(int),
    );
    yield r'nrpc_centavos';
    yield serializers.serialize(
      object.nrpcCentavos,
      specifiedType: const FullType(int),
    );
    yield r'commercial_total_centavos';
    yield serializers.serialize(
      object.commercialTotalCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationMoney object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationMoneyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'materials_payable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsPayableCentavos = valueDes;
          break;
        case r'materials_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsVatCentavos = valueDes;
          break;
        case r'vendor_discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorDiscountCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deliveryCentavos = valueDes;
          break;
        case r'nrpc_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nrpcCentavos = valueDes;
          break;
        case r'commercial_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commercialTotalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationMoney deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationMoneyBuilder();
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


