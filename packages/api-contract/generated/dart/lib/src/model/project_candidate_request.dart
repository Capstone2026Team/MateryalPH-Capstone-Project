//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_specification_selection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_candidate_request.g.dart';

/// ProjectCandidateRequest
///
/// Properties:
/// * [lockVersion]
/// * [candidateId]
/// * [note]
/// * [budgetOverrideReason]
/// * [selections] - The Buyer's specification choice for each line whose `selection_required` is true. Selection and inquiry are rejected with SPECIFICATION_SELECTION_REQUIRED until every such line has one.
/// * [fulfillmentMethod] - The Buyer's method for a Vendor whose candidate lists more than one `fulfillment_options` entry (Both packages). Required then, or the request is rejected with FULFILLMENT_CHOICE_REQUIRED; a method the Vendor does not offer is rejected with FULFILLMENT_NOT_OFFERED.
/// * [paymentMethod] - Required for direct selection; explicitly chosen in the checklist and revalidated against current Vendor and fulfillment rules. Inquiry may omit it.
@BuiltValue(instantiable: false)
abstract class ProjectCandidateRequest  {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'candidate_id')
  String get candidateId;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  /// The Buyer's specification choice for each line whose `selection_required` is true. Selection and inquiry are rejected with SPECIFICATION_SELECTION_REQUIRED until every such line has one.
  @BuiltValueField(wireName: r'selections')
  BuiltList<ProjectSpecificationSelection>? get selections;

  /// The Buyer's method for a Vendor whose candidate lists more than one `fulfillment_options` entry (Both packages). Required then, or the request is rejected with FULFILLMENT_CHOICE_REQUIRED; a method the Vendor does not offer is rejected with FULFILLMENT_NOT_OFFERED.
  @BuiltValueField(wireName: r'fulfillment_method')
  ProjectCandidateRequestFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  PICKUP,  DELIVERY,  };

  /// Required for direct selection; explicitly chosen in the checklist and revalidated against current Vendor and fulfillment rules. Inquiry may omit it.
  @BuiltValueField(wireName: r'payment_method')
  ProjectCandidateRequestPaymentMethodEnum? get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectCandidateRequest> get serializer => _$ProjectCandidateRequestSerializer();
}

class _$ProjectCandidateRequestSerializer implements PrimitiveSerializer<ProjectCandidateRequest> {
  @override
  final Iterable<Type> types = const [ProjectCandidateRequest];

  @override
  final String wireName = r'ProjectCandidateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectCandidateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'candidate_id';
    yield serializers.serialize(
      object.candidateId,
      specifiedType: const FullType(String),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
    if (object.selections != null) {
      yield r'selections';
      yield serializers.serialize(
        object.selections,
        specifiedType: const FullType(BuiltList, [FullType(ProjectSpecificationSelection)]),
      );
    }
    if (object.fulfillmentMethod != null) {
      yield r'fulfillment_method';
      yield serializers.serialize(
        object.fulfillmentMethod,
        specifiedType: const FullType(ProjectCandidateRequestFulfillmentMethodEnum),
      );
    }
    if (object.paymentMethod != null) {
      yield r'payment_method';
      yield serializers.serialize(
        object.paymentMethod,
        specifiedType: const FullType(ProjectCandidateRequestPaymentMethodEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectCandidateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  ProjectCandidateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($ProjectCandidateRequest)) as $ProjectCandidateRequest;
  }
}


/// a concrete implementation of [ProjectCandidateRequest], since [ProjectCandidateRequest] is not instantiable
@BuiltValue(instantiable: true)
abstract class $ProjectCandidateRequest implements ProjectCandidateRequest, Built<$ProjectCandidateRequest, $ProjectCandidateRequestBuilder> {
  $ProjectCandidateRequest._();

  factory $ProjectCandidateRequest([void Function($ProjectCandidateRequestBuilder)? updates]) = _$$ProjectCandidateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($ProjectCandidateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$ProjectCandidateRequest> get serializer => _$$ProjectCandidateRequestSerializer();
}

class _$$ProjectCandidateRequestSerializer implements PrimitiveSerializer<$ProjectCandidateRequest> {
  @override
  final Iterable<Type> types = const [$ProjectCandidateRequest, _$$ProjectCandidateRequest];

  @override
  final String wireName = r'$ProjectCandidateRequest';

  @override
  Object serialize(
    Serializers serializers,
    $ProjectCandidateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(ProjectCandidateRequest))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectCandidateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'candidate_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.candidateId = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        case r'selections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectSpecificationSelection)]),
          ) as BuiltList<ProjectSpecificationSelection>?;
          if (valueDes == null) continue;
          result.selections.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectCandidateRequestFulfillmentMethodEnum),
          ) as ProjectCandidateRequestFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectCandidateRequestPaymentMethodEnum),
          ) as ProjectCandidateRequestPaymentMethodEnum?;
          if (valueDes == null) continue;
          result.paymentMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $ProjectCandidateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $ProjectCandidateRequestBuilder();
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

/// The Buyer's method for a Vendor whose candidate lists more than one `fulfillment_options` entry (Both packages). Required then, or the request is rejected with FULFILLMENT_CHOICE_REQUIRED; a method the Vendor does not offer is rejected with FULFILLMENT_NOT_OFFERED.
class ProjectCandidateRequestFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectCandidateRequestFulfillmentMethodEnum PICKUP = _$projectCandidateRequestFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectCandidateRequestFulfillmentMethodEnum DELIVERY = _$projectCandidateRequestFulfillmentMethodEnum_DELIVERY;

  static Serializer<ProjectCandidateRequestFulfillmentMethodEnum> get serializer => _$projectCandidateRequestFulfillmentMethodEnumSerializer;

  const ProjectCandidateRequestFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectCandidateRequestFulfillmentMethodEnum> get values => _$projectCandidateRequestFulfillmentMethodEnumValues;
  static ProjectCandidateRequestFulfillmentMethodEnum valueOf(String name) => _$projectCandidateRequestFulfillmentMethodEnumValueOf(name);
}

/// Required for direct selection; explicitly chosen in the checklist and revalidated against current Vendor and fulfillment rules. Inquiry may omit it.
class ProjectCandidateRequestPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const ProjectCandidateRequestPaymentMethodEnum ONLINE = _$projectCandidateRequestPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const ProjectCandidateRequestPaymentMethodEnum CASH_ON_DELIVERY = _$projectCandidateRequestPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const ProjectCandidateRequestPaymentMethodEnum IN_STORE = _$projectCandidateRequestPaymentMethodEnum_IN_STORE;

  static Serializer<ProjectCandidateRequestPaymentMethodEnum> get serializer => _$projectCandidateRequestPaymentMethodEnumSerializer;

  const ProjectCandidateRequestPaymentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectCandidateRequestPaymentMethodEnum> get values => _$projectCandidateRequestPaymentMethodEnumValues;
  static ProjectCandidateRequestPaymentMethodEnum valueOf(String name) => _$projectCandidateRequestPaymentMethodEnumValueOf(name);
}

