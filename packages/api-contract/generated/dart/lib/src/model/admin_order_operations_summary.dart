//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_operations_summary.g.dart';

/// AdminOrderOperationsSummary
///
/// Properties:
/// * [refundsFailed]
/// * [refundsPending]
/// * [reimbursementsPending]
/// * [cancellationRequestsOpen]
/// * [nfrEvents30Days]
@BuiltValue()
abstract class AdminOrderOperationsSummary implements Built<AdminOrderOperationsSummary, AdminOrderOperationsSummaryBuilder> {
  @BuiltValueField(wireName: r'refunds_failed')
  int get refundsFailed;

  @BuiltValueField(wireName: r'refunds_pending')
  int get refundsPending;

  @BuiltValueField(wireName: r'reimbursements_pending')
  int get reimbursementsPending;

  @BuiltValueField(wireName: r'cancellation_requests_open')
  int get cancellationRequestsOpen;

  @BuiltValueField(wireName: r'nfr_events_30_days')
  int get nfrEvents30Days;

  AdminOrderOperationsSummary._();

  factory AdminOrderOperationsSummary([void updates(AdminOrderOperationsSummaryBuilder b)]) = _$AdminOrderOperationsSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderOperationsSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderOperationsSummary> get serializer => _$AdminOrderOperationsSummarySerializer();
}

class _$AdminOrderOperationsSummarySerializer implements PrimitiveSerializer<AdminOrderOperationsSummary> {
  @override
  final Iterable<Type> types = const [AdminOrderOperationsSummary, _$AdminOrderOperationsSummary];

  @override
  final String wireName = r'AdminOrderOperationsSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderOperationsSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refunds_failed';
    yield serializers.serialize(
      object.refundsFailed,
      specifiedType: const FullType(int),
    );
    yield r'refunds_pending';
    yield serializers.serialize(
      object.refundsPending,
      specifiedType: const FullType(int),
    );
    yield r'reimbursements_pending';
    yield serializers.serialize(
      object.reimbursementsPending,
      specifiedType: const FullType(int),
    );
    yield r'cancellation_requests_open';
    yield serializers.serialize(
      object.cancellationRequestsOpen,
      specifiedType: const FullType(int),
    );
    yield r'nfr_events_30_days';
    yield serializers.serialize(
      object.nfrEvents30Days,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderOperationsSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderOperationsSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refunds_failed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundsFailed = valueDes;
          break;
        case r'refunds_pending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundsPending = valueDes;
          break;
        case r'reimbursements_pending':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reimbursementsPending = valueDes;
          break;
        case r'cancellation_requests_open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cancellationRequestsOpen = valueDes;
          break;
        case r'nfr_events_30_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nfrEvents30Days = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderOperationsSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderOperationsSummaryBuilder();
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


