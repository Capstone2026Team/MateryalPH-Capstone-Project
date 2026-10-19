//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_commission_summary.g.dart';

/// VendorCommissionSummary
///
/// Properties:
/// * [estimatedCentavos]
/// * [earnedCentavos]
/// * [creditedCentavos]
/// * [netEarnedCentavos]
/// * [unbilledCentavos]
/// * [draftCentavos]
/// * [outstandingCentavos]
/// * [overdueCentavos]
/// * [collectedCentavos]
/// * [refundedCentavos]
/// * [netCollectedCentavos]
@BuiltValue()
abstract class VendorCommissionSummary implements Built<VendorCommissionSummary, VendorCommissionSummaryBuilder> {
  @BuiltValueField(wireName: r'estimated_centavos')
  int get estimatedCentavos;

  @BuiltValueField(wireName: r'earned_centavos')
  int get earnedCentavos;

  @BuiltValueField(wireName: r'credited_centavos')
  int get creditedCentavos;

  @BuiltValueField(wireName: r'net_earned_centavos')
  int get netEarnedCentavos;

  @BuiltValueField(wireName: r'unbilled_centavos')
  int get unbilledCentavos;

  @BuiltValueField(wireName: r'draft_centavos')
  int get draftCentavos;

  @BuiltValueField(wireName: r'outstanding_centavos')
  int get outstandingCentavos;

  @BuiltValueField(wireName: r'overdue_centavos')
  int get overdueCentavos;

  @BuiltValueField(wireName: r'collected_centavos')
  int get collectedCentavos;

  @BuiltValueField(wireName: r'refunded_centavos')
  int get refundedCentavos;

  @BuiltValueField(wireName: r'net_collected_centavos')
  int get netCollectedCentavos;

  VendorCommissionSummary._();

  factory VendorCommissionSummary([void updates(VendorCommissionSummaryBuilder b)]) = _$VendorCommissionSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCommissionSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCommissionSummary> get serializer => _$VendorCommissionSummarySerializer();
}

class _$VendorCommissionSummarySerializer implements PrimitiveSerializer<VendorCommissionSummary> {
  @override
  final Iterable<Type> types = const [VendorCommissionSummary, _$VendorCommissionSummary];

  @override
  final String wireName = r'VendorCommissionSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCommissionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'net_earned_centavos';
    yield serializers.serialize(
      object.netEarnedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'unbilled_centavos';
    yield serializers.serialize(
      object.unbilledCentavos,
      specifiedType: const FullType(int),
    );
    yield r'draft_centavos';
    yield serializers.serialize(
      object.draftCentavos,
      specifiedType: const FullType(int),
    );
    yield r'outstanding_centavos';
    yield serializers.serialize(
      object.outstandingCentavos,
      specifiedType: const FullType(int),
    );
    yield r'overdue_centavos';
    yield serializers.serialize(
      object.overdueCentavos,
      specifiedType: const FullType(int),
    );
    yield r'collected_centavos';
    yield serializers.serialize(
      object.collectedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refunded_centavos';
    yield serializers.serialize(
      object.refundedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'net_collected_centavos';
    yield serializers.serialize(
      object.netCollectedCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCommissionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCommissionSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'net_earned_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netEarnedCentavos = valueDes;
          break;
        case r'unbilled_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unbilledCentavos = valueDes;
          break;
        case r'draft_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.draftCentavos = valueDes;
          break;
        case r'outstanding_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outstandingCentavos = valueDes;
          break;
        case r'overdue_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.overdueCentavos = valueDes;
          break;
        case r'collected_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.collectedCentavos = valueDes;
          break;
        case r'refunded_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundedCentavos = valueDes;
          break;
        case r'net_collected_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netCollectedCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorCommissionSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCommissionSummaryBuilder();
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


