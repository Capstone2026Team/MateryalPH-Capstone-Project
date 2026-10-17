//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_account_deletion_blockers.g.dart';

/// BuyerAccountDeletionBlockers
///
/// Properties:
/// * [activeOrders]
/// * [activeDisputes]
/// * [pendingRefunds]
@BuiltValue()
abstract class BuyerAccountDeletionBlockers implements Built<BuyerAccountDeletionBlockers, BuyerAccountDeletionBlockersBuilder> {
  @BuiltValueField(wireName: r'active_orders')
  int get activeOrders;

  @BuiltValueField(wireName: r'active_disputes')
  int get activeDisputes;

  @BuiltValueField(wireName: r'pending_refunds')
  int get pendingRefunds;

  BuyerAccountDeletionBlockers._();

  factory BuyerAccountDeletionBlockers([void updates(BuyerAccountDeletionBlockersBuilder b)]) = _$BuyerAccountDeletionBlockers;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAccountDeletionBlockersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAccountDeletionBlockers> get serializer => _$BuyerAccountDeletionBlockersSerializer();
}

class _$BuyerAccountDeletionBlockersSerializer implements PrimitiveSerializer<BuyerAccountDeletionBlockers> {
  @override
  final Iterable<Type> types = const [BuyerAccountDeletionBlockers, _$BuyerAccountDeletionBlockers];

  @override
  final String wireName = r'BuyerAccountDeletionBlockers';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAccountDeletionBlockers object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active_orders';
    yield serializers.serialize(
      object.activeOrders,
      specifiedType: const FullType(int),
    );
    yield r'active_disputes';
    yield serializers.serialize(
      object.activeDisputes,
      specifiedType: const FullType(int),
    );
    yield r'pending_refunds';
    yield serializers.serialize(
      object.pendingRefunds,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAccountDeletionBlockers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAccountDeletionBlockersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeOrders = valueDes;
          break;
        case r'active_disputes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.activeDisputes = valueDes;
          break;
        case r'pending_refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingRefunds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAccountDeletionBlockers deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAccountDeletionBlockersBuilder();
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


