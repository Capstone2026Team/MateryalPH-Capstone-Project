//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_deadlines.g.dart';

/// OrderDeadlines
///
/// Properties:
/// * [vendorResponseDueAt]
/// * [buyerResponseDueAt]
/// * [paymentExpiresAt] - 24 hours after the order entered AWAITING_PAYMENT (Pending Payment). The server clock decides; clients only display it.
/// * [serverTime]
/// * [timezone]
@BuiltValue()
abstract class OrderDeadlines implements Built<OrderDeadlines, OrderDeadlinesBuilder> {
  @BuiltValueField(wireName: r'vendor_response_due_at')
  DateTime? get vendorResponseDueAt;

  @BuiltValueField(wireName: r'buyer_response_due_at')
  DateTime? get buyerResponseDueAt;

  /// 24 hours after the order entered AWAITING_PAYMENT (Pending Payment). The server clock decides; clients only display it.
  @BuiltValueField(wireName: r'payment_expires_at')
  DateTime? get paymentExpiresAt;

  @BuiltValueField(wireName: r'server_time')
  DateTime get serverTime;

  @BuiltValueField(wireName: r'timezone')
  OrderDeadlinesTimezoneEnum get timezone;
  // enum timezoneEnum {  Asia/Manila,  };

  OrderDeadlines._();

  factory OrderDeadlines([void updates(OrderDeadlinesBuilder b)]) = _$OrderDeadlines;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderDeadlinesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderDeadlines> get serializer => _$OrderDeadlinesSerializer();
}

class _$OrderDeadlinesSerializer implements PrimitiveSerializer<OrderDeadlines> {
  @override
  final Iterable<Type> types = const [OrderDeadlines, _$OrderDeadlines];

  @override
  final String wireName = r'OrderDeadlines';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderDeadlines object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_response_due_at';
    yield object.vendorResponseDueAt == null ? null : serializers.serialize(
      object.vendorResponseDueAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'buyer_response_due_at';
    yield object.buyerResponseDueAt == null ? null : serializers.serialize(
      object.buyerResponseDueAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'payment_expires_at';
    yield object.paymentExpiresAt == null ? null : serializers.serialize(
      object.paymentExpiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'server_time';
    yield serializers.serialize(
      object.serverTime,
      specifiedType: const FullType(DateTime),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(OrderDeadlinesTimezoneEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderDeadlines object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderDeadlinesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.vendorResponseDueAt = valueDes;
          break;
        case r'buyer_response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.buyerResponseDueAt = valueDes;
          break;
        case r'payment_expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.paymentExpiresAt = valueDes;
          break;
        case r'server_time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.serverTime = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderDeadlinesTimezoneEnum),
          ) as OrderDeadlinesTimezoneEnum;
          result.timezone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderDeadlines deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderDeadlinesBuilder();
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


class OrderDeadlinesTimezoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Asia/Manila')
  static const OrderDeadlinesTimezoneEnum asiaSlashManila = _$orderDeadlinesTimezoneEnum_asiaSlashManila;

  static Serializer<OrderDeadlinesTimezoneEnum> get serializer => _$orderDeadlinesTimezoneEnumSerializer;

  const OrderDeadlinesTimezoneEnum._(String name): super(name);

  static BuiltSet<OrderDeadlinesTimezoneEnum> get values => _$orderDeadlinesTimezoneEnumValues;
  static OrderDeadlinesTimezoneEnum valueOf(String name) => _$orderDeadlinesTimezoneEnumValueOf(name);
}

