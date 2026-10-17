//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_vendor_permissions.g.dart';

/// DisputeVendorPermissions
///
/// Properties:
/// * [canRespond]
/// * [canOfferRefund]
@BuiltValue()
abstract class DisputeVendorPermissions implements Built<DisputeVendorPermissions, DisputeVendorPermissionsBuilder> {
  @BuiltValueField(wireName: r'can_respond')
  bool get canRespond;

  @BuiltValueField(wireName: r'can_offer_refund')
  bool get canOfferRefund;

  DisputeVendorPermissions._();

  factory DisputeVendorPermissions([void updates(DisputeVendorPermissionsBuilder b)]) = _$DisputeVendorPermissions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeVendorPermissionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeVendorPermissions> get serializer => _$DisputeVendorPermissionsSerializer();
}

class _$DisputeVendorPermissionsSerializer implements PrimitiveSerializer<DisputeVendorPermissions> {
  @override
  final Iterable<Type> types = const [DisputeVendorPermissions, _$DisputeVendorPermissions];

  @override
  final String wireName = r'DisputeVendorPermissions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeVendorPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_respond';
    yield serializers.serialize(
      object.canRespond,
      specifiedType: const FullType(bool),
    );
    yield r'can_offer_refund';
    yield serializers.serialize(
      object.canOfferRefund,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeVendorPermissions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeVendorPermissionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_respond':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canRespond = valueDes;
          break;
        case r'can_offer_refund':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canOfferRefund = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeVendorPermissions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeVendorPermissionsBuilder();
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


