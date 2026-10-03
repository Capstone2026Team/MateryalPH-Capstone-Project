//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_destination_update.g.dart';

/// CartDestinationUpdate
///
/// Properties:
/// * [lockVersion]
/// * [intendedLocationId]
/// * [heavyVehicleRestriction]
/// * [alternateDropOffLocationId]
/// * [accessInstructions]
@BuiltValue()
abstract class CartDestinationUpdate implements Built<CartDestinationUpdate, CartDestinationUpdateBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'intended_location_id')
  String? get intendedLocationId;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  CartDestinationUpdateHeavyVehicleRestrictionEnum get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  UNANSWERED,  NO,  YES,  };

  @BuiltValueField(wireName: r'alternate_drop_off_location_id')
  String? get alternateDropOffLocationId;

  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  CartDestinationUpdate._();

  factory CartDestinationUpdate([void updates(CartDestinationUpdateBuilder b)]) = _$CartDestinationUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartDestinationUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartDestinationUpdate> get serializer => _$CartDestinationUpdateSerializer();
}

class _$CartDestinationUpdateSerializer implements PrimitiveSerializer<CartDestinationUpdate> {
  @override
  final Iterable<Type> types = const [CartDestinationUpdate, _$CartDestinationUpdate];

  @override
  final String wireName = r'CartDestinationUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartDestinationUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'intended_location_id';
    yield object.intendedLocationId == null ? null : serializers.serialize(
      object.intendedLocationId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'heavy_vehicle_restriction';
    yield serializers.serialize(
      object.heavyVehicleRestriction,
      specifiedType: const FullType(CartDestinationUpdateHeavyVehicleRestrictionEnum),
    );
    if (object.alternateDropOffLocationId != null) {
      yield r'alternate_drop_off_location_id';
      yield serializers.serialize(
        object.alternateDropOffLocationId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.accessInstructions != null) {
      yield r'access_instructions';
      yield serializers.serialize(
        object.accessInstructions,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CartDestinationUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartDestinationUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'intended_location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.intendedLocationId = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartDestinationUpdateHeavyVehicleRestrictionEnum),
          ) as CartDestinationUpdateHeavyVehicleRestrictionEnum;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'alternate_drop_off_location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateDropOffLocationId = valueDes;
          break;
        case r'access_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessInstructions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartDestinationUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartDestinationUpdateBuilder();
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


class CartDestinationUpdateHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'UNANSWERED')
  static const CartDestinationUpdateHeavyVehicleRestrictionEnum UNANSWERED = _$cartDestinationUpdateHeavyVehicleRestrictionEnum_UNANSWERED;
  @BuiltValueEnumConst(wireName: r'NO')
  static const CartDestinationUpdateHeavyVehicleRestrictionEnum NO = _$cartDestinationUpdateHeavyVehicleRestrictionEnum_NO;
  @BuiltValueEnumConst(wireName: r'YES')
  static const CartDestinationUpdateHeavyVehicleRestrictionEnum YES = _$cartDestinationUpdateHeavyVehicleRestrictionEnum_YES;

  static Serializer<CartDestinationUpdateHeavyVehicleRestrictionEnum> get serializer => _$cartDestinationUpdateHeavyVehicleRestrictionEnumSerializer;

  const CartDestinationUpdateHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<CartDestinationUpdateHeavyVehicleRestrictionEnum> get values => _$cartDestinationUpdateHeavyVehicleRestrictionEnumValues;
  static CartDestinationUpdateHeavyVehicleRestrictionEnum valueOf(String name) => _$cartDestinationUpdateHeavyVehicleRestrictionEnumValueOf(name);
}

