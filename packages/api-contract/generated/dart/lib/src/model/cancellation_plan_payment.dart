//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_plan_payment.g.dart';

/// CancellationPlanPayment
///
/// Properties:
/// * [paymentId]
/// * [purpose]
/// * [channelCode]
/// * [channelName]
/// * [capturedCentavos]
/// * [priorAllocatedCentavos]
/// * [retainedCentavos]
/// * [refundCentavos]
/// * [principalCentavos]
/// * [processingFeeCentavos]
/// * [cappedByPriorRefunds]
/// * [allocation]
@BuiltValue()
abstract class CancellationPlanPayment implements Built<CancellationPlanPayment, CancellationPlanPaymentBuilder> {
  @BuiltValueField(wireName: r'payment_id')
  String get paymentId;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  @BuiltValueField(wireName: r'channel_code')
  String? get channelCode;

  @BuiltValueField(wireName: r'channel_name')
  String? get channelName;

  @BuiltValueField(wireName: r'captured_centavos')
  int get capturedCentavos;

  @BuiltValueField(wireName: r'prior_allocated_centavos')
  int get priorAllocatedCentavos;

  @BuiltValueField(wireName: r'retained_centavos')
  int get retainedCentavos;

  @BuiltValueField(wireName: r'refund_centavos')
  int get refundCentavos;

  @BuiltValueField(wireName: r'principal_centavos')
  int get principalCentavos;

  @BuiltValueField(wireName: r'processing_fee_centavos')
  int get processingFeeCentavos;

  @BuiltValueField(wireName: r'capped_by_prior_refunds')
  bool get cappedByPriorRefunds;

  @BuiltValueField(wireName: r'allocation')
  BuiltMap<String, JsonObject?> get allocation;

  CancellationPlanPayment._();

  factory CancellationPlanPayment([void updates(CancellationPlanPaymentBuilder b)]) = _$CancellationPlanPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationPlanPaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationPlanPayment> get serializer => _$CancellationPlanPaymentSerializer();
}

class _$CancellationPlanPaymentSerializer implements PrimitiveSerializer<CancellationPlanPayment> {
  @override
  final Iterable<Type> types = const [CancellationPlanPayment, _$CancellationPlanPayment];

  @override
  final String wireName = r'CancellationPlanPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationPlanPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payment_id';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(String),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
    if (object.channelCode != null) {
      yield r'channel_code';
      yield serializers.serialize(
        object.channelCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.channelName != null) {
      yield r'channel_name';
      yield serializers.serialize(
        object.channelName,
        specifiedType: const FullType(String),
      );
    }
    yield r'captured_centavos';
    yield serializers.serialize(
      object.capturedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'prior_allocated_centavos';
    yield serializers.serialize(
      object.priorAllocatedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'retained_centavos';
    yield serializers.serialize(
      object.retainedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refund_centavos';
    yield serializers.serialize(
      object.refundCentavos,
      specifiedType: const FullType(int),
    );
    yield r'principal_centavos';
    yield serializers.serialize(
      object.principalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'processing_fee_centavos';
    yield serializers.serialize(
      object.processingFeeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'capped_by_prior_refunds';
    yield serializers.serialize(
      object.cappedByPriorRefunds,
      specifiedType: const FullType(bool),
    );
    yield r'allocation';
    yield serializers.serialize(
      object.allocation,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationPlanPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationPlanPaymentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payment_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentId = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        case r'channel_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.channelCode = valueDes;
          break;
        case r'channel_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.channelName = valueDes;
          break;
        case r'captured_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.capturedCentavos = valueDes;
          break;
        case r'prior_allocated_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priorAllocatedCentavos = valueDes;
          break;
        case r'retained_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.retainedCentavos = valueDes;
          break;
        case r'refund_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundCentavos = valueDes;
          break;
        case r'principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.principalCentavos = valueDes;
          break;
        case r'processing_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.processingFeeCentavos = valueDes;
          break;
        case r'capped_by_prior_refunds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.cappedByPriorRefunds = valueDes;
          break;
        case r'allocation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.allocation.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationPlanPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationPlanPaymentBuilder();
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


