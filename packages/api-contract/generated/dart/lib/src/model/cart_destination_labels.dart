//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_destination_labels.g.dart';

/// CartDestinationLabels
///
/// Properties:
/// * [intended]
/// * [vehicleEndpoint]
@BuiltValue()
abstract class CartDestinationLabels implements Built<CartDestinationLabels, CartDestinationLabelsBuilder> {
  @BuiltValueField(wireName: r'intended')
  String get intended;

  @BuiltValueField(wireName: r'vehicle_endpoint')
  String get vehicleEndpoint;

  CartDestinationLabels._();

  factory CartDestinationLabels([void updates(CartDestinationLabelsBuilder b)]) = _$CartDestinationLabels;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartDestinationLabelsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartDestinationLabels> get serializer => _$CartDestinationLabelsSerializer();
}

class _$CartDestinationLabelsSerializer implements PrimitiveSerializer<CartDestinationLabels> {
  @override
  final Iterable<Type> types = const [CartDestinationLabels, _$CartDestinationLabels];

  @override
  final String wireName = r'CartDestinationLabels';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartDestinationLabels object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'intended';
    yield serializers.serialize(
      object.intended,
      specifiedType: const FullType(String),
    );
    yield r'vehicle_endpoint';
    yield serializers.serialize(
      object.vehicleEndpoint,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartDestinationLabels object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartDestinationLabelsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'intended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.intended = valueDes;
          break;
        case r'vehicle_endpoint':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vehicleEndpoint = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartDestinationLabels deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartDestinationLabelsBuilder();
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


