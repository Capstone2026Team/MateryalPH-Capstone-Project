//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/directory_buyer_profile_ratings_received.dart';
import 'package:materyalph_api_client/src/model/directory_buyer_profile_ratings_written.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_profile_ratings.g.dart';

/// DirectoryBuyerProfileRatings
///
/// Properties:
/// * [received]
/// * [written]
@BuiltValue()
abstract class DirectoryBuyerProfileRatings implements Built<DirectoryBuyerProfileRatings, DirectoryBuyerProfileRatingsBuilder> {
  @BuiltValueField(wireName: r'received')
  DirectoryBuyerProfileRatingsReceived get received;

  @BuiltValueField(wireName: r'written')
  DirectoryBuyerProfileRatingsWritten get written;

  DirectoryBuyerProfileRatings._();

  factory DirectoryBuyerProfileRatings([void updates(DirectoryBuyerProfileRatingsBuilder b)]) = _$DirectoryBuyerProfileRatings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerProfileRatingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerProfileRatings> get serializer => _$DirectoryBuyerProfileRatingsSerializer();
}

class _$DirectoryBuyerProfileRatingsSerializer implements PrimitiveSerializer<DirectoryBuyerProfileRatings> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerProfileRatings, _$DirectoryBuyerProfileRatings];

  @override
  final String wireName = r'DirectoryBuyerProfileRatings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerProfileRatings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(DirectoryBuyerProfileRatingsReceived),
    );
    yield r'written';
    yield serializers.serialize(
      object.written,
      specifiedType: const FullType(DirectoryBuyerProfileRatingsWritten),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryBuyerProfileRatings object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerProfileRatingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerProfileRatingsReceived),
          ) as DirectoryBuyerProfileRatingsReceived;
          result.received.replace(valueDes);
          break;
        case r'written':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerProfileRatingsWritten),
          ) as DirectoryBuyerProfileRatingsWritten;
          result.written.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryBuyerProfileRatings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerProfileRatingsBuilder();
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


