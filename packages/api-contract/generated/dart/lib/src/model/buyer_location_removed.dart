//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_location_removed.g.dart';

/// BuyerLocationRemoved
///
/// Properties:
/// * [id]
/// * [removed]
@BuiltValue()
abstract class BuyerLocationRemoved implements Built<BuyerLocationRemoved, BuyerLocationRemovedBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'removed')
  bool get removed;

  BuyerLocationRemoved._();

  factory BuyerLocationRemoved([void updates(BuyerLocationRemovedBuilder b)]) = _$BuyerLocationRemoved;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerLocationRemovedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerLocationRemoved> get serializer => _$BuyerLocationRemovedSerializer();
}

class _$BuyerLocationRemovedSerializer implements PrimitiveSerializer<BuyerLocationRemoved> {
  @override
  final Iterable<Type> types = const [BuyerLocationRemoved, _$BuyerLocationRemoved];

  @override
  final String wireName = r'BuyerLocationRemoved';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerLocationRemoved object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'removed';
    yield serializers.serialize(
      object.removed,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerLocationRemoved object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerLocationRemovedBuilder result,
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
        case r'removed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.removed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerLocationRemoved deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerLocationRemovedBuilder();
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


