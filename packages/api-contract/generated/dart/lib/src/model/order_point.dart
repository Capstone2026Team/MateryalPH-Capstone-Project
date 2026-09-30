//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_point.g.dart';

/// A labelled Buyer location. Coordinates are never returned.
///
/// Properties:
/// * [locationId]
/// * [label]
/// * [kind]
/// * [formattedAddress]
@BuiltValue()
abstract class OrderPoint implements Built<OrderPoint, OrderPointBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'kind')
  String? get kind;

  @BuiltValueField(wireName: r'formatted_address')
  String? get formattedAddress;

  OrderPoint._();

  factory OrderPoint([void updates(OrderPointBuilder b)]) = _$OrderPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderPoint> get serializer => _$OrderPointSerializer();
}

class _$OrderPointSerializer implements PrimitiveSerializer<OrderPoint> {
  @override
  final Iterable<Type> types = const [OrderPoint, _$OrderPoint];

  @override
  final String wireName = r'OrderPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location_id';
    yield object.locationId == null ? null : serializers.serialize(
      object.locationId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
    yield r'kind';
    yield object.kind == null ? null : serializers.serialize(
      object.kind,
      specifiedType: const FullType.nullable(String),
    );
    yield r'formatted_address';
    yield object.formattedAddress == null ? null : serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.kind = valueDes;
          break;
        case r'formatted_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formattedAddress = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderPointBuilder();
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


