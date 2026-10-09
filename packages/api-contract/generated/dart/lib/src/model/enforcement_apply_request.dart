//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_apply_request.g.dart';

/// EnforcementApplyRequest
///
/// Properties:
/// * [continuationPlan]
/// * [continuationNote]
/// * [lockVersion]
/// * [reason]
@BuiltValue()
abstract class EnforcementApplyRequest implements Built<EnforcementApplyRequest, EnforcementApplyRequestBuilder> {
  @BuiltValueField(wireName: r'continuation_plan')
  EnforcementApplyRequestContinuationPlanEnum get continuationPlan;
  // enum continuationPlanEnum {  CONTINUE,  MONITORED_FULFILLMENT,  CANCELLATION_REVIEW,  REPLACEMENT,  REFUND,  NO_OPEN_ORDERS,  };

  @BuiltValueField(wireName: r'continuation_note')
  String? get continuationNote;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  EnforcementApplyRequest._();

  factory EnforcementApplyRequest([void updates(EnforcementApplyRequestBuilder b)]) = _$EnforcementApplyRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementApplyRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementApplyRequest> get serializer => _$EnforcementApplyRequestSerializer();
}

class _$EnforcementApplyRequestSerializer implements PrimitiveSerializer<EnforcementApplyRequest> {
  @override
  final Iterable<Type> types = const [EnforcementApplyRequest, _$EnforcementApplyRequest];

  @override
  final String wireName = r'EnforcementApplyRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementApplyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'continuation_plan';
    yield serializers.serialize(
      object.continuationPlan,
      specifiedType: const FullType(EnforcementApplyRequestContinuationPlanEnum),
    );
    if (object.continuationNote != null) {
      yield r'continuation_note';
      yield serializers.serialize(
        object.continuationNote,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementApplyRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementApplyRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'continuation_plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementApplyRequestContinuationPlanEnum),
          ) as EnforcementApplyRequestContinuationPlanEnum;
          result.continuationPlan = valueDes;
          break;
        case r'continuation_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.continuationNote = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  EnforcementApplyRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementApplyRequestBuilder();
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


class EnforcementApplyRequestContinuationPlanEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONTINUE')
  static const EnforcementApplyRequestContinuationPlanEnum CONTINUE = _$enforcementApplyRequestContinuationPlanEnum_CONTINUE;
  @BuiltValueEnumConst(wireName: r'MONITORED_FULFILLMENT')
  static const EnforcementApplyRequestContinuationPlanEnum MONITORED_FULFILLMENT = _$enforcementApplyRequestContinuationPlanEnum_MONITORED_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'CANCELLATION_REVIEW')
  static const EnforcementApplyRequestContinuationPlanEnum CANCELLATION_REVIEW = _$enforcementApplyRequestContinuationPlanEnum_CANCELLATION_REVIEW;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const EnforcementApplyRequestContinuationPlanEnum REPLACEMENT = _$enforcementApplyRequestContinuationPlanEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'REFUND')
  static const EnforcementApplyRequestContinuationPlanEnum REFUND = _$enforcementApplyRequestContinuationPlanEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_OPEN_ORDERS')
  static const EnforcementApplyRequestContinuationPlanEnum NO_OPEN_ORDERS = _$enforcementApplyRequestContinuationPlanEnum_NO_OPEN_ORDERS;

  static Serializer<EnforcementApplyRequestContinuationPlanEnum> get serializer => _$enforcementApplyRequestContinuationPlanEnumSerializer;

  const EnforcementApplyRequestContinuationPlanEnum._(String name): super(name);

  static BuiltSet<EnforcementApplyRequestContinuationPlanEnum> get values => _$enforcementApplyRequestContinuationPlanEnumValues;
  static EnforcementApplyRequestContinuationPlanEnum valueOf(String name) => _$enforcementApplyRequestContinuationPlanEnumValueOf(name);
}

