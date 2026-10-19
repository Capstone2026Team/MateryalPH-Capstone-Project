//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/project_candidate_request.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_specification_selection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_vendor_selection_request.g.dart';

/// ProjectVendorSelectionRequest
///
/// Properties:
/// * [lockVersion]
/// * [candidateId]
/// * [note]
/// * [budgetOverrideReason]
/// * [selections] - The Buyer's specification choice for each line whose `selection_required` is true. Selection and inquiry are rejected with SPECIFICATION_SELECTION_REQUIRED until every such line has one.
/// * [fulfillmentMethod] - The Buyer's method for a Vendor whose candidate lists more than one `fulfillment_options` entry (Both packages). Required then, or the request is rejected with FULFILLMENT_CHOICE_REQUIRED; a method the Vendor does not offer is rejected with FULFILLMENT_NOT_OFFERED.
/// * [paymentMethod]
@BuiltValue()
abstract class ProjectVendorSelectionRequest implements ProjectCandidateRequest, Built<ProjectVendorSelectionRequest, ProjectVendorSelectionRequestBuilder> {
  ProjectVendorSelectionRequest._();

  factory ProjectVendorSelectionRequest([void updates(ProjectVendorSelectionRequestBuilder b)]) = _$ProjectVendorSelectionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectVendorSelectionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectVendorSelectionRequest> get serializer => _$ProjectVendorSelectionRequestSerializer();
}

class _$ProjectVendorSelectionRequestSerializer implements PrimitiveSerializer<ProjectVendorSelectionRequest> {
  @override
  final Iterable<Type> types = const [ProjectVendorSelectionRequest, _$ProjectVendorSelectionRequest];

  @override
  final String wireName = r'ProjectVendorSelectionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectVendorSelectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
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
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
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
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'candidate_id';
    yield serializers.serialize(
      object.candidateId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectVendorSelectionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectVendorSelectionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'selections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectSpecificationSelection)]),
          ) as BuiltList<ProjectSpecificationSelection>?;
          if (valueDes == null) continue;
          result.selections.replace(valueDes);
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
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
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        case r'candidate_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.candidateId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectVendorSelectionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectVendorSelectionRequestBuilder();
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
class ProjectVendorSelectionRequestFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectVendorSelectionRequestFulfillmentMethodEnum PICKUP = _$projectVendorSelectionRequestFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectVendorSelectionRequestFulfillmentMethodEnum DELIVERY = _$projectVendorSelectionRequestFulfillmentMethodEnum_DELIVERY;

  static Serializer<ProjectVendorSelectionRequestFulfillmentMethodEnum> get serializer => _$projectVendorSelectionRequestFulfillmentMethodEnumSerializer;

  const ProjectVendorSelectionRequestFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectVendorSelectionRequestFulfillmentMethodEnum> get values => _$projectVendorSelectionRequestFulfillmentMethodEnumValues;
  static ProjectVendorSelectionRequestFulfillmentMethodEnum valueOf(String name) => _$projectVendorSelectionRequestFulfillmentMethodEnumValueOf(name);
}

class ProjectVendorSelectionRequestPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const ProjectVendorSelectionRequestPaymentMethodEnum ONLINE = _$projectVendorSelectionRequestPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const ProjectVendorSelectionRequestPaymentMethodEnum CASH_ON_DELIVERY = _$projectVendorSelectionRequestPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const ProjectVendorSelectionRequestPaymentMethodEnum IN_STORE = _$projectVendorSelectionRequestPaymentMethodEnum_IN_STORE;

  static Serializer<ProjectVendorSelectionRequestPaymentMethodEnum> get serializer => _$projectVendorSelectionRequestPaymentMethodEnumSerializer;

  const ProjectVendorSelectionRequestPaymentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectVendorSelectionRequestPaymentMethodEnum> get values => _$projectVendorSelectionRequestPaymentMethodEnumValues;
  static ProjectVendorSelectionRequestPaymentMethodEnum valueOf(String name) => _$projectVendorSelectionRequestPaymentMethodEnumValueOf(name);
}

