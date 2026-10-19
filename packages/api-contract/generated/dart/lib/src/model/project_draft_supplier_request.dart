//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_draft_supplier_request.g.dart';

/// ProjectDraftSupplierRequest
///
/// Properties:
/// * [lockVersion]
/// * [paymentMethod]
/// * [draftFingerprint]
/// * [budgetOverrideReason]
@BuiltValue()
abstract class ProjectDraftSupplierRequest implements Built<ProjectDraftSupplierRequest, ProjectDraftSupplierRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'payment_method')
  ProjectDraftSupplierRequestPaymentMethodEnum get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  @BuiltValueField(wireName: r'draft_fingerprint')
  String get draftFingerprint;

  @BuiltValueField(wireName: r'budget_override_reason')
  String? get budgetOverrideReason;

  ProjectDraftSupplierRequest._();

  factory ProjectDraftSupplierRequest([void updates(ProjectDraftSupplierRequestBuilder b)]) = _$ProjectDraftSupplierRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectDraftSupplierRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectDraftSupplierRequest> get serializer => _$ProjectDraftSupplierRequestSerializer();
}

class _$ProjectDraftSupplierRequestSerializer implements PrimitiveSerializer<ProjectDraftSupplierRequest> {
  @override
  final Iterable<Type> types = const [ProjectDraftSupplierRequest, _$ProjectDraftSupplierRequest];

  @override
  final String wireName = r'ProjectDraftSupplierRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectDraftSupplierRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(ProjectDraftSupplierRequestPaymentMethodEnum),
    );
    yield r'draft_fingerprint';
    yield serializers.serialize(
      object.draftFingerprint,
      specifiedType: const FullType(String),
    );
    if (object.budgetOverrideReason != null) {
      yield r'budget_override_reason';
      yield serializers.serialize(
        object.budgetOverrideReason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectDraftSupplierRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectDraftSupplierRequestBuilder result,
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
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectDraftSupplierRequestPaymentMethodEnum),
          ) as ProjectDraftSupplierRequestPaymentMethodEnum;
          result.paymentMethod = valueDes;
          break;
        case r'draft_fingerprint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.draftFingerprint = valueDes;
          break;
        case r'budget_override_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.budgetOverrideReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectDraftSupplierRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectDraftSupplierRequestBuilder();
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


class ProjectDraftSupplierRequestPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const ProjectDraftSupplierRequestPaymentMethodEnum ONLINE = _$projectDraftSupplierRequestPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const ProjectDraftSupplierRequestPaymentMethodEnum CASH_ON_DELIVERY = _$projectDraftSupplierRequestPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const ProjectDraftSupplierRequestPaymentMethodEnum IN_STORE = _$projectDraftSupplierRequestPaymentMethodEnum_IN_STORE;

  static Serializer<ProjectDraftSupplierRequestPaymentMethodEnum> get serializer => _$projectDraftSupplierRequestPaymentMethodEnumSerializer;

  const ProjectDraftSupplierRequestPaymentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectDraftSupplierRequestPaymentMethodEnum> get values => _$projectDraftSupplierRequestPaymentMethodEnumValues;
  static ProjectDraftSupplierRequestPaymentMethodEnum valueOf(String name) => _$projectDraftSupplierRequestPaymentMethodEnumValueOf(name);
}

