//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fulfillment_proof.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_step.g.dart';

/// FulfillmentStep
///
/// Properties:
/// * [key]
/// * [label]
/// * [status]
/// * [at]
/// * [actorRole]
/// * [proofRequired]
/// * [proof]
/// * [proofRequirements]
@BuiltValue()
abstract class FulfillmentStep implements Built<FulfillmentStep, FulfillmentStepBuilder> {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'status')
  FulfillmentStepStatusEnum get status;
  // enum statusEnum {  COMPLETE,  CURRENT,  UPCOMING,  };

  @BuiltValueField(wireName: r'at')
  DateTime? get at;

  @BuiltValueField(wireName: r'actor_role')
  String? get actorRole;

  @BuiltValueField(wireName: r'proof_required')
  bool get proofRequired;

  @BuiltValueField(wireName: r'proof')
  FulfillmentProof? get proof;

  @BuiltValueField(wireName: r'proof_requirements')
  BuiltList<FulfillmentStepProofRequirementsEnum> get proofRequirements;
  // enum proofRequirementsEnum {  DELIVERY_PHOTO,  RECEIVER_NAME,  SIGNATURE_OPTIONAL,  HANDOVER_CONFIRMATION,  RECEIVER_TYPE,  };

  FulfillmentStep._();

  factory FulfillmentStep([void updates(FulfillmentStepBuilder b)]) = _$FulfillmentStep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentStepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentStep> get serializer => _$FulfillmentStepSerializer();
}

class _$FulfillmentStepSerializer implements PrimitiveSerializer<FulfillmentStep> {
  @override
  final Iterable<Type> types = const [FulfillmentStep, _$FulfillmentStep];

  @override
  final String wireName = r'FulfillmentStep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentStep object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FulfillmentStepStatusEnum),
    );
    if (object.at != null) {
      yield r'at';
      yield serializers.serialize(
        object.at,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.actorRole != null) {
      yield r'actor_role';
      yield serializers.serialize(
        object.actorRole,
        specifiedType: const FullType(String),
      );
    }
    yield r'proof_required';
    yield serializers.serialize(
      object.proofRequired,
      specifiedType: const FullType(bool),
    );
    if (object.proof != null) {
      yield r'proof';
      yield serializers.serialize(
        object.proof,
        specifiedType: const FullType.nullable(FulfillmentProof),
      );
    }
    yield r'proof_requirements';
    yield serializers.serialize(
      object.proofRequirements,
      specifiedType: const FullType(BuiltList, [FullType(FulfillmentStepProofRequirementsEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentStep object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentStepBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentStepStatusEnum),
          ) as FulfillmentStepStatusEnum;
          result.status = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.at = valueDes;
          break;
        case r'actor_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actorRole = valueDes;
          break;
        case r'proof_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.proofRequired = valueDes;
          break;
        case r'proof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentProof),
          ) as FulfillmentProof?;
          if (valueDes == null) continue;
          result.proof.replace(valueDes);
          break;
        case r'proof_requirements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FulfillmentStepProofRequirementsEnum)]),
          ) as BuiltList<FulfillmentStepProofRequirementsEnum>;
          result.proofRequirements.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentStep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentStepBuilder();
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


class FulfillmentStepStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPLETE')
  static const FulfillmentStepStatusEnum COMPLETE = _$fulfillmentStepStatusEnum_COMPLETE;
  @BuiltValueEnumConst(wireName: r'CURRENT')
  static const FulfillmentStepStatusEnum CURRENT = _$fulfillmentStepStatusEnum_CURRENT;
  @BuiltValueEnumConst(wireName: r'UPCOMING')
  static const FulfillmentStepStatusEnum UPCOMING = _$fulfillmentStepStatusEnum_UPCOMING;

  static Serializer<FulfillmentStepStatusEnum> get serializer => _$fulfillmentStepStatusEnumSerializer;

  const FulfillmentStepStatusEnum._(String name): super(name);

  static BuiltSet<FulfillmentStepStatusEnum> get values => _$fulfillmentStepStatusEnumValues;
  static FulfillmentStepStatusEnum valueOf(String name) => _$fulfillmentStepStatusEnumValueOf(name);
}

class FulfillmentStepProofRequirementsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY_PHOTO')
  static const FulfillmentStepProofRequirementsEnum DELIVERY_PHOTO = _$fulfillmentStepProofRequirementsEnum_DELIVERY_PHOTO;
  @BuiltValueEnumConst(wireName: r'RECEIVER_NAME')
  static const FulfillmentStepProofRequirementsEnum RECEIVER_NAME = _$fulfillmentStepProofRequirementsEnum_RECEIVER_NAME;
  @BuiltValueEnumConst(wireName: r'SIGNATURE_OPTIONAL')
  static const FulfillmentStepProofRequirementsEnum SIGNATURE_OPTIONAL = _$fulfillmentStepProofRequirementsEnum_SIGNATURE_OPTIONAL;
  @BuiltValueEnumConst(wireName: r'HANDOVER_CONFIRMATION')
  static const FulfillmentStepProofRequirementsEnum HANDOVER_CONFIRMATION = _$fulfillmentStepProofRequirementsEnum_HANDOVER_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'RECEIVER_TYPE')
  static const FulfillmentStepProofRequirementsEnum RECEIVER_TYPE = _$fulfillmentStepProofRequirementsEnum_RECEIVER_TYPE;

  static Serializer<FulfillmentStepProofRequirementsEnum> get serializer => _$fulfillmentStepProofRequirementsEnumSerializer;

  const FulfillmentStepProofRequirementsEnum._(String name): super(name);

  static BuiltSet<FulfillmentStepProofRequirementsEnum> get values => _$fulfillmentStepProofRequirementsEnumValues;
  static FulfillmentStepProofRequirementsEnum valueOf(String name) => _$fulfillmentStepProofRequirementsEnumValueOf(name);
}

