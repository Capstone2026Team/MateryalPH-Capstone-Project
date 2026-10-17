//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_invoice_ref.g.dart';

/// OrderInvoiceRef
///
/// Properties:
/// * [status]
/// * [records]
/// * [openRequests]
@BuiltValue()
abstract class OrderInvoiceRef implements Built<OrderInvoiceRef, OrderInvoiceRefBuilder> {
  @BuiltValueField(wireName: r'status')
  OrderInvoiceRefStatusEnum get status;
  // enum statusEnum {  ISSUED,  NOT_YET_UPLOADED,  NOT_DUE,  };

  @BuiltValueField(wireName: r'records')
  int get records;

  @BuiltValueField(wireName: r'open_requests')
  int get openRequests;

  OrderInvoiceRef._();

  factory OrderInvoiceRef([void updates(OrderInvoiceRefBuilder b)]) = _$OrderInvoiceRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderInvoiceRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderInvoiceRef> get serializer => _$OrderInvoiceRefSerializer();
}

class _$OrderInvoiceRefSerializer implements PrimitiveSerializer<OrderInvoiceRef> {
  @override
  final Iterable<Type> types = const [OrderInvoiceRef, _$OrderInvoiceRef];

  @override
  final String wireName = r'OrderInvoiceRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderInvoiceRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(OrderInvoiceRefStatusEnum),
    );
    yield r'records';
    yield serializers.serialize(
      object.records,
      specifiedType: const FullType(int),
    );
    yield r'open_requests';
    yield serializers.serialize(
      object.openRequests,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderInvoiceRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderInvoiceRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderInvoiceRefStatusEnum),
          ) as OrderInvoiceRefStatusEnum;
          result.status = valueDes;
          break;
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.records = valueDes;
          break;
        case r'open_requests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.openRequests = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderInvoiceRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderInvoiceRefBuilder();
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


class OrderInvoiceRefStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ISSUED')
  static const OrderInvoiceRefStatusEnum ISSUED = _$orderInvoiceRefStatusEnum_ISSUED;
  @BuiltValueEnumConst(wireName: r'NOT_YET_UPLOADED')
  static const OrderInvoiceRefStatusEnum NOT_YET_UPLOADED = _$orderInvoiceRefStatusEnum_NOT_YET_UPLOADED;
  @BuiltValueEnumConst(wireName: r'NOT_DUE')
  static const OrderInvoiceRefStatusEnum NOT_DUE = _$orderInvoiceRefStatusEnum_NOT_DUE;

  static Serializer<OrderInvoiceRefStatusEnum> get serializer => _$orderInvoiceRefStatusEnumSerializer;

  const OrderInvoiceRefStatusEnum._(String name): super(name);

  static BuiltSet<OrderInvoiceRefStatusEnum> get values => _$orderInvoiceRefStatusEnumValues;
  static OrderInvoiceRefStatusEnum valueOf(String name) => _$orderInvoiceRefStatusEnumValueOf(name);
}

