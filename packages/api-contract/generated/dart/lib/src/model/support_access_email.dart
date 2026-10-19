//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'support_access_email.g.dart';

/// SupportAccessEmail
///
/// Properties:
/// * [ticketNumber]
/// * [email]
/// * [website]
@BuiltValue()
abstract class SupportAccessEmail implements Built<SupportAccessEmail, SupportAccessEmailBuilder> {
  @BuiltValueField(wireName: r'ticket_number')
  String get ticketNumber;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'website')
  String? get website;

  SupportAccessEmail._();

  factory SupportAccessEmail([void updates(SupportAccessEmailBuilder b)]) = _$SupportAccessEmail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupportAccessEmailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupportAccessEmail> get serializer => _$SupportAccessEmailSerializer();
}

class _$SupportAccessEmailSerializer implements PrimitiveSerializer<SupportAccessEmail> {
  @override
  final Iterable<Type> types = const [SupportAccessEmail, _$SupportAccessEmail];

  @override
  final String wireName = r'SupportAccessEmail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupportAccessEmail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticket_number';
    yield serializers.serialize(
      object.ticketNumber,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    if (object.website != null) {
      yield r'website';
      yield serializers.serialize(
        object.website,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SupportAccessEmail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupportAccessEmailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticket_number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ticketNumber = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'website':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.website = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupportAccessEmail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupportAccessEmailBuilder();
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


