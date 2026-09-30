//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_timeline_event.g.dart';

/// OrderTimelineEvent
///
/// Properties:
/// * [family]
/// * [fromState]
/// * [toState]
/// * [source_]
/// * [actorRole]
/// * [reasonCode]
/// * [snapshotVersion]
/// * [at]
@BuiltValue()
abstract class OrderTimelineEvent implements Built<OrderTimelineEvent, OrderTimelineEventBuilder> {
  @BuiltValueField(wireName: r'family')
  OrderTimelineEventFamilyEnum get family;
  // enum familyEnum {  ORDER,  PAYMENT,  FULFILLMENT,  REFUND,  DISPUTE,  };

  @BuiltValueField(wireName: r'from_state')
  String? get fromState;

  @BuiltValueField(wireName: r'to_state')
  String get toState;

  @BuiltValueField(wireName: r'source')
  OrderTimelineEventSource_Enum get source_;
  // enum source_Enum {  BUYER,  VENDOR,  SYSTEM,  AUTO_ACCEPT,  };

  @BuiltValueField(wireName: r'actor_role')
  String? get actorRole;

  @BuiltValueField(wireName: r'reason_code')
  String? get reasonCode;

  @BuiltValueField(wireName: r'snapshot_version')
  int? get snapshotVersion;

  @BuiltValueField(wireName: r'at')
  DateTime? get at;

  OrderTimelineEvent._();

  factory OrderTimelineEvent([void updates(OrderTimelineEventBuilder b)]) = _$OrderTimelineEvent;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderTimelineEventBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderTimelineEvent> get serializer => _$OrderTimelineEventSerializer();
}

class _$OrderTimelineEventSerializer implements PrimitiveSerializer<OrderTimelineEvent> {
  @override
  final Iterable<Type> types = const [OrderTimelineEvent, _$OrderTimelineEvent];

  @override
  final String wireName = r'OrderTimelineEvent';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderTimelineEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'family';
    yield serializers.serialize(
      object.family,
      specifiedType: const FullType(OrderTimelineEventFamilyEnum),
    );
    yield r'from_state';
    yield object.fromState == null ? null : serializers.serialize(
      object.fromState,
      specifiedType: const FullType.nullable(String),
    );
    yield r'to_state';
    yield serializers.serialize(
      object.toState,
      specifiedType: const FullType(String),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(OrderTimelineEventSource_Enum),
    );
    yield r'actor_role';
    yield object.actorRole == null ? null : serializers.serialize(
      object.actorRole,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reason_code';
    yield object.reasonCode == null ? null : serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'snapshot_version';
    yield object.snapshotVersion == null ? null : serializers.serialize(
      object.snapshotVersion,
      specifiedType: const FullType.nullable(int),
    );
    yield r'at';
    yield object.at == null ? null : serializers.serialize(
      object.at,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderTimelineEvent object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderTimelineEventBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'family':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderTimelineEventFamilyEnum),
          ) as OrderTimelineEventFamilyEnum;
          result.family = valueDes;
          break;
        case r'from_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fromState = valueDes;
          break;
        case r'to_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.toState = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(OrderTimelineEventSource_Enum),
          ) as OrderTimelineEventSource_Enum;
          result.source_ = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorRole = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reasonCode = valueDes;
          break;
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.snapshotVersion = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.at = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderTimelineEvent deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderTimelineEventBuilder();
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


class OrderTimelineEventFamilyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER')
  static const OrderTimelineEventFamilyEnum ORDER = _$orderTimelineEventFamilyEnum_ORDER;
  @BuiltValueEnumConst(wireName: r'PAYMENT')
  static const OrderTimelineEventFamilyEnum PAYMENT = _$orderTimelineEventFamilyEnum_PAYMENT;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const OrderTimelineEventFamilyEnum FULFILLMENT = _$orderTimelineEventFamilyEnum_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'REFUND')
  static const OrderTimelineEventFamilyEnum REFUND = _$orderTimelineEventFamilyEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'DISPUTE')
  static const OrderTimelineEventFamilyEnum DISPUTE = _$orderTimelineEventFamilyEnum_DISPUTE;

  static Serializer<OrderTimelineEventFamilyEnum> get serializer => _$orderTimelineEventFamilyEnumSerializer;

  const OrderTimelineEventFamilyEnum._(String name): super(name);

  static BuiltSet<OrderTimelineEventFamilyEnum> get values => _$orderTimelineEventFamilyEnumValues;
  static OrderTimelineEventFamilyEnum valueOf(String name) => _$orderTimelineEventFamilyEnumValueOf(name);
}

class OrderTimelineEventSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const OrderTimelineEventSource_Enum BUYER = _$orderTimelineEventSourceEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const OrderTimelineEventSource_Enum VENDOR = _$orderTimelineEventSourceEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'SYSTEM')
  static const OrderTimelineEventSource_Enum SYSTEM = _$orderTimelineEventSourceEnum_SYSTEM;
  @BuiltValueEnumConst(wireName: r'AUTO_ACCEPT')
  static const OrderTimelineEventSource_Enum AUTO_ACCEPT = _$orderTimelineEventSourceEnum_AUTO_ACCEPT;

  static Serializer<OrderTimelineEventSource_Enum> get serializer => _$orderTimelineEventSourceEnumSerializer;

  const OrderTimelineEventSource_Enum._(String name): super(name);

  static BuiltSet<OrderTimelineEventSource_Enum> get values => _$orderTimelineEventSourceEnumValues;
  static OrderTimelineEventSource_Enum valueOf(String name) => _$orderTimelineEventSourceEnumValueOf(name);
}

