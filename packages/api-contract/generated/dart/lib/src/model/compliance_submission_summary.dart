//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/compliance_review_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/compliance_path.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_submission_summary.g.dart';

/// ComplianceSubmissionSummary
///
/// Properties:
/// * [id]
/// * [version]
/// * [path]
/// * [status]
/// * [markingType]
/// * [submittedAt]
/// * [decidedAt]
/// * [latestReview]
@BuiltValue()
abstract class ComplianceSubmissionSummary implements Built<ComplianceSubmissionSummary, ComplianceSubmissionSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'path')
  CompliancePath get path;
  // enum pathEnum {  PHOTO_OCR,  QR,  MANUAL,  };

  @BuiltValueField(wireName: r'status')
  ComplianceSubmissionSummaryStatusEnum get status;
  // enum statusEnum {  PENDING_ADMIN_REVIEW,  VERIFIED,  CHANGES_REQUIRED,  REJECTED,  SUPERSEDED,  };

  @BuiltValueField(wireName: r'marking_type')
  String? get markingType;

  @BuiltValueField(wireName: r'submitted_at')
  String? get submittedAt;

  @BuiltValueField(wireName: r'decided_at')
  String? get decidedAt;

  @BuiltValueField(wireName: r'latest_review')
  ComplianceReviewSummary? get latestReview;

  ComplianceSubmissionSummary._();

  factory ComplianceSubmissionSummary([void updates(ComplianceSubmissionSummaryBuilder b)]) = _$ComplianceSubmissionSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceSubmissionSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceSubmissionSummary> get serializer => _$ComplianceSubmissionSummarySerializer();
}

class _$ComplianceSubmissionSummarySerializer implements PrimitiveSerializer<ComplianceSubmissionSummary> {
  @override
  final Iterable<Type> types = const [ComplianceSubmissionSummary, _$ComplianceSubmissionSummary];

  @override
  final String wireName = r'ComplianceSubmissionSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceSubmissionSummary object, {
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
    yield r'path';
    yield serializers.serialize(
      object.path,
      specifiedType: const FullType(CompliancePath),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ComplianceSubmissionSummaryStatusEnum),
    );
    if (object.markingType != null) {
      yield r'marking_type';
      yield serializers.serialize(
        object.markingType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.decidedAt != null) {
      yield r'decided_at';
      yield serializers.serialize(
        object.decidedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.latestReview != null) {
      yield r'latest_review';
      yield serializers.serialize(
        object.latestReview,
        specifiedType: const FullType.nullable(ComplianceReviewSummary),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceSubmissionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceSubmissionSummaryBuilder result,
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
        case r'path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CompliancePath),
          ) as CompliancePath;
          result.path = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceSubmissionSummaryStatusEnum),
          ) as ComplianceSubmissionSummaryStatusEnum;
          result.status = valueDes;
          break;
        case r'marking_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.markingType = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'decided_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        case r'latest_review':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ComplianceReviewSummary),
          ) as ComplianceReviewSummary?;
          if (valueDes == null) continue;
          result.latestReview.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceSubmissionSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceSubmissionSummaryBuilder();
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


class ComplianceSubmissionSummaryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_ADMIN_REVIEW')
  static const ComplianceSubmissionSummaryStatusEnum PENDING_ADMIN_REVIEW = _$complianceSubmissionSummaryStatusEnum_PENDING_ADMIN_REVIEW;
  @BuiltValueEnumConst(wireName: r'VERIFIED')
  static const ComplianceSubmissionSummaryStatusEnum VERIFIED = _$complianceSubmissionSummaryStatusEnum_VERIFIED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const ComplianceSubmissionSummaryStatusEnum CHANGES_REQUIRED = _$complianceSubmissionSummaryStatusEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ComplianceSubmissionSummaryStatusEnum REJECTED = _$complianceSubmissionSummaryStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'SUPERSEDED')
  static const ComplianceSubmissionSummaryStatusEnum SUPERSEDED = _$complianceSubmissionSummaryStatusEnum_SUPERSEDED;

  static Serializer<ComplianceSubmissionSummaryStatusEnum> get serializer => _$complianceSubmissionSummaryStatusEnumSerializer;

  const ComplianceSubmissionSummaryStatusEnum._(String name): super(name);

  static BuiltSet<ComplianceSubmissionSummaryStatusEnum> get values => _$complianceSubmissionSummaryStatusEnumValues;
  static ComplianceSubmissionSummaryStatusEnum valueOf(String name) => _$complianceSubmissionSummaryStatusEnumValueOf(name);
}

