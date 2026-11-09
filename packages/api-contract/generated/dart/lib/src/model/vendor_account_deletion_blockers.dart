//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_account_deletion_blockers.g.dart';

/// VendorAccountDeletionBlockers
///
/// Properties:
/// * [activeOrders]
/// * [pendingPayments]
/// * [unresolvedDisputes]
/// * [pendingRefunds]
/// * [uncollectedPayments]
/// * [outstandingStatements]
/// * [unbilledCommissions]
/// * [financeReviews]
@BuiltValue()
abstract class VendorAccountDeletionBlockers implements Built<VendorAccountDeletionBlockers, VendorAccountDeletionBlockersBuilder> {
  @BuiltValueField(wireName: r'active_orders')
  int get activeOrders;

  @BuiltValueField(wireName: r'pending_payments')
  int get pendingPayments;

  @BuiltValueField(wireName: r'unresolved_disputes')
  int get unresolvedDisputes;

  @BuiltValueField(wireName: r'pending_refunds')
  int get pendingRefunds;

  @BuiltValueField(wireName: r'uncollected_payments')
  int get uncollectedPayments;

  @BuiltValueField(wireName: r'outstanding_statements')
  int get outstandingStatements;

  @BuiltValueField(wireName: r'unbilled_commissions')
  int get unbilledCommissions;

  @BuiltValueField(wireName: r'finance_reviews')
  int get financeReviews;

  VendorAccountDeletionBlockers._();

  factory VendorAccountDeletionBlockers([void updates(VendorAccountDeletionBlockersBuilder b)]) = _$VendorAccountDeletionBlockers;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAccountDeletionBlockersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAccountDeletionBlockers> get serializer => _$VendorAccountDeletionBlockersSerializer();
}

class _$VendorAccountDeletionBlockersSerializer implements PrimitiveSerializer<VendorAccountDeletionBlockers> {
  @override
  final Iterable<Type> types = const [VendorAccountDeletionBlockers, _$VendorAccountDeletionBlockers];

  @override
  final String wireName = r'VendorAccountDeletionBlockers';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAccountDeletionBlockers object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active_orders';
    yield serializers.serialize(
      object.activeOrders,
      specifiedType: const FullType(int),
    );
    yield r'pending_payments';
    yield serializers.serialize(
      object.pendingPayments,
      specifiedType: const FullType(int),
    );
    yield r'unresolved_disputes';
    yield serializers.serialize(
      object.unresolvedDisputes,
      specifiedType: const FullType(int),
    );
    yield r'pending_refunds';
    yield serializers.serialize(
      object.pendingRefunds,
      specifiedType: const FullType(int),
    );
    yield r'uncollected_payments';
    yield serializers.serialize(
      object.uncollectedPayments,
      specifiedType: const FullType(int),
    );
    yield r'outstanding_statements';
    yield serializers.serialize(
      object.outstandingStatements,
      specifiedType: const FullType(int),
    );
    yield r'unbilled_commissions';
    yield serializers.serialize(
      object.unbilledCommissions,
      specifiedType: const FullType(int),
    );
    yield r'finance_reviews';
    yield serializers.serialize(
      object.financeReviews,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAccountDeletionBlockers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAccountDeletionBlockersBuilder result,
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
        case r'pending_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingPayments = valueDes;
          break;
        case r'unresolved_disputes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unresolvedDisputes = valueDes;
          break;
        case r'pending_refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingRefunds = valueDes;
          break;
        case r'uncollected_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.uncollectedPayments = valueDes;
          break;
        case r'outstanding_statements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outstandingStatements = valueDes;
          break;
        case r'unbilled_commissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unbilledCommissions = valueDes;
          break;
        case r'finance_reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.financeReviews = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorAccountDeletionBlockers deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAccountDeletionBlockersBuilder();
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


