//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cart_location_ref.g.dart';

/// CartLocationRef
///
/// Properties:
/// * [locationId]
/// * [label]
/// * [kind]
/// * [formattedAddress]
/// * [status] - UNAVAILABLE when removed; it is never replaced automatically.
@BuiltValue()
abstract class CartLocationRef implements Built<CartLocationRef, CartLocationRefBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String get locationId;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'formatted_address')
  String? get formattedAddress;

  /// UNAVAILABLE when removed; it is never replaced automatically.
  @BuiltValueField(wireName: r'status')
  CartLocationRefStatusEnum get status;
  // enum statusEnum {  ACTIVE,  UNAVAILABLE,  };

  CartLocationRef._();

  factory CartLocationRef([void updates(CartLocationRefBuilder b)]) = _$CartLocationRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CartLocationRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CartLocationRef> get serializer => _$CartLocationRefSerializer();
}

class _$CartLocationRefSerializer implements PrimitiveSerializer<CartLocationRef> {
  @override
  final Iterable<Type> types = const [CartLocationRef, _$CartLocationRef];

  @override
  final String wireName = r'CartLocationRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CartLocationRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location_id';
    yield serializers.serialize(
      object.locationId,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'formatted_address';
    yield object.formattedAddress == null ? null : serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CartLocationRefStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CartLocationRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CartLocationRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(String),
          ) as String;
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartLocationRefStatusEnum),
          ) as CartLocationRefStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CartLocationRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CartLocationRefBuilder();
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


/// UNAVAILABLE when removed; it is never replaced automatically.
class CartLocationRefStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const CartLocationRefStatusEnum ACTIVE = _$cartLocationRefStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const CartLocationRefStatusEnum UNAVAILABLE = _$cartLocationRefStatusEnum_UNAVAILABLE;

  static Serializer<CartLocationRefStatusEnum> get serializer => _$cartLocationRefStatusEnumSerializer;

  const CartLocationRefStatusEnum._(String name): super(name);

  static BuiltSet<CartLocationRefStatusEnum> get values => _$cartLocationRefStatusEnumValues;
  static CartLocationRefStatusEnum valueOf(String name) => _$cartLocationRefStatusEnumValueOf(name);
}

