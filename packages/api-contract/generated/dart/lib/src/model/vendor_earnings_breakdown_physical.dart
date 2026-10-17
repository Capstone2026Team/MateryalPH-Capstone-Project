//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_breakdown_physical.g.dart';

/// VendorEarningsBreakdownPhysical
///
/// Properties:
/// * [records]
/// * [cashOnDeliveryCentavos]
/// * [inStoreCentavos]
@BuiltValue()
abstract class VendorEarningsBreakdownPhysical implements Built<VendorEarningsBreakdownPhysical, VendorEarningsBreakdownPhysicalBuilder> {
  @BuiltValueField(wireName: r'records')
  int get records;

  @BuiltValueField(wireName: r'cash_on_delivery_centavos')
  int get cashOnDeliveryCentavos;

  @BuiltValueField(wireName: r'in_store_centavos')
  int get inStoreCentavos;

  VendorEarningsBreakdownPhysical._();

  factory VendorEarningsBreakdownPhysical([void updates(VendorEarningsBreakdownPhysicalBuilder b)]) = _$VendorEarningsBreakdownPhysical;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsBreakdownPhysicalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsBreakdownPhysical> get serializer => _$VendorEarningsBreakdownPhysicalSerializer();
}

class _$VendorEarningsBreakdownPhysicalSerializer implements PrimitiveSerializer<VendorEarningsBreakdownPhysical> {
  @override
  final Iterable<Type> types = const [VendorEarningsBreakdownPhysical, _$VendorEarningsBreakdownPhysical];

  @override
  final String wireName = r'VendorEarningsBreakdownPhysical';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsBreakdownPhysical object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'records';
    yield serializers.serialize(
      object.records,
      specifiedType: const FullType(int),
    );
    yield r'cash_on_delivery_centavos';
    yield serializers.serialize(
      object.cashOnDeliveryCentavos,
      specifiedType: const FullType(int),
    );
    yield r'in_store_centavos';
    yield serializers.serialize(
      object.inStoreCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsBreakdownPhysical object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsBreakdownPhysicalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.records = valueDes;
          break;
        case r'cash_on_delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cashOnDeliveryCentavos = valueDes;
          break;
        case r'in_store_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inStoreCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsBreakdownPhysical deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsBreakdownPhysicalBuilder();
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


