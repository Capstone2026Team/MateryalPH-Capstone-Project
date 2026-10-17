//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_file_link.g.dart';

/// A five-minute signed URL; the fetch also re-authorizes the signed-in caller.
///
/// Properties:
/// * [url]
/// * [expiresAt]
@BuiltValue()
abstract class DisputeFileLink implements Built<DisputeFileLink, DisputeFileLinkBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  DisputeFileLink._();

  factory DisputeFileLink([void updates(DisputeFileLinkBuilder b)]) = _$DisputeFileLink;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeFileLinkBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeFileLink> get serializer => _$DisputeFileLinkSerializer();
}

class _$DisputeFileLinkSerializer implements PrimitiveSerializer<DisputeFileLink> {
  @override
  final Iterable<Type> types = const [DisputeFileLink, _$DisputeFileLink];

  @override
  final String wireName = r'DisputeFileLink';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeFileLink object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeFileLink object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeFileLinkBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeFileLink deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeFileLinkBuilder();
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


