//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_policy_publish_request.g.dart';

/// CommissionPolicyPublishRequest
///
/// Properties:
/// * [commissionBasisPoints]
/// * [expectedVersion]
/// * [effectiveFrom] - Omit or null to apply now; otherwise a future instant.
/// * [reason]
/// * [vendorMessage]
/// * [noticeOverride]
/// * [noticeOverrideReason]
/// * [supersedesPolicyId]
/// * [cancelScheduled]
@BuiltValue()
abstract class CommissionPolicyPublishRequest implements Built<CommissionPolicyPublishRequest, CommissionPolicyPublishRequestBuilder> {
  @BuiltValueField(wireName: r'commission_basis_points')
  int get commissionBasisPoints;

  @BuiltValueField(wireName: r'expected_version')
  int get expectedVersion;

  /// Omit or null to apply now; otherwise a future instant.
  @BuiltValueField(wireName: r'effective_from')
  DateTime? get effectiveFrom;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'vendor_message')
  String? get vendorMessage;

  @BuiltValueField(wireName: r'notice_override')
  bool? get noticeOverride;

  @BuiltValueField(wireName: r'notice_override_reason')
  String? get noticeOverrideReason;

  @BuiltValueField(wireName: r'supersedes_policy_id')
  String? get supersedesPolicyId;

  @BuiltValueField(wireName: r'cancel_scheduled')
  bool? get cancelScheduled;

  CommissionPolicyPublishRequest._();

  factory CommissionPolicyPublishRequest([void updates(CommissionPolicyPublishRequestBuilder b)]) = _$CommissionPolicyPublishRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionPolicyPublishRequestBuilder b) => b
      ..noticeOverride = false
      ..cancelScheduled = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionPolicyPublishRequest> get serializer => _$CommissionPolicyPublishRequestSerializer();
}

class _$CommissionPolicyPublishRequestSerializer implements PrimitiveSerializer<CommissionPolicyPublishRequest> {
  @override
  final Iterable<Type> types = const [CommissionPolicyPublishRequest, _$CommissionPolicyPublishRequest];

  @override
  final String wireName = r'CommissionPolicyPublishRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionPolicyPublishRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'commission_basis_points';
    yield serializers.serialize(
      object.commissionBasisPoints,
      specifiedType: const FullType(int),
    );
    yield r'expected_version';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(int),
    );
    if (object.effectiveFrom != null) {
      yield r'effective_from';
      yield serializers.serialize(
        object.effectiveFrom,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.vendorMessage != null) {
      yield r'vendor_message';
      yield serializers.serialize(
        object.vendorMessage,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.noticeOverride != null) {
      yield r'notice_override';
      yield serializers.serialize(
        object.noticeOverride,
        specifiedType: const FullType(bool),
      );
    }
    if (object.noticeOverrideReason != null) {
      yield r'notice_override_reason';
      yield serializers.serialize(
        object.noticeOverrideReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.supersedesPolicyId != null) {
      yield r'supersedes_policy_id';
      yield serializers.serialize(
        object.supersedesPolicyId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.cancelScheduled != null) {
      yield r'cancel_scheduled';
      yield serializers.serialize(
        object.cancelScheduled,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionPolicyPublishRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionPolicyPublishRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'commission_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionBasisPoints = valueDes;
          break;
        case r'expected_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedVersion = valueDes;
          break;
        case r'effective_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveFrom = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'vendor_message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorMessage = valueDes;
          break;
        case r'notice_override':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.noticeOverride = valueDes;
          break;
        case r'notice_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.noticeOverrideReason = valueDes;
          break;
        case r'supersedes_policy_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supersedesPolicyId = valueDes;
          break;
        case r'cancel_scheduled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.cancelScheduled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionPolicyPublishRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionPolicyPublishRequestBuilder();
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


