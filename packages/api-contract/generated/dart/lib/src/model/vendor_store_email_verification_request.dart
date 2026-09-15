//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_store_email_verification_request.g.dart';

/// VendorStoreEmailVerificationRequest
///
/// Properties:
/// * [lockVersion]
/// * [email]
@BuiltValue()
abstract class VendorStoreEmailVerificationRequest implements Built<VendorStoreEmailVerificationRequest, VendorStoreEmailVerificationRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'email')
  String get email;

  VendorStoreEmailVerificationRequest._();

  factory VendorStoreEmailVerificationRequest([void updates(VendorStoreEmailVerificationRequestBuilder b)]) = _$VendorStoreEmailVerificationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorStoreEmailVerificationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorStoreEmailVerificationRequest> get serializer => _$VendorStoreEmailVerificationRequestSerializer();
}

class _$VendorStoreEmailVerificationRequestSerializer implements PrimitiveSerializer<VendorStoreEmailVerificationRequest> {
  @override
  final Iterable<Type> types = const [VendorStoreEmailVerificationRequest, _$VendorStoreEmailVerificationRequest];

  @override
  final String wireName = r'VendorStoreEmailVerificationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorStoreEmailVerificationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorStoreEmailVerificationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorStoreEmailVerificationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorStoreEmailVerificationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorStoreEmailVerificationRequestBuilder();
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


