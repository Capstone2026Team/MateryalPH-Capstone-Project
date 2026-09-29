//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_vendor_ref.g.dart';

/// CartVendorRef
///
/// Properties:
/// * [id]
/// * [name]
/// * [vacationMode]
@BuiltValue()
abstract class CartVendorRef implements Built<CartVendorRef, CartVendorRefBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'vacation_mode')
  bool get vacationMode;

  CartVendorRef._();

  factory CartVendorRef([void updates(CartVendorRefBuilder b)]) = _$CartVendorRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartVendorRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartVendorRef> get serializer => _$CartVendorRefSerializer();
}

class _$CartVendorRefSerializer implements PrimitiveSerializer<CartVendorRef> {
  @override
  final Iterable<Type> types = const [CartVendorRef, _$CartVendorRef];

  @override
  final String wireName = r'CartVendorRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartVendorRef object, {
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
    yield r'vacation_mode';
    yield serializers.serialize(
      object.vacationMode,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartVendorRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartVendorRefBuilder result,
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
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vacationMode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartVendorRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartVendorRefBuilder();
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


