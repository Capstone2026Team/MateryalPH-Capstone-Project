//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_proof.g.dart';

/// Proof attached to the Delivered or Picked up milestone. File paths are authorized, order-scoped API paths relative to /api/v1, never public URLs.
///
/// Properties:
/// * [milestone]
/// * [recordedAt]
/// * [receiverName]
/// * [receiverKind]
/// * [handoverConfirmed]
/// * [photoPath]
/// * [signaturePath]
/// * [vehicle]
@BuiltValue()
abstract class FulfillmentProof implements Built<FulfillmentProof, FulfillmentProofBuilder> {
  @BuiltValueField(wireName: r'milestone')
  FulfillmentProofMilestoneEnum get milestone;
  // enum milestoneEnum {  DELIVERED,  PICKED_UP,  };

  @BuiltValueField(wireName: r'recorded_at')
  DateTime? get recordedAt;

  @BuiltValueField(wireName: r'receiver_name')
  String? get receiverName;

  @BuiltValueField(wireName: r'receiver_kind')
  FulfillmentProofReceiverKindEnum? get receiverKind;
  // enum receiverKindEnum {  BUYER,  AUTHORIZED_RECEIVER,  };

  @BuiltValueField(wireName: r'handover_confirmed')
  bool get handoverConfirmed;

  @BuiltValueField(wireName: r'photo_path')
  String? get photoPath;

  @BuiltValueField(wireName: r'signature_path')
  String? get signaturePath;

  @BuiltValueField(wireName: r'vehicle')
  BuiltMap<String, JsonObject?>? get vehicle;

  FulfillmentProof._();

  factory FulfillmentProof([void updates(FulfillmentProofBuilder b)]) = _$FulfillmentProof;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentProofBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentProof> get serializer => _$FulfillmentProofSerializer();
}

class _$FulfillmentProofSerializer implements PrimitiveSerializer<FulfillmentProof> {
  @override
  final Iterable<Type> types = const [FulfillmentProof, _$FulfillmentProof];

  @override
  final String wireName = r'FulfillmentProof';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentProof object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'milestone';
    yield serializers.serialize(
      object.milestone,
      specifiedType: const FullType(FulfillmentProofMilestoneEnum),
    );
    if (object.recordedAt != null) {
      yield r'recorded_at';
      yield serializers.serialize(
        object.recordedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.receiverName != null) {
      yield r'receiver_name';
      yield serializers.serialize(
        object.receiverName,
        specifiedType: const FullType(String),
      );
    }
    if (object.receiverKind != null) {
      yield r'receiver_kind';
      yield serializers.serialize(
        object.receiverKind,
        specifiedType: const FullType(FulfillmentProofReceiverKindEnum),
      );
    }
    yield r'handover_confirmed';
    yield serializers.serialize(
      object.handoverConfirmed,
      specifiedType: const FullType(bool),
    );
    if (object.photoPath != null) {
      yield r'photo_path';
      yield serializers.serialize(
        object.photoPath,
        specifiedType: const FullType(String),
      );
    }
    if (object.signaturePath != null) {
      yield r'signature_path';
      yield serializers.serialize(
        object.signaturePath,
        specifiedType: const FullType(String),
      );
    }
    if (object.vehicle != null) {
      yield r'vehicle';
      yield serializers.serialize(
        object.vehicle,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentProof object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentProofBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'milestone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentProofMilestoneEnum),
          ) as FulfillmentProofMilestoneEnum;
          result.milestone = valueDes;
          break;
        case r'recorded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.recordedAt = valueDes;
          break;
        case r'receiver_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.receiverName = valueDes;
          break;
        case r'receiver_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentProofReceiverKindEnum),
          ) as FulfillmentProofReceiverKindEnum?;
          if (valueDes == null) continue;
          result.receiverKind = valueDes;
          break;
        case r'handover_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.handoverConfirmed = valueDes;
          break;
        case r'photo_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.photoPath = valueDes;
          break;
        case r'signature_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.signaturePath = valueDes;
          break;
        case r'vehicle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.vehicle.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentProof deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentProofBuilder();
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


class FulfillmentProofMilestoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERED')
  static const FulfillmentProofMilestoneEnum DELIVERED = _$fulfillmentProofMilestoneEnum_DELIVERED;
  @BuiltValueEnumConst(wireName: r'PICKED_UP')
  static const FulfillmentProofMilestoneEnum PICKED_UP = _$fulfillmentProofMilestoneEnum_PICKED_UP;

  static Serializer<FulfillmentProofMilestoneEnum> get serializer => _$fulfillmentProofMilestoneEnumSerializer;

  const FulfillmentProofMilestoneEnum._(String name): super(name);

  static BuiltSet<FulfillmentProofMilestoneEnum> get values => _$fulfillmentProofMilestoneEnumValues;
  static FulfillmentProofMilestoneEnum valueOf(String name) => _$fulfillmentProofMilestoneEnumValueOf(name);
}

class FulfillmentProofReceiverKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const FulfillmentProofReceiverKindEnum BUYER = _$fulfillmentProofReceiverKindEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'AUTHORIZED_RECEIVER')
  static const FulfillmentProofReceiverKindEnum AUTHORIZED_RECEIVER = _$fulfillmentProofReceiverKindEnum_AUTHORIZED_RECEIVER;

  static Serializer<FulfillmentProofReceiverKindEnum> get serializer => _$fulfillmentProofReceiverKindEnumSerializer;

  const FulfillmentProofReceiverKindEnum._(String name): super(name);

  static BuiltSet<FulfillmentProofReceiverKindEnum> get values => _$fulfillmentProofReceiverKindEnumValues;
  static FulfillmentProofReceiverKindEnum valueOf(String name) => _$fulfillmentProofReceiverKindEnumValueOf(name);
}

