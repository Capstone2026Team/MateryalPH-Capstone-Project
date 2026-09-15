//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_store_email_verification_confirmation.g.dart';

/// VendorStoreEmailVerificationConfirmation
///
/// Properties:
/// * [lockVersion]
/// * [email]
/// * [code]
@BuiltValue()
abstract class VendorStoreEmailVerificationConfirmation implements Built<VendorStoreEmailVerificationConfirmation, VendorStoreEmailVerificationConfirmationBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'code')
  String get code;

  VendorStoreEmailVerificationConfirmation._();

  factory VendorStoreEmailVerificationConfirmation([void updates(VendorStoreEmailVerificationConfirmationBuilder b)]) = _$VendorStoreEmailVerificationConfirmation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorStoreEmailVerificationConfirmationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorStoreEmailVerificationConfirmation> get serializer => _$VendorStoreEmailVerificationConfirmationSerializer();
}

class _$VendorStoreEmailVerificationConfirmationSerializer implements PrimitiveSerializer<VendorStoreEmailVerificationConfirmation> {
  @override
  final Iterable<Type> types = const [VendorStoreEmailVerificationConfirmation, _$VendorStoreEmailVerificationConfirmation];

  @override
  final String wireName = r'VendorStoreEmailVerificationConfirmation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorStoreEmailVerificationConfirmation object, {
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
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorStoreEmailVerificationConfirmation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorStoreEmailVerificationConfirmationBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorStoreEmailVerificationConfirmation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorStoreEmailVerificationConfirmationBuilder();
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


