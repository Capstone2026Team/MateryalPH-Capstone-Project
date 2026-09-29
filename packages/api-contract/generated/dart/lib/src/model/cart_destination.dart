//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cart_destination_labels.dart';
import 'package:materyalph_api_client/src/model/cart_location_ref.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_destination.g.dart';

/// CartDestination
///
/// Properties:
/// * [intended]
/// * [heavyVehicleRestriction]
/// * [alternateDropOff]
/// * [vehicleEndpoint]
/// * [accessInstructions] - The Buyer's own site instructions; shared with a Vendor only once an order requires them.
/// * [labels]
@BuiltValue()
abstract class CartDestination implements Built<CartDestination, CartDestinationBuilder> {
  @BuiltValueField(wireName: r'intended')
  CartLocationRef? get intended;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  CartDestinationHeavyVehicleRestrictionEnum get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  UNANSWERED,  NO,  YES,  };

  @BuiltValueField(wireName: r'alternate_drop_off')
  CartLocationRef? get alternateDropOff;

  @BuiltValueField(wireName: r'vehicle_endpoint')
  CartDestinationVehicleEndpointEnum? get vehicleEndpoint;
  // enum vehicleEndpointEnum {  INTENDED_LOCATION,  ALTERNATE_DROP_OFF,  ,  };

  /// The Buyer's own site instructions; shared with a Vendor only once an order requires them.
  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  @BuiltValueField(wireName: r'labels')
  CartDestinationLabels get labels;

  CartDestination._();

  factory CartDestination([void updates(CartDestinationBuilder b)]) = _$CartDestination;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartDestinationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartDestination> get serializer => _$CartDestinationSerializer();
}

class _$CartDestinationSerializer implements PrimitiveSerializer<CartDestination> {
  @override
  final Iterable<Type> types = const [CartDestination, _$CartDestination];

  @override
  final String wireName = r'CartDestination';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartDestination object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'intended';
    yield object.intended == null ? null : serializers.serialize(
      object.intended,
      specifiedType: const FullType.nullable(CartLocationRef),
    );
    yield r'heavy_vehicle_restriction';
    yield serializers.serialize(
      object.heavyVehicleRestriction,
      specifiedType: const FullType(CartDestinationHeavyVehicleRestrictionEnum),
    );
    yield r'alternate_drop_off';
    yield object.alternateDropOff == null ? null : serializers.serialize(
      object.alternateDropOff,
      specifiedType: const FullType.nullable(CartLocationRef),
    );
    yield r'vehicle_endpoint';
    yield object.vehicleEndpoint == null ? null : serializers.serialize(
      object.vehicleEndpoint,
      specifiedType: const FullType.nullable(CartDestinationVehicleEndpointEnum),
    );
    yield r'access_instructions';
    yield object.accessInstructions == null ? null : serializers.serialize(
      object.accessInstructions,
      specifiedType: const FullType.nullable(String),
    );
    yield r'labels';
    yield serializers.serialize(
      object.labels,
      specifiedType: const FullType(CartDestinationLabels),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartDestination object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartDestinationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'intended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartLocationRef),
          ) as CartLocationRef?;
          if (valueDes == null) continue;
          result.intended.replace(valueDes);
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartDestinationHeavyVehicleRestrictionEnum),
          ) as CartDestinationHeavyVehicleRestrictionEnum;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'alternate_drop_off':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartLocationRef),
          ) as CartLocationRef?;
          if (valueDes == null) continue;
          result.alternateDropOff.replace(valueDes);
          break;
        case r'vehicle_endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CartDestinationVehicleEndpointEnum),
          ) as CartDestinationVehicleEndpointEnum?;
          if (valueDes == null) continue;
          result.vehicleEndpoint = valueDes;
          break;
        case r'access_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessInstructions = valueDes;
          break;
        case r'labels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartDestinationLabels),
          ) as CartDestinationLabels;
          result.labels.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartDestination deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartDestinationBuilder();
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


class CartDestinationHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNANSWERED')
  static const CartDestinationHeavyVehicleRestrictionEnum UNANSWERED = _$cartDestinationHeavyVehicleRestrictionEnum_UNANSWERED;
  @BuiltValueEnumConst(wireName: r'NO')
  static const CartDestinationHeavyVehicleRestrictionEnum NO = _$cartDestinationHeavyVehicleRestrictionEnum_NO;
  @BuiltValueEnumConst(wireName: r'YES')
  static const CartDestinationHeavyVehicleRestrictionEnum YES = _$cartDestinationHeavyVehicleRestrictionEnum_YES;

  static Serializer<CartDestinationHeavyVehicleRestrictionEnum> get serializer => _$cartDestinationHeavyVehicleRestrictionEnumSerializer;

  const CartDestinationHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<CartDestinationHeavyVehicleRestrictionEnum> get values => _$cartDestinationHeavyVehicleRestrictionEnumValues;
  static CartDestinationHeavyVehicleRestrictionEnum valueOf(String name) => _$cartDestinationHeavyVehicleRestrictionEnumValueOf(name);
}

class CartDestinationVehicleEndpointEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INTENDED_LOCATION')
  static const CartDestinationVehicleEndpointEnum INTENDED_LOCATION = _$cartDestinationVehicleEndpointEnum_INTENDED_LOCATION;
  @BuiltValueEnumConst(wireName: r'ALTERNATE_DROP_OFF')
  static const CartDestinationVehicleEndpointEnum ALTERNATE_DROP_OFF = _$cartDestinationVehicleEndpointEnum_ALTERNATE_DROP_OFF;

  static Serializer<CartDestinationVehicleEndpointEnum> get serializer => _$cartDestinationVehicleEndpointEnumSerializer;

  const CartDestinationVehicleEndpointEnum._(String name): super(name);

  static BuiltSet<CartDestinationVehicleEndpointEnum> get values => _$cartDestinationVehicleEndpointEnumValues;
  static CartDestinationVehicleEndpointEnum valueOf(String name) => _$cartDestinationVehicleEndpointEnumValueOf(name);
}

