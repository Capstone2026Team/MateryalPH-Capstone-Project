//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_commission_assessment.g.dart';

/// VendorCommissionAssessment
///
/// Properties:
/// * [id]
/// * [orderReference]
/// * [state]
/// * [commissionBasisCentavos]
/// * [commissionBasisPoints]
/// * [estimatedCentavos]
/// * [earnedCentavos]
/// * [creditedCentavos]
/// * [netCentavos]
/// * [disputeHold]
/// * [earnedAt]
@BuiltValue()
abstract class VendorCommissionAssessment implements Built<VendorCommissionAssessment, VendorCommissionAssessmentBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'state')
  VendorCommissionAssessmentStateEnum get state;
  // enum stateEnum {  ESTIMATED,  EARNED,  CANCELLED,  };

  @BuiltValueField(wireName: r'commission_basis_centavos')
  int get commissionBasisCentavos;

  @BuiltValueField(wireName: r'commission_basis_points')
  int get commissionBasisPoints;

  @BuiltValueField(wireName: r'estimated_centavos')
  int get estimatedCentavos;

  @BuiltValueField(wireName: r'earned_centavos')
  int get earnedCentavos;

  @BuiltValueField(wireName: r'credited_centavos')
  int get creditedCentavos;

  @BuiltValueField(wireName: r'net_centavos')
  int get netCentavos;

  @BuiltValueField(wireName: r'dispute_hold')
  bool get disputeHold;

  @BuiltValueField(wireName: r'earned_at')
  DateTime? get earnedAt;

  VendorCommissionAssessment._();

  factory VendorCommissionAssessment([void updates(VendorCommissionAssessmentBuilder b)]) = _$VendorCommissionAssessment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCommissionAssessmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCommissionAssessment> get serializer => _$VendorCommissionAssessmentSerializer();
}

class _$VendorCommissionAssessmentSerializer implements PrimitiveSerializer<VendorCommissionAssessment> {
  @override
  final Iterable<Type> types = const [VendorCommissionAssessment, _$VendorCommissionAssessment];

  @override
  final String wireName = r'VendorCommissionAssessment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCommissionAssessment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(VendorCommissionAssessmentStateEnum),
    );
    yield r'commission_basis_centavos';
    yield serializers.serialize(
      object.commissionBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'commission_basis_points';
    yield serializers.serialize(
      object.commissionBasisPoints,
      specifiedType: const FullType(int),
    );
    yield r'estimated_centavos';
    yield serializers.serialize(
      object.estimatedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'earned_centavos';
    yield serializers.serialize(
      object.earnedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'credited_centavos';
    yield serializers.serialize(
      object.creditedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'net_centavos';
    yield serializers.serialize(
      object.netCentavos,
      specifiedType: const FullType(int),
    );
    yield r'dispute_hold';
    yield serializers.serialize(
      object.disputeHold,
      specifiedType: const FullType(bool),
    );
    if (object.earnedAt != null) {
      yield r'earned_at';
      yield serializers.serialize(
        object.earnedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCommissionAssessment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCommissionAssessmentBuilder result,
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
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorCommissionAssessmentStateEnum),
          ) as VendorCommissionAssessmentStateEnum;
          result.state = valueDes;
          break;
        case r'commission_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionBasisCentavos = valueDes;
          break;
        case r'commission_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionBasisPoints = valueDes;
          break;
        case r'estimated_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedCentavos = valueDes;
          break;
        case r'earned_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earnedCentavos = valueDes;
          break;
        case r'credited_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.creditedCentavos = valueDes;
          break;
        case r'net_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netCentavos = valueDes;
          break;
        case r'dispute_hold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.disputeHold = valueDes;
          break;
        case r'earned_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.earnedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorCommissionAssessment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCommissionAssessmentBuilder();
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


class VendorCommissionAssessmentStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ESTIMATED')
  static const VendorCommissionAssessmentStateEnum ESTIMATED = _$vendorCommissionAssessmentStateEnum_ESTIMATED;
  @BuiltValueEnumConst(wireName: r'EARNED')
  static const VendorCommissionAssessmentStateEnum EARNED = _$vendorCommissionAssessmentStateEnum_EARNED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const VendorCommissionAssessmentStateEnum CANCELLED = _$vendorCommissionAssessmentStateEnum_CANCELLED;

  static Serializer<VendorCommissionAssessmentStateEnum> get serializer => _$vendorCommissionAssessmentStateEnumSerializer;

  const VendorCommissionAssessmentStateEnum._(String name): super(name);

  static BuiltSet<VendorCommissionAssessmentStateEnum> get values => _$vendorCommissionAssessmentStateEnumValues;
  static VendorCommissionAssessmentStateEnum valueOf(String name) => _$vendorCommissionAssessmentStateEnumValueOf(name);
}

