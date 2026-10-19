//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_profile_recent_orders_inner.g.dart';

/// DirectoryBuyerProfileRecentOrdersInner
///
/// Properties:
/// * [id]
/// * [reference]
/// * [orderState]
/// * [paymentState]
/// * [procurementType]
/// * [storeName]
/// * [createdAt]
@BuiltValue()
abstract class DirectoryBuyerProfileRecentOrdersInner implements Built<DirectoryBuyerProfileRecentOrdersInner, DirectoryBuyerProfileRecentOrdersInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'order_state')
  String get orderState;

  @BuiltValueField(wireName: r'payment_state')
  String get paymentState;

  @BuiltValueField(wireName: r'procurement_type')
  String get procurementType;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  DirectoryBuyerProfileRecentOrdersInner._();

  factory DirectoryBuyerProfileRecentOrdersInner([void updates(DirectoryBuyerProfileRecentOrdersInnerBuilder b)]) = _$DirectoryBuyerProfileRecentOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerProfileRecentOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerProfileRecentOrdersInner> get serializer => _$DirectoryBuyerProfileRecentOrdersInnerSerializer();
}

class _$DirectoryBuyerProfileRecentOrdersInnerSerializer implements PrimitiveSerializer<DirectoryBuyerProfileRecentOrdersInner> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerProfileRecentOrdersInner, _$DirectoryBuyerProfileRecentOrdersInner];

  @override
  final String wireName = r'DirectoryBuyerProfileRecentOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerProfileRecentOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'order_state';
    yield serializers.serialize(
      object.orderState,
      specifiedType: const FullType(String),
    );
    yield r'payment_state';
    yield serializers.serialize(
      object.paymentState,
      specifiedType: const FullType(String),
    );
    yield r'procurement_type';
    yield serializers.serialize(
      object.procurementType,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryBuyerProfileRecentOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerProfileRecentOrdersInnerBuilder result,
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
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'order_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderState = valueDes;
          break;
        case r'payment_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentState = valueDes;
          break;
        case r'procurement_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.procurementType = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryBuyerProfileRecentOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerProfileRecentOrdersInnerBuilder();
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


