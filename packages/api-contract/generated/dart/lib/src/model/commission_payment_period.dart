//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_payment_period.g.dart';

/// Confirmed commission statement allocations less completed fee refunds by each event's Asia/Manila calendar period. A refund-only period may have a negative net. Does not include Buyer payments, estimates, unpaid bills or approved credits without a completed cash refund.
///
/// Properties:
/// * [label] - Calendar year or month and year.
/// * [startsOn]
/// * [endsOn]
/// * [resetsAt] - Exclusive end at midnight Asia/Manila; the next period begins here.
/// * [collectedCentavos]
/// * [refundedCentavos]
/// * [netCollectedCentavos]
@BuiltValue()
abstract class CommissionPaymentPeriod implements Built<CommissionPaymentPeriod, CommissionPaymentPeriodBuilder> {
  /// Calendar year or month and year.
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'starts_on')
  Date get startsOn;

  @BuiltValueField(wireName: r'ends_on')
  Date get endsOn;

  /// Exclusive end at midnight Asia/Manila; the next period begins here.
  @BuiltValueField(wireName: r'resets_at')
  DateTime get resetsAt;

  @BuiltValueField(wireName: r'collected_centavos')
  int get collectedCentavos;

  @BuiltValueField(wireName: r'refunded_centavos')
  int get refundedCentavos;

  @BuiltValueField(wireName: r'net_collected_centavos')
  int get netCollectedCentavos;

  CommissionPaymentPeriod._();

  factory CommissionPaymentPeriod([void updates(CommissionPaymentPeriodBuilder b)]) = _$CommissionPaymentPeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionPaymentPeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionPaymentPeriod> get serializer => _$CommissionPaymentPeriodSerializer();
}

class _$CommissionPaymentPeriodSerializer implements PrimitiveSerializer<CommissionPaymentPeriod> {
  @override
  final Iterable<Type> types = const [CommissionPaymentPeriod, _$CommissionPaymentPeriod];

  @override
  final String wireName = r'CommissionPaymentPeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionPaymentPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'starts_on';
    yield serializers.serialize(
      object.startsOn,
      specifiedType: const FullType(Date),
    );
    yield r'ends_on';
    yield serializers.serialize(
      object.endsOn,
      specifiedType: const FullType(Date),
    );
    yield r'resets_at';
    yield serializers.serialize(
      object.resetsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'collected_centavos';
    yield serializers.serialize(
      object.collectedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refunded_centavos';
    yield serializers.serialize(
      object.refundedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'net_collected_centavos';
    yield serializers.serialize(
      object.netCollectedCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionPaymentPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionPaymentPeriodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'starts_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.startsOn = valueDes;
          break;
        case r'ends_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.endsOn = valueDes;
          break;
        case r'resets_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.resetsAt = valueDes;
          break;
        case r'collected_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.collectedCentavos = valueDes;
          break;
        case r'refunded_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundedCentavos = valueDes;
          break;
        case r'net_collected_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netCollectedCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionPaymentPeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionPaymentPeriodBuilder();
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


