//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_vendor_ref.g.dart';

/// OrderVendorRef
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class OrderVendorRef implements Built<OrderVendorRef, OrderVendorRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  OrderVendorRef._();

  factory OrderVendorRef([void updates(OrderVendorRefBuilder b)]) = _$OrderVendorRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderVendorRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderVendorRef> get serializer => _$OrderVendorRefSerializer();
}

class _$OrderVendorRefSerializer implements PrimitiveSerializer<OrderVendorRef> {
  @override
  final Iterable<Type> types = const [OrderVendorRef, _$OrderVendorRef];

  @override
  final String wireName = r'OrderVendorRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderVendorRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderVendorRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderVendorRefBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderVendorRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderVendorRefBuilder();
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


