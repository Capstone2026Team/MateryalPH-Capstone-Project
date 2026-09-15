//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_business_contact.g.dart';

/// VendorBusinessContact
///
/// Properties:
/// * [fullName]
/// * [position]
/// * [email]
/// * [telephoneE164]
/// * [authorizedRepresentative]
/// * [isPrimary]
/// * [verificationCommunication]
/// * [accountAdministrationCommunication]
/// * [generalAdministrationCommunication]
@BuiltValue()
abstract class VendorBusinessContact implements Built<VendorBusinessContact, VendorBusinessContactBuilder> {
  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'position')
  String get position;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'telephone_e164')
  String get telephoneE164;

  @BuiltValueField(wireName: r'authorized_representative')
  bool get authorizedRepresentative;

  @BuiltValueField(wireName: r'is_primary')
  bool get isPrimary;

  @BuiltValueField(wireName: r'verification_communication')
  bool get verificationCommunication;

  @BuiltValueField(wireName: r'account_administration_communication')
  bool get accountAdministrationCommunication;

  @BuiltValueField(wireName: r'general_administration_communication')
  bool get generalAdministrationCommunication;

  VendorBusinessContact._();

  factory VendorBusinessContact([void updates(VendorBusinessContactBuilder b)]) = _$VendorBusinessContact;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorBusinessContactBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorBusinessContact> get serializer => _$VendorBusinessContactSerializer();
}

class _$VendorBusinessContactSerializer implements PrimitiveSerializer<VendorBusinessContact> {
  @override
  final Iterable<Type> types = const [VendorBusinessContact, _$VendorBusinessContact];

  @override
  final String wireName = r'VendorBusinessContact';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorBusinessContact object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'telephone_e164';
    yield serializers.serialize(
      object.telephoneE164,
      specifiedType: const FullType(String),
    );
    yield r'authorized_representative';
    yield serializers.serialize(
      object.authorizedRepresentative,
      specifiedType: const FullType(bool),
    );
    yield r'is_primary';
    yield serializers.serialize(
      object.isPrimary,
      specifiedType: const FullType(bool),
    );
    yield r'verification_communication';
    yield serializers.serialize(
      object.verificationCommunication,
      specifiedType: const FullType(bool),
    );
    yield r'account_administration_communication';
    yield serializers.serialize(
      object.accountAdministrationCommunication,
      specifiedType: const FullType(bool),
    );
    yield r'general_administration_communication';
    yield serializers.serialize(
      object.generalAdministrationCommunication,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorBusinessContact object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorBusinessContactBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.position = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'telephone_e164':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.telephoneE164 = valueDes;
          break;
        case r'authorized_representative':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.authorizedRepresentative = valueDes;
          break;
        case r'is_primary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrimary = valueDes;
          break;
        case r'verification_communication':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.verificationCommunication = valueDes;
          break;
        case r'account_administration_communication':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accountAdministrationCommunication = valueDes;
          break;
        case r'general_administration_communication':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.generalAdministrationCommunication = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorBusinessContact deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorBusinessContactBuilder();
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


