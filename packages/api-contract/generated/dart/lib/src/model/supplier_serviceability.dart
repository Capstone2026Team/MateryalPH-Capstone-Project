//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'supplier_serviceability.g.dart';

/// Advisory straight-line comparison with the Vendor's stated delivery distance; actual serviceability is revalidated at checkout.
///
/// Properties:
/// * [pickupAvailable]
/// * [delivery]
/// * [deliveryMaximumKm]
/// * [basis]
@BuiltValue()
abstract class SupplierServiceability implements Built<SupplierServiceability, SupplierServiceabilityBuilder> {
  @BuiltValueField(wireName: r'pickup_available')
  bool get pickupAvailable;

  @BuiltValueField(wireName: r'delivery')
  SupplierServiceabilityDeliveryEnum get delivery;
  // enum deliveryEnum {  WITHIN_STATED_AREA,  OUTSIDE_STATED_AREA,  NOT_OFFERED,  };

  @BuiltValueField(wireName: r'delivery_maximum_km')
  int? get deliveryMaximumKm;

  @BuiltValueField(wireName: r'basis')
  SupplierServiceabilityBasisEnum get basis;
  // enum basisEnum {  STRAIGHT_LINE_ADVISORY,  };

  SupplierServiceability._();

  factory SupplierServiceability([void updates(SupplierServiceabilityBuilder b)]) = _$SupplierServiceability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupplierServiceabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupplierServiceability> get serializer => _$SupplierServiceabilitySerializer();
}

class _$SupplierServiceabilitySerializer implements PrimitiveSerializer<SupplierServiceability> {
  @override
  final Iterable<Type> types = const [SupplierServiceability, _$SupplierServiceability];

  @override
  final String wireName = r'SupplierServiceability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupplierServiceability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pickup_available';
    yield serializers.serialize(
      object.pickupAvailable,
      specifiedType: const FullType(bool),
    );
    yield r'delivery';
    yield serializers.serialize(
      object.delivery,
      specifiedType: const FullType(SupplierServiceabilityDeliveryEnum),
    );
    yield r'delivery_maximum_km';
    yield object.deliveryMaximumKm == null ? null : serializers.serialize(
      object.deliveryMaximumKm,
      specifiedType: const FullType.nullable(int),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(SupplierServiceabilityBasisEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SupplierServiceability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupplierServiceabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pickup_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pickupAvailable = valueDes;
          break;
        case r'delivery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierServiceabilityDeliveryEnum),
          ) as SupplierServiceabilityDeliveryEnum;
          result.delivery = valueDes;
          break;
        case r'delivery_maximum_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.deliveryMaximumKm = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierServiceabilityBasisEnum),
          ) as SupplierServiceabilityBasisEnum;
          result.basis = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupplierServiceability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupplierServiceabilityBuilder();
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


class SupplierServiceabilityDeliveryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WITHIN_STATED_AREA')
  static const SupplierServiceabilityDeliveryEnum WITHIN_STATED_AREA = _$supplierServiceabilityDeliveryEnum_WITHIN_STATED_AREA;
  @BuiltValueEnumConst(wireName: r'OUTSIDE_STATED_AREA')
  static const SupplierServiceabilityDeliveryEnum OUTSIDE_STATED_AREA = _$supplierServiceabilityDeliveryEnum_OUTSIDE_STATED_AREA;
  @BuiltValueEnumConst(wireName: r'NOT_OFFERED')
  static const SupplierServiceabilityDeliveryEnum NOT_OFFERED = _$supplierServiceabilityDeliveryEnum_NOT_OFFERED;

  static Serializer<SupplierServiceabilityDeliveryEnum> get serializer => _$supplierServiceabilityDeliveryEnumSerializer;

  const SupplierServiceabilityDeliveryEnum._(String name): super(name);

  static BuiltSet<SupplierServiceabilityDeliveryEnum> get values => _$supplierServiceabilityDeliveryEnumValues;
  static SupplierServiceabilityDeliveryEnum valueOf(String name) => _$supplierServiceabilityDeliveryEnumValueOf(name);
}

class SupplierServiceabilityBasisEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STRAIGHT_LINE_ADVISORY')
  static const SupplierServiceabilityBasisEnum STRAIGHT_LINE_ADVISORY = _$supplierServiceabilityBasisEnum_STRAIGHT_LINE_ADVISORY;

  static Serializer<SupplierServiceabilityBasisEnum> get serializer => _$supplierServiceabilityBasisEnumSerializer;

  const SupplierServiceabilityBasisEnum._(String name): super(name);

  static BuiltSet<SupplierServiceabilityBasisEnum> get values => _$supplierServiceabilityBasisEnumValues;
  static SupplierServiceabilityBasisEnum valueOf(String name) => _$supplierServiceabilityBasisEnumValueOf(name);
}

