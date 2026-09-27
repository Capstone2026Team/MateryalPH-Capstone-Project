//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_compliance_decision.g.dart';

/// ProductComplianceDecision
///
/// Properties:
/// * [decision]
/// * [lockVersion] - Lock version of the submission being decided; stale values are rejected.
/// * [reason] - Required for CHANGES_REQUIRED and REJECTED.
/// * [remarks]
/// * [sourceReference]
@BuiltValue()
abstract class ProductComplianceDecision implements Built<ProductComplianceDecision, ProductComplianceDecisionBuilder> {
  @BuiltValueField(wireName: r'decision')
  ProductComplianceDecisionDecisionEnum get decision;
  // enum decisionEnum {  APPROVED,  CHANGES_REQUIRED,  REJECTED,  };

  /// Lock version of the submission being decided; stale values are rejected.
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  /// Required for CHANGES_REQUIRED and REJECTED.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'remarks')
  String? get remarks;

  @BuiltValueField(wireName: r'source_reference')
  String? get sourceReference;

  ProductComplianceDecision._();

  factory ProductComplianceDecision([void updates(ProductComplianceDecisionBuilder b)]) = _$ProductComplianceDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductComplianceDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductComplianceDecision> get serializer => _$ProductComplianceDecisionSerializer();
}

class _$ProductComplianceDecisionSerializer implements PrimitiveSerializer<ProductComplianceDecision> {
  @override
  final Iterable<Type> types = const [ProductComplianceDecision, _$ProductComplianceDecision];

  @override
  final String wireName = r'ProductComplianceDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductComplianceDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(ProductComplianceDecisionDecisionEnum),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.remarks != null) {
      yield r'remarks';
      yield serializers.serialize(
        object.remarks,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.sourceReference != null) {
      yield r'source_reference';
      yield serializers.serialize(
        object.sourceReference,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductComplianceDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductComplianceDecisionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductComplianceDecisionDecisionEnum),
          ) as ProductComplianceDecisionDecisionEnum;
          result.decision = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'remarks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.remarks = valueDes;
          break;
        case r'source_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceReference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductComplianceDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductComplianceDecisionBuilder();
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


class ProductComplianceDecisionDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const ProductComplianceDecisionDecisionEnum APPROVED = _$productComplianceDecisionDecisionEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'CHANGES_REQUIRED')
  static const ProductComplianceDecisionDecisionEnum CHANGES_REQUIRED = _$productComplianceDecisionDecisionEnum_CHANGES_REQUIRED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ProductComplianceDecisionDecisionEnum REJECTED = _$productComplianceDecisionDecisionEnum_REJECTED;

  static Serializer<ProductComplianceDecisionDecisionEnum> get serializer => _$productComplianceDecisionDecisionEnumSerializer;

  const ProductComplianceDecisionDecisionEnum._(String name): super(name);

  static BuiltSet<ProductComplianceDecisionDecisionEnum> get values => _$productComplianceDecisionDecisionEnumValues;
  static ProductComplianceDecisionDecisionEnum valueOf(String name) => _$productComplianceDecisionDecisionEnumValueOf(name);
}

