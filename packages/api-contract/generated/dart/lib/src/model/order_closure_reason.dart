//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_closure_reason.g.dart';

/// OrderClosureReason
///
/// Properties:
/// * [code]
/// * [label]
@BuiltValue()
abstract class OrderClosureReason implements Built<OrderClosureReason, OrderClosureReasonBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  OrderClosureReason._();

  factory OrderClosureReason([void updates(OrderClosureReasonBuilder b)]) = _$OrderClosureReason;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderClosureReasonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderClosureReason> get serializer => _$OrderClosureReasonSerializer();
}

class _$OrderClosureReasonSerializer implements PrimitiveSerializer<OrderClosureReason> {
  @override
  final Iterable<Type> types = const [OrderClosureReason, _$OrderClosureReason];

  @override
  final String wireName = r'OrderClosureReason';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderClosureReason object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderClosureReason object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderClosureReasonBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderClosureReason deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderClosureReasonBuilder();
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


