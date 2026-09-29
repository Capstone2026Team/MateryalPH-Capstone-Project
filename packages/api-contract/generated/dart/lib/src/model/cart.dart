//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/cart_vendor_group.dart';
import 'package:materyalph_api_client/src/model/cart_summary.dart';
import 'package:materyalph_api_client/src/model/cart_line.dart';
import 'package:materyalph_api_client/src/model/cart_destination.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart.g.dart';

/// Cart
///
/// Properties:
/// * [id]
/// * [lockVersion]
/// * [currentAsOf]
/// * [destination]
/// * [groups]
/// * [savedForLater]
/// * [summary]
@BuiltValue()
abstract class Cart implements Built<Cart, CartBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'current_as_of')
  DateTime get currentAsOf;

  @BuiltValueField(wireName: r'destination')
  CartDestination get destination;

  @BuiltValueField(wireName: r'groups')
  BuiltList<CartVendorGroup> get groups;

  @BuiltValueField(wireName: r'saved_for_later')
  BuiltList<CartLine> get savedForLater;

  @BuiltValueField(wireName: r'summary')
  CartSummary get summary;

  Cart._();

  factory Cart([void updates(CartBuilder b)]) = _$Cart;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Cart> get serializer => _$CartSerializer();
}

class _$CartSerializer implements PrimitiveSerializer<Cart> {
  @override
  final Iterable<Type> types = const [Cart, _$Cart];

  @override
  final String wireName = r'Cart';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Cart object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'current_as_of';
    yield serializers.serialize(
      object.currentAsOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'destination';
    yield serializers.serialize(
      object.destination,
      specifiedType: const FullType(CartDestination),
    );
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType: const FullType(BuiltList, [FullType(CartVendorGroup)]),
    );
    yield r'saved_for_later';
    yield serializers.serialize(
      object.savedForLater,
      specifiedType: const FullType(BuiltList, [FullType(CartLine)]),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(CartSummary),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Cart object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartBuilder result,
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
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'current_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.currentAsOf = valueDes;
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartDestination),
          ) as CartDestination;
          result.destination.replace(valueDes);
          break;
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartVendorGroup)]),
          ) as BuiltList<CartVendorGroup>;
          result.groups.replace(valueDes);
          break;
        case r'saved_for_later':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CartLine)]),
          ) as BuiltList<CartLine>;
          result.savedForLater.replace(valueDes);
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartSummary),
          ) as CartSummary;
          result.summary.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Cart deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartBuilder();
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


