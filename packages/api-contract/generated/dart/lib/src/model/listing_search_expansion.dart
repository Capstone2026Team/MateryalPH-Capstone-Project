//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_search_expansion.g.dart';

/// ListingSearchExpansion
///
/// Properties:
/// * [suggestedRadiusKm]
/// * [requiresConfirmation]
@BuiltValue()
abstract class ListingSearchExpansion implements Built<ListingSearchExpansion, ListingSearchExpansionBuilder> {
  @BuiltValueField(wireName: r'suggested_radius_km')
  int? get suggestedRadiusKm;

  @BuiltValueField(wireName: r'requires_confirmation')
  bool get requiresConfirmation;

  ListingSearchExpansion._();

  factory ListingSearchExpansion([void updates(ListingSearchExpansionBuilder b)]) = _$ListingSearchExpansion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingSearchExpansionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingSearchExpansion> get serializer => _$ListingSearchExpansionSerializer();
}

class _$ListingSearchExpansionSerializer implements PrimitiveSerializer<ListingSearchExpansion> {
  @override
  final Iterable<Type> types = const [ListingSearchExpansion, _$ListingSearchExpansion];

  @override
  final String wireName = r'ListingSearchExpansion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingSearchExpansion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'suggested_radius_km';
    yield object.suggestedRadiusKm == null ? null : serializers.serialize(
      object.suggestedRadiusKm,
      specifiedType: const FullType.nullable(int),
    );
    yield r'requires_confirmation';
    yield serializers.serialize(
      object.requiresConfirmation,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingSearchExpansion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingSearchExpansionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'suggested_radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.suggestedRadiusKm = valueDes;
          break;
        case r'requires_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.requiresConfirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingSearchExpansion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingSearchExpansionBuilder();
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


