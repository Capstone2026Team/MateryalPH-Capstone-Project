//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_breakdown_online.g.dart';

/// VendorEarningsBreakdownOnline
///
/// Properties:
/// * [payments]
/// * [principalPaidCentavos]
/// * [refundedPrincipalCentavos]
@BuiltValue()
abstract class VendorEarningsBreakdownOnline implements Built<VendorEarningsBreakdownOnline, VendorEarningsBreakdownOnlineBuilder> {
  @BuiltValueField(wireName: r'payments')
  int get payments;

  @BuiltValueField(wireName: r'principal_paid_centavos')
  int get principalPaidCentavos;

  @BuiltValueField(wireName: r'refunded_principal_centavos')
  int get refundedPrincipalCentavos;

  VendorEarningsBreakdownOnline._();

  factory VendorEarningsBreakdownOnline([void updates(VendorEarningsBreakdownOnlineBuilder b)]) = _$VendorEarningsBreakdownOnline;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsBreakdownOnlineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsBreakdownOnline> get serializer => _$VendorEarningsBreakdownOnlineSerializer();
}

class _$VendorEarningsBreakdownOnlineSerializer implements PrimitiveSerializer<VendorEarningsBreakdownOnline> {
  @override
  final Iterable<Type> types = const [VendorEarningsBreakdownOnline, _$VendorEarningsBreakdownOnline];

  @override
  final String wireName = r'VendorEarningsBreakdownOnline';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsBreakdownOnline object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(int),
    );
    yield r'principal_paid_centavos';
    yield serializers.serialize(
      object.principalPaidCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refunded_principal_centavos';
    yield serializers.serialize(
      object.refundedPrincipalCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsBreakdownOnline object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsBreakdownOnlineBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.payments = valueDes;
          break;
        case r'principal_paid_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.principalPaidCentavos = valueDes;
          break;
        case r'refunded_principal_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundedPrincipalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsBreakdownOnline deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsBreakdownOnlineBuilder();
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


