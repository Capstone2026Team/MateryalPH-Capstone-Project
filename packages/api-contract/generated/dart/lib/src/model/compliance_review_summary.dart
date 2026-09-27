//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_review_summary.g.dart';

/// ComplianceReviewSummary
///
/// Properties:
/// * [decision]
/// * [reason]
/// * [reviewedAt]
/// * [source_]
@BuiltValue()
abstract class ComplianceReviewSummary implements Built<ComplianceReviewSummary, ComplianceReviewSummaryBuilder> {
  @BuiltValueField(wireName: r'decision')
  ComplianceReviewSummaryDecisionEnum get decision;
  // enum decisionEnum {  APPROVED,  CHANGES_REQUIRED,  REJECTED,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'reviewed_at')
  String? get reviewedAt;

  @BuiltValueField(wireName: r'source')
  ComplianceReviewSummarySource_Enum get source_;
  // enum source_Enum {  ADMIN,  SYSTEM_REGISTER_MATCH,  };

  ComplianceReviewSummary._();

  factory ComplianceReviewSummary([void updates(ComplianceReviewSummaryBuilder b)]) = _$ComplianceReviewSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceReviewSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceReviewSummary> get serializer => _$ComplianceReviewSummarySerializer();
}

class _$ComplianceReviewSummarySerializer implements PrimitiveSerializer<ComplianceReviewSummary> {
  @override
  final Iterable<Type> types = const [ComplianceReviewSummary, _$ComplianceReviewSummary];

  @override
  final String wireName = r'ComplianceReviewSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceReviewSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(ComplianceReviewSummaryDecisionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reviewedAt != null) {
      yield r'reviewed_at';
      yield serializers.serialize(
        object.reviewedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(ComplianceReviewSummarySource_Enum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceReviewSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceReviewSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceReviewSummaryDecisionEnum),
          ) as ComplianceReviewSummaryDecisionEnum;
          result.decision = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'reviewed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplianceReviewSummarySource_Enum),
          ) as ComplianceReviewSummarySource_Enum;
          result.source_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceReviewSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceReviewSummaryBuilder();
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


class ComplianceReviewSummaryDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const ComplianceReviewSummaryDecisionEnum APPROVED = _$complianceReviewSummaryDecisionEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const ComplianceReviewSummaryDecisionEnum CHANGES_REQUIRED = _$complianceReviewSummaryDecisionEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ComplianceReviewSummaryDecisionEnum REJECTED = _$complianceReviewSummaryDecisionEnum_REJECTED;

  static Serializer<ComplianceReviewSummaryDecisionEnum> get serializer => _$complianceReviewSummaryDecisionEnumSerializer;

  const ComplianceReviewSummaryDecisionEnum._(String name): super(name);

  static BuiltSet<ComplianceReviewSummaryDecisionEnum> get values => _$complianceReviewSummaryDecisionEnumValues;
  static ComplianceReviewSummaryDecisionEnum valueOf(String name) => _$complianceReviewSummaryDecisionEnumValueOf(name);
}

class ComplianceReviewSummarySource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const ComplianceReviewSummarySource_Enum ADMIN = _$complianceReviewSummarySourceEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'SYSTEM_REGISTER_MATCH')
  static const ComplianceReviewSummarySource_Enum SYSTEM_REGISTER_MATCH = _$complianceReviewSummarySourceEnum_SYSTEM_REGISTER_MATCH;

  static Serializer<ComplianceReviewSummarySource_Enum> get serializer => _$complianceReviewSummarySourceEnumSerializer;

  const ComplianceReviewSummarySource_Enum._(String name): super(name);

  static BuiltSet<ComplianceReviewSummarySource_Enum> get values => _$complianceReviewSummarySourceEnumValues;
  static ComplianceReviewSummarySource_Enum valueOf(String name) => _$complianceReviewSummarySourceEnumValueOf(name);
}

