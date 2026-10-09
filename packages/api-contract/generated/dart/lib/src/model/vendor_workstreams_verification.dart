//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_workstreams_verification.g.dart';

/// VendorWorkstreamsVerification
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class VendorWorkstreamsVerification implements Built<VendorWorkstreamsVerification, VendorWorkstreamsVerificationBuilder> {
  @BuiltValueField(wireName: r'status')
  String get status;

  VendorWorkstreamsVerification._();

  factory VendorWorkstreamsVerification([void updates(VendorWorkstreamsVerificationBuilder b)]) = _$VendorWorkstreamsVerification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorWorkstreamsVerificationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorWorkstreamsVerification> get serializer => _$VendorWorkstreamsVerificationSerializer();
}

class _$VendorWorkstreamsVerificationSerializer implements PrimitiveSerializer<VendorWorkstreamsVerification> {
  @override
  final Iterable<Type> types = const [VendorWorkstreamsVerification, _$VendorWorkstreamsVerification];

  @override
  final String wireName = r'VendorWorkstreamsVerification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorWorkstreamsVerification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorWorkstreamsVerification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorWorkstreamsVerificationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  VendorWorkstreamsVerification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorWorkstreamsVerificationBuilder();
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


