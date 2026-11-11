//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/commission_policy.dart';
import 'package:materyalph_api_client/src/model/vendor_commission_summary.dart';
import 'package:materyalph_api_client/src/model/commission_payment_history.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/commission_payment_period.dart';
import 'package:materyalph_api_client/src/model/vendor_commission_assessment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_commission_monitoring.g.dart';

/// VendorCommissionMonitoring
///
/// Properties:
/// * [termsAccepted] - Current Owner acceptance and applicable authority approval for the effective versioned terms.
/// * [currentPolicy]
/// * [nextPolicy]
/// * [summary]
/// * [annualPayments]
/// * [monthlyPayments]
/// * [paymentHistory]
/// * [assessments]
@BuiltValue()
abstract class VendorCommissionMonitoring implements Built<VendorCommissionMonitoring, VendorCommissionMonitoringBuilder> {
  /// Current Owner acceptance and applicable authority approval for the effective versioned terms.
  @BuiltValueField(wireName: r'terms_accepted')
  bool get termsAccepted;

  @BuiltValueField(wireName: r'current_policy')
  CommissionPolicy? get currentPolicy;

  @BuiltValueField(wireName: r'next_policy')
  CommissionPolicy? get nextPolicy;

  @BuiltValueField(wireName: r'summary')
  VendorCommissionSummary get summary;

  @BuiltValueField(wireName: r'annual_payments')
  CommissionPaymentPeriod get annualPayments;

  @BuiltValueField(wireName: r'monthly_payments')
  CommissionPaymentPeriod get monthlyPayments;

  @BuiltValueField(wireName: r'payment_history')
  CommissionPaymentHistory get paymentHistory;

  @BuiltValueField(wireName: r'assessments')
  BuiltList<VendorCommissionAssessment> get assessments;

  VendorCommissionMonitoring._();

  factory VendorCommissionMonitoring([void updates(VendorCommissionMonitoringBuilder b)]) = _$VendorCommissionMonitoring;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCommissionMonitoringBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCommissionMonitoring> get serializer => _$VendorCommissionMonitoringSerializer();
}

class _$VendorCommissionMonitoringSerializer implements PrimitiveSerializer<VendorCommissionMonitoring> {
  @override
  final Iterable<Type> types = const [VendorCommissionMonitoring, _$VendorCommissionMonitoring];

  @override
  final String wireName = r'VendorCommissionMonitoring';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCommissionMonitoring object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'terms_accepted';
    yield serializers.serialize(
      object.termsAccepted,
      specifiedType: const FullType(bool),
    );
    if (object.currentPolicy != null) {
      yield r'current_policy';
      yield serializers.serialize(
        object.currentPolicy,
        specifiedType: const FullType.nullable(CommissionPolicy),
      );
    }
    if (object.nextPolicy != null) {
      yield r'next_policy';
      yield serializers.serialize(
        object.nextPolicy,
        specifiedType: const FullType.nullable(CommissionPolicy),
      );
    }
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(VendorCommissionSummary),
    );
    yield r'annual_payments';
    yield serializers.serialize(
      object.annualPayments,
      specifiedType: const FullType(CommissionPaymentPeriod),
    );
    yield r'monthly_payments';
    yield serializers.serialize(
      object.monthlyPayments,
      specifiedType: const FullType(CommissionPaymentPeriod),
    );
    yield r'payment_history';
    yield serializers.serialize(
      object.paymentHistory,
      specifiedType: const FullType(CommissionPaymentHistory),
    );
    yield r'assessments';
    yield serializers.serialize(
      object.assessments,
      specifiedType: const FullType(BuiltList, [FullType(VendorCommissionAssessment)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCommissionMonitoring object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCommissionMonitoringBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'terms_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.termsAccepted = valueDes;
          break;
        case r'current_policy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionPolicy),
          ) as CommissionPolicy?;
          if (valueDes == null) continue;
          result.currentPolicy.replace(valueDes);
          break;
        case r'next_policy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionPolicy),
          ) as CommissionPolicy?;
          if (valueDes == null) continue;
          result.nextPolicy.replace(valueDes);
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorCommissionSummary),
          ) as VendorCommissionSummary;
          result.summary.replace(valueDes);
          break;
        case r'annual_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionPaymentPeriod),
          ) as CommissionPaymentPeriod;
          result.annualPayments.replace(valueDes);
          break;
        case r'monthly_payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionPaymentPeriod),
          ) as CommissionPaymentPeriod;
          result.monthlyPayments.replace(valueDes);
          break;
        case r'payment_history':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionPaymentHistory),
          ) as CommissionPaymentHistory;
          result.paymentHistory.replace(valueDes);
          break;
        case r'assessments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorCommissionAssessment)]),
          ) as BuiltList<VendorCommissionAssessment>;
          result.assessments.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorCommissionMonitoring deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCommissionMonitoringBuilder();
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


