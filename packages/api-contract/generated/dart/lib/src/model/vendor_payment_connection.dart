//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_payment_connection.g.dart';

/// VendorPaymentConnection
///
/// Properties:
/// * [invitationUrl]
/// * [providerAccountId]
@BuiltValue()
abstract class VendorPaymentConnection implements Built<VendorPaymentConnection, VendorPaymentConnectionBuilder> {
  @BuiltValueField(wireName: r'invitation_url')
  String get invitationUrl;

  @BuiltValueField(wireName: r'provider_account_id')
  String get providerAccountId;

  VendorPaymentConnection._();

  factory VendorPaymentConnection([void updates(VendorPaymentConnectionBuilder b)]) = _$VendorPaymentConnection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorPaymentConnectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorPaymentConnection> get serializer => _$VendorPaymentConnectionSerializer();
}

class _$VendorPaymentConnectionSerializer implements PrimitiveSerializer<VendorPaymentConnection> {
  @override
  final Iterable<Type> types = const [VendorPaymentConnection, _$VendorPaymentConnection];

  @override
  final String wireName = r'VendorPaymentConnection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorPaymentConnection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'invitation_url';
    yield serializers.serialize(
      object.invitationUrl,
      specifiedType: const FullType(String),
    );
    yield r'provider_account_id';
    yield serializers.serialize(
      object.providerAccountId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorPaymentConnection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorPaymentConnectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'invitation_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invitationUrl = valueDes;
          break;
        case r'provider_account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerAccountId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorPaymentConnection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorPaymentConnectionBuilder();
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


