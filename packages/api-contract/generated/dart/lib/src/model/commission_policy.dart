//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/commission_email_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_policy.g.dart';

/// CommissionPolicy
///
/// Properties:
/// * [id]
/// * [version]
/// * [commissionBasisPoints] - Integer basis points; 200 means 2.00%.
/// * [rateLabel]
/// * [effectiveFrom]
/// * [agreementVersionId]
/// * [reason]
/// * [status]
/// * [termsVersion]
/// * [termsContent]
/// * [vendorMessage]
/// * [noticeHours]
/// * [noticeOverrideReason] - Admin only.
/// * [publishedBy] - Admin audit identity; omitted in public and Vendor projections.
/// * [delivery]
@BuiltValue()
abstract class CommissionPolicy implements Built<CommissionPolicy, CommissionPolicyBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  /// Integer basis points; 200 means 2.00%.
  @BuiltValueField(wireName: r'commission_basis_points')
  int get commissionBasisPoints;

  @BuiltValueField(wireName: r'rate_label')
  String get rateLabel;

  @BuiltValueField(wireName: r'effective_from')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'agreement_version_id')
  String? get agreementVersionId;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'status')
  CommissionPolicyStatusEnum get status;
  // enum statusEnum {  CURRENT,  SCHEDULED,  PREVIOUS,  SUPERSEDED,  CANCELLED,  };

  @BuiltValueField(wireName: r'terms_version')
  int? get termsVersion;

  @BuiltValueField(wireName: r'terms_content')
  String? get termsContent;

  @BuiltValueField(wireName: r'vendor_message')
  String? get vendorMessage;

  @BuiltValueField(wireName: r'notice_hours')
  int? get noticeHours;

  /// Admin only.
  @BuiltValueField(wireName: r'notice_override_reason')
  String? get noticeOverrideReason;

  /// Admin audit identity; omitted in public and Vendor projections.
  @BuiltValueField(wireName: r'published_by')
  String? get publishedBy;

  @BuiltValueField(wireName: r'delivery')
  CommissionEmailSummary? get delivery;

  CommissionPolicy._();

  factory CommissionPolicy([void updates(CommissionPolicyBuilder b)]) = _$CommissionPolicy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionPolicyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionPolicy> get serializer => _$CommissionPolicySerializer();
}

class _$CommissionPolicySerializer implements PrimitiveSerializer<CommissionPolicy> {
  @override
  final Iterable<Type> types = const [CommissionPolicy, _$CommissionPolicy];

  @override
  final String wireName = r'CommissionPolicy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'commission_basis_points';
    yield serializers.serialize(
      object.commissionBasisPoints,
      specifiedType: const FullType(int),
    );
    yield r'rate_label';
    yield serializers.serialize(
      object.rateLabel,
      specifiedType: const FullType(String),
    );
    yield r'effective_from';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    if (object.agreementVersionId != null) {
      yield r'agreement_version_id';
      yield serializers.serialize(
        object.agreementVersionId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CommissionPolicyStatusEnum),
    );
    if (object.termsVersion != null) {
      yield r'terms_version';
      yield serializers.serialize(
        object.termsVersion,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.termsContent != null) {
      yield r'terms_content';
      yield serializers.serialize(
        object.termsContent,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.vendorMessage != null) {
      yield r'vendor_message';
      yield serializers.serialize(
        object.vendorMessage,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.noticeHours != null) {
      yield r'notice_hours';
      yield serializers.serialize(
        object.noticeHours,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.noticeOverrideReason != null) {
      yield r'notice_override_reason';
      yield serializers.serialize(
        object.noticeOverrideReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.publishedBy != null) {
      yield r'published_by';
      yield serializers.serialize(
        object.publishedBy,
        specifiedType: const FullType(String),
      );
    }
    if (object.delivery != null) {
      yield r'delivery';
      yield serializers.serialize(
        object.delivery,
        specifiedType: const FullType(CommissionEmailSummary),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionPolicy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionPolicyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'commission_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionBasisPoints = valueDes;
          break;
        case r'rate_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rateLabel = valueDes;
          break;
        case r'effective_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'agreement_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.agreementVersionId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionPolicyStatusEnum),
          ) as CommissionPolicyStatusEnum;
          result.status = valueDes;
          break;
        case r'terms_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.termsVersion = valueDes;
          break;
        case r'terms_content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.termsContent = valueDes;
          break;
        case r'vendor_message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorMessage = valueDes;
          break;
        case r'notice_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.noticeHours = valueDes;
          break;
        case r'notice_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.noticeOverrideReason = valueDes;
          break;
        case r'published_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publishedBy = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommissionEmailSummary),
          ) as CommissionEmailSummary?;
          if (valueDes == null) continue;
          result.delivery.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionPolicy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionPolicyBuilder();
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


class CommissionPolicyStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CURRENT')
  static const CommissionPolicyStatusEnum CURRENT = _$commissionPolicyStatusEnum_CURRENT;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const CommissionPolicyStatusEnum SCHEDULED = _$commissionPolicyStatusEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'PREVIOUS')
  static const CommissionPolicyStatusEnum PREVIOUS = _$commissionPolicyStatusEnum_PREVIOUS;
  @BuiltValueEnumConst(wireName: r'SUPERSEDED')
  static const CommissionPolicyStatusEnum SUPERSEDED = _$commissionPolicyStatusEnum_SUPERSEDED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CommissionPolicyStatusEnum CANCELLED = _$commissionPolicyStatusEnum_CANCELLED;

  static Serializer<CommissionPolicyStatusEnum> get serializer => _$commissionPolicyStatusEnumSerializer;

  const CommissionPolicyStatusEnum._(String name): super(name);

  static BuiltSet<CommissionPolicyStatusEnum> get values => _$commissionPolicyStatusEnumValues;
  static CommissionPolicyStatusEnum valueOf(String name) => _$commissionPolicyStatusEnumValueOf(name);
}

