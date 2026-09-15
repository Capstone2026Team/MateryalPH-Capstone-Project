//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_store_email_verification.g.dart';

/// VendorStoreEmailVerification
///
/// Properties:
/// * [email]
/// * [verifiedAt]
/// * [pendingEmail]
@BuiltValue()
abstract class VendorStoreEmailVerification implements Built<VendorStoreEmailVerification, VendorStoreEmailVerificationBuilder> {
  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'verified_at')
  String? get verifiedAt;

  @BuiltValueField(wireName: r'pending_email')
  String? get pendingEmail;

  VendorStoreEmailVerification._();

  factory VendorStoreEmailVerification([void updates(VendorStoreEmailVerificationBuilder b)]) = _$VendorStoreEmailVerification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorStoreEmailVerificationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorStoreEmailVerification> get serializer => _$VendorStoreEmailVerificationSerializer();
}

class _$VendorStoreEmailVerificationSerializer implements PrimitiveSerializer<VendorStoreEmailVerification> {
  @override
  final Iterable<Type> types = const [VendorStoreEmailVerification, _$VendorStoreEmailVerification];

  @override
  final String wireName = r'VendorStoreEmailVerification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorStoreEmailVerification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
    yield r'verified_at';
    yield object.verifiedAt == null ? null : serializers.serialize(
      object.verifiedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'pending_email';
    yield object.pendingEmail == null ? null : serializers.serialize(
      object.pendingEmail,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorStoreEmailVerification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorStoreEmailVerificationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'verified_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.verifiedAt = valueDes;
          break;
        case r'pending_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.pendingEmail = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorStoreEmailVerification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorStoreEmailVerificationBuilder();
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


