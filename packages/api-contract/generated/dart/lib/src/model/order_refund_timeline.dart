//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/cancellation_decision_view.dart';
import 'package:materyalph_api_client/src/model/reimbursement_timeline_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/refund_timeline_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_refund_timeline.g.dart';

/// OrderRefundTimeline
///
/// Properties:
/// * [refunds]
/// * [reimbursements]
/// * [noLongerDueCentavos]
/// * [decision]
@BuiltValue()
abstract class OrderRefundTimeline implements Built<OrderRefundTimeline, OrderRefundTimelineBuilder> {
  @BuiltValueField(wireName: r'refunds')
  BuiltList<RefundTimelineItem> get refunds;

  @BuiltValueField(wireName: r'reimbursements')
  BuiltList<ReimbursementTimelineItem> get reimbursements;

  @BuiltValueField(wireName: r'no_longer_due_centavos')
  int get noLongerDueCentavos;

  @BuiltValueField(wireName: r'decision')
  CancellationDecisionView? get decision;

  OrderRefundTimeline._();

  factory OrderRefundTimeline([void updates(OrderRefundTimelineBuilder b)]) = _$OrderRefundTimeline;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderRefundTimelineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderRefundTimeline> get serializer => _$OrderRefundTimelineSerializer();
}

class _$OrderRefundTimelineSerializer implements PrimitiveSerializer<OrderRefundTimeline> {
  @override
  final Iterable<Type> types = const [OrderRefundTimeline, _$OrderRefundTimeline];

  @override
  final String wireName = r'OrderRefundTimeline';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderRefundTimeline object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refunds';
    yield serializers.serialize(
      object.refunds,
      specifiedType: const FullType(BuiltList, [FullType(RefundTimelineItem)]),
    );
    yield r'reimbursements';
    yield serializers.serialize(
      object.reimbursements,
      specifiedType: const FullType(BuiltList, [FullType(ReimbursementTimelineItem)]),
    );
    yield r'no_longer_due_centavos';
    yield serializers.serialize(
      object.noLongerDueCentavos,
      specifiedType: const FullType(int),
    );
    if (object.decision != null) {
      yield r'decision';
      yield serializers.serialize(
        object.decision,
        specifiedType: const FullType.nullable(CancellationDecisionView),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderRefundTimeline object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderRefundTimelineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RefundTimelineItem)]),
          ) as BuiltList<RefundTimelineItem>;
          result.refunds.replace(valueDes);
          break;
        case r'reimbursements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReimbursementTimelineItem)]),
          ) as BuiltList<ReimbursementTimelineItem>;
          result.reimbursements.replace(valueDes);
          break;
        case r'no_longer_due_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.noLongerDueCentavos = valueDes;
          break;
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CancellationDecisionView),
          ) as CancellationDecisionView?;
          if (valueDes == null) continue;
          result.decision.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderRefundTimeline deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderRefundTimelineBuilder();
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


