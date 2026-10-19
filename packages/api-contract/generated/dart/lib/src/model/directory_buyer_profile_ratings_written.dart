//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_profile_ratings_written.g.dart';

/// DirectoryBuyerProfileRatingsWritten
///
/// Properties:
/// * [count]
@BuiltValue()
abstract class DirectoryBuyerProfileRatingsWritten implements Built<DirectoryBuyerProfileRatingsWritten, DirectoryBuyerProfileRatingsWrittenBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  DirectoryBuyerProfileRatingsWritten._();

  factory DirectoryBuyerProfileRatingsWritten([void updates(DirectoryBuyerProfileRatingsWrittenBuilder b)]) = _$DirectoryBuyerProfileRatingsWritten;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerProfileRatingsWrittenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerProfileRatingsWritten> get serializer => _$DirectoryBuyerProfileRatingsWrittenSerializer();
}

class _$DirectoryBuyerProfileRatingsWrittenSerializer implements PrimitiveSerializer<DirectoryBuyerProfileRatingsWritten> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerProfileRatingsWritten, _$DirectoryBuyerProfileRatingsWritten];

  @override
  final String wireName = r'DirectoryBuyerProfileRatingsWritten';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerProfileRatingsWritten object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryBuyerProfileRatingsWritten object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerProfileRatingsWrittenBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryBuyerProfileRatingsWritten deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerProfileRatingsWrittenBuilder();
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


