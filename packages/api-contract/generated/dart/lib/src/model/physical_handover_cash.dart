//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'physical_handover_cash.g.dart';

/// Vendor views only. Cash the Buyer handed over at Delivered or Picked up, reported by a member who may not record cash (Fulfillment Staff), still waiting for an Owner, Store Manager or Store Staff confirmation. Null when nothing waits or for the Buyer.
///
/// Properties:
/// * [reportedCentavos]
/// * [confirmableCentavos] - The reported amount capped at the outstanding balance.
/// * [milestone]
/// * [reportedAt]
/// * [hasPhoto] - False means confirming needs an attached receipt.
@BuiltValue()
abstract class PhysicalHandoverCash implements Built<PhysicalHandoverCash, PhysicalHandoverCashBuilder> {
  @BuiltValueField(wireName: r'reported_centavos')
  int get reportedCentavos;

  /// The reported amount capped at the outstanding balance.
  @BuiltValueField(wireName: r'confirmable_centavos')
  int get confirmableCentavos;

  @BuiltValueField(wireName: r'milestone')
  PhysicalHandoverCashMilestoneEnum get milestone;
  // enum milestoneEnum {  DELIVERED,  PICKED_UP,  };

  @BuiltValueField(wireName: r'reported_at')
  DateTime get reportedAt;

  /// False means confirming needs an attached receipt.
  @BuiltValueField(wireName: r'has_photo')
  bool get hasPhoto;

  PhysicalHandoverCash._();

  factory PhysicalHandoverCash([void updates(PhysicalHandoverCashBuilder b)]) = _$PhysicalHandoverCash;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhysicalHandoverCashBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhysicalHandoverCash> get serializer => _$PhysicalHandoverCashSerializer();
}

class _$PhysicalHandoverCashSerializer implements PrimitiveSerializer<PhysicalHandoverCash> {
  @override
  final Iterable<Type> types = const [PhysicalHandoverCash, _$PhysicalHandoverCash];

  @override
  final String wireName = r'PhysicalHandoverCash';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhysicalHandoverCash object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reported_centavos';
    yield serializers.serialize(
      object.reportedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'confirmable_centavos';
    yield serializers.serialize(
      object.confirmableCentavos,
      specifiedType: const FullType(int),
    );
    yield r'milestone';
    yield serializers.serialize(
      object.milestone,
      specifiedType: const FullType(PhysicalHandoverCashMilestoneEnum),
    );
    yield r'reported_at';
    yield serializers.serialize(
      object.reportedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'has_photo';
    yield serializers.serialize(
      object.hasPhoto,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PhysicalHandoverCash object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PhysicalHandoverCashBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reported_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reportedCentavos = valueDes;
          break;
        case r'confirmable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.confirmableCentavos = valueDes;
          break;
        case r'milestone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PhysicalHandoverCashMilestoneEnum),
          ) as PhysicalHandoverCashMilestoneEnum;
          result.milestone = valueDes;
          break;
        case r'reported_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.reportedAt = valueDes;
          break;
        case r'has_photo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasPhoto = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PhysicalHandoverCash deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhysicalHandoverCashBuilder();
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


class PhysicalHandoverCashMilestoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERED')
  static const PhysicalHandoverCashMilestoneEnum DELIVERED = _$physicalHandoverCashMilestoneEnum_DELIVERED;
  @BuiltValueEnumConst(wireName: r'PICKED_UP')
  static const PhysicalHandoverCashMilestoneEnum PICKED_UP = _$physicalHandoverCashMilestoneEnum_PICKED_UP;

  static Serializer<PhysicalHandoverCashMilestoneEnum> get serializer => _$physicalHandoverCashMilestoneEnumSerializer;

  const PhysicalHandoverCashMilestoneEnum._(String name): super(name);

  static BuiltSet<PhysicalHandoverCashMilestoneEnum> get values => _$physicalHandoverCashMilestoneEnumValues;
  static PhysicalHandoverCashMilestoneEnum valueOf(String name) => _$physicalHandoverCashMilestoneEnumValueOf(name);
}

