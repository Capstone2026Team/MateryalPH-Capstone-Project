//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'location_autocomplete_request.g.dart';

/// LocationAutocompleteRequest
///
/// Properties:
/// * [query]
/// * [sessionToken]
@BuiltValue()
abstract class LocationAutocompleteRequest implements Built<LocationAutocompleteRequest, LocationAutocompleteRequestBuilder> {
  @BuiltValueField(wireName: r'query')
  String get query;

  @BuiltValueField(wireName: r'session_token')
  String get sessionToken;

  LocationAutocompleteRequest._();

  factory LocationAutocompleteRequest([void updates(LocationAutocompleteRequestBuilder b)]) = _$LocationAutocompleteRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LocationAutocompleteRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LocationAutocompleteRequest> get serializer => _$LocationAutocompleteRequestSerializer();
}

class _$LocationAutocompleteRequestSerializer implements PrimitiveSerializer<LocationAutocompleteRequest> {
  @override
  final Iterable<Type> types = const [LocationAutocompleteRequest, _$LocationAutocompleteRequest];

  @override
  final String wireName = r'LocationAutocompleteRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LocationAutocompleteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'query';
    yield serializers.serialize(
      object.query,
      specifiedType: const FullType(String),
    );
    yield r'session_token';
    yield serializers.serialize(
      object.sessionToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LocationAutocompleteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LocationAutocompleteRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.query = valueDes;
          break;
        case r'session_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LocationAutocompleteRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LocationAutocompleteRequestBuilder();
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


