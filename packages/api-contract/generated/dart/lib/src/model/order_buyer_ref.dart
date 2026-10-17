//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_buyer_ref.g.dart';

/// OrderBuyerRef
///
/// Properties:
/// * [displayName]
/// * [mobileE164] - Current Buyer phone for delivery coordination. Only Owner/Manager or current active assigned Fulfillment Staff on an accepted, open Site Delivery order receives it. Other roles and closed/pickup orders receive null.
/// * [avatarPath] - Authorized order-scoped API photo path with the Buyer profile version. Uses the same delivery-contact authorization as mobile_e164; never a public storage URL. Null when the Buyer has no photo or contact is unavailable.
@BuiltValue()
abstract class OrderBuyerRef implements Built<OrderBuyerRef, OrderBuyerRefBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  /// Current Buyer phone for delivery coordination. Only Owner/Manager or current active assigned Fulfillment Staff on an accepted, open Site Delivery order receives it. Other roles and closed/pickup orders receive null.
  @BuiltValueField(wireName: r'mobile_e164')
  String? get mobileE164;

  /// Authorized order-scoped API photo path with the Buyer profile version. Uses the same delivery-contact authorization as mobile_e164; never a public storage URL. Null when the Buyer has no photo or contact is unavailable.
  @BuiltValueField(wireName: r'avatar_path')
  String? get avatarPath;

  OrderBuyerRef._();

  factory OrderBuyerRef([void updates(OrderBuyerRefBuilder b)]) = _$OrderBuyerRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderBuyerRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderBuyerRef> get serializer => _$OrderBuyerRefSerializer();
}

class _$OrderBuyerRefSerializer implements PrimitiveSerializer<OrderBuyerRef> {
  @override
  final Iterable<Type> types = const [OrderBuyerRef, _$OrderBuyerRef];

  @override
  final String wireName = r'OrderBuyerRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderBuyerRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.mobileE164 != null) {
      yield r'mobile_e164';
      yield serializers.serialize(
        object.mobileE164,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.avatarPath != null) {
      yield r'avatar_path';
      yield serializers.serialize(
        object.avatarPath,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderBuyerRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderBuyerRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'mobile_e164':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mobileE164 = valueDes;
          break;
        case r'avatar_path':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarPath = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderBuyerRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderBuyerRefBuilder();
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


