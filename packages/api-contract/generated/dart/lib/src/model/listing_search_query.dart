//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_search_query.g.dart';

/// ListingSearchQuery
///
/// Properties:
/// * [text]
/// * [normalized]
@BuiltValue()
abstract class ListingSearchQuery implements Built<ListingSearchQuery, ListingSearchQueryBuilder> {
  @BuiltValueField(wireName: r'text')
  String? get text;

  @BuiltValueField(wireName: r'normalized')
  String? get normalized;

  ListingSearchQuery._();

  factory ListingSearchQuery([void updates(ListingSearchQueryBuilder b)]) = _$ListingSearchQuery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingSearchQueryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingSearchQuery> get serializer => _$ListingSearchQuerySerializer();
}

class _$ListingSearchQuerySerializer implements PrimitiveSerializer<ListingSearchQuery> {
  @override
  final Iterable<Type> types = const [ListingSearchQuery, _$ListingSearchQuery];

  @override
  final String wireName = r'ListingSearchQuery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingSearchQuery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield object.text == null ? null : serializers.serialize(
      object.text,
      specifiedType: const FullType.nullable(String),
    );
    yield r'normalized';
    yield object.normalized == null ? null : serializers.serialize(
      object.normalized,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingSearchQuery object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingSearchQueryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.text = valueDes;
          break;
        case r'normalized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.normalized = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingSearchQuery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingSearchQueryBuilder();
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


