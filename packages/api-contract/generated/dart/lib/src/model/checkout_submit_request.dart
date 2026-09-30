//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_submit_request.g.dart';

/// CheckoutSubmitRequest
///
/// Properties:
/// * [cartLockVersion]
/// * [vendorIds]
/// * [splitConfirmed] - Required when fewer Vendor groups are submitted than the cart holds.
@BuiltValue()
abstract class CheckoutSubmitRequest implements Built<CheckoutSubmitRequest, CheckoutSubmitRequestBuilder> {
  @BuiltValueField(wireName: r'cart_lock_version')
  int get cartLockVersion;

  @BuiltValueField(wireName: r'vendor_ids')
  BuiltSet<String> get vendorIds;

  /// Required when fewer Vendor groups are submitted than the cart holds.
  @BuiltValueField(wireName: r'split_confirmed')
  bool? get splitConfirmed;

  CheckoutSubmitRequest._();

  factory CheckoutSubmitRequest([void updates(CheckoutSubmitRequestBuilder b)]) = _$CheckoutSubmitRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutSubmitRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutSubmitRequest> get serializer => _$CheckoutSubmitRequestSerializer();
}

class _$CheckoutSubmitRequestSerializer implements PrimitiveSerializer<CheckoutSubmitRequest> {
  @override
  final Iterable<Type> types = const [CheckoutSubmitRequest, _$CheckoutSubmitRequest];

  @override
  final String wireName = r'CheckoutSubmitRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutSubmitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cart_lock_version';
    yield serializers.serialize(
      object.cartLockVersion,
      specifiedType: const FullType(int),
    );
    yield r'vendor_ids';
    yield serializers.serialize(
      object.vendorIds,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
    if (object.splitConfirmed != null) {
      yield r'split_confirmed';
      yield serializers.serialize(
        object.splitConfirmed,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutSubmitRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutSubmitRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cart_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cartLockVersion = valueDes;
          break;
        case r'vendor_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.vendorIds.replace(valueDes);
          break;
        case r'split_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.splitConfirmed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutSubmitRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutSubmitRequestBuilder();
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


