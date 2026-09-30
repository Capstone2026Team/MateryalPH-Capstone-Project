//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_revision_decision.g.dart';

/// OrderRevisionDecision
///
/// Properties:
/// * [snapshotVersion] - The commercial version the Buyer reviewed.
/// * [reason]
@BuiltValue()
abstract class OrderRevisionDecision implements Built<OrderRevisionDecision, OrderRevisionDecisionBuilder> {
  /// The commercial version the Buyer reviewed.
  @BuiltValueField(wireName: r'snapshot_version')
  int get snapshotVersion;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  OrderRevisionDecision._();

  factory OrderRevisionDecision([void updates(OrderRevisionDecisionBuilder b)]) = _$OrderRevisionDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderRevisionDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderRevisionDecision> get serializer => _$OrderRevisionDecisionSerializer();
}

class _$OrderRevisionDecisionSerializer implements PrimitiveSerializer<OrderRevisionDecision> {
  @override
  final Iterable<Type> types = const [OrderRevisionDecision, _$OrderRevisionDecision];

  @override
  final String wireName = r'OrderRevisionDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderRevisionDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'snapshot_version';
    yield serializers.serialize(
      object.snapshotVersion,
      specifiedType: const FullType(int),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderRevisionDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderRevisionDecisionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.snapshotVersion = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderRevisionDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderRevisionDecisionBuilder();
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


