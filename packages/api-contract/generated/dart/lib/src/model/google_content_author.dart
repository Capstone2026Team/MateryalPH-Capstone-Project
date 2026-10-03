//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_content_author.g.dart';

/// GoogleContentAuthor
///
/// Properties:
/// * [name]
/// * [uri]
/// * [photoUri]
@BuiltValue()
abstract class GoogleContentAuthor implements Built<GoogleContentAuthor, GoogleContentAuthorBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'uri')
  String? get uri;

  @BuiltValueField(wireName: r'photo_uri')
  String? get photoUri;

  GoogleContentAuthor._();

  factory GoogleContentAuthor([void updates(GoogleContentAuthorBuilder b)]) = _$GoogleContentAuthor;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleContentAuthorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleContentAuthor> get serializer => _$GoogleContentAuthorSerializer();
}

class _$GoogleContentAuthorSerializer implements PrimitiveSerializer<GoogleContentAuthor> {
  @override
  final Iterable<Type> types = const [GoogleContentAuthor, _$GoogleContentAuthor];

  @override
  final String wireName = r'GoogleContentAuthor';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleContentAuthor object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.uri != null) {
      yield r'uri';
      yield serializers.serialize(
        object.uri,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.photoUri != null) {
      yield r'photo_uri';
      yield serializers.serialize(
        object.photoUri,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleContentAuthor object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleContentAuthorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.uri = valueDes;
          break;
        case r'photo_uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.photoUri = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleContentAuthor deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleContentAuthorBuilder();
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


