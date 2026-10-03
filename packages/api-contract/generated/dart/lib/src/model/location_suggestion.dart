//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'location_suggestion.g.dart';

/// LocationSuggestion
///
/// Properties:
/// * [placeId]
/// * [title]
/// * [subtitle]
@BuiltValue()
abstract class LocationSuggestion implements Built<LocationSuggestion, LocationSuggestionBuilder> {
  @BuiltValueField(wireName: r'place_id')
  String get placeId;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'subtitle')
  String? get subtitle;

  LocationSuggestion._();

  factory LocationSuggestion([void updates(LocationSuggestionBuilder b)]) = _$LocationSuggestion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LocationSuggestionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LocationSuggestion> get serializer => _$LocationSuggestionSerializer();
}

class _$LocationSuggestionSerializer implements PrimitiveSerializer<LocationSuggestion> {
  @override
  final Iterable<Type> types = const [LocationSuggestion, _$LocationSuggestion];

  @override
  final String wireName = r'LocationSuggestion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LocationSuggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'place_id';
    yield serializers.serialize(
      object.placeId,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'subtitle';
    yield object.subtitle == null ? null : serializers.serialize(
      object.subtitle,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LocationSuggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LocationSuggestionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'place_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.placeId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'subtitle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subtitle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LocationSuggestion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LocationSuggestionBuilder();
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


