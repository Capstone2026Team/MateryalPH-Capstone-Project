//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_rating_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_received_ratings_meta.g.dart';

/// BuyerReceivedRatingsMeta
///
/// Properties:
/// * [page]
/// * [perPage]
/// * [total]
/// * [summary]
@BuiltValue()
abstract class BuyerReceivedRatingsMeta implements Built<BuyerReceivedRatingsMeta, BuyerReceivedRatingsMetaBuilder> {
  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'per_page')
  int get perPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'summary')
  BuyerRatingSummary get summary;

  BuyerReceivedRatingsMeta._();

  factory BuyerReceivedRatingsMeta([void updates(BuyerReceivedRatingsMetaBuilder b)]) = _$BuyerReceivedRatingsMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerReceivedRatingsMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerReceivedRatingsMeta> get serializer => _$BuyerReceivedRatingsMetaSerializer();
}

class _$BuyerReceivedRatingsMetaSerializer implements PrimitiveSerializer<BuyerReceivedRatingsMeta> {
  @override
  final Iterable<Type> types = const [BuyerReceivedRatingsMeta, _$BuyerReceivedRatingsMeta];

  @override
  final String wireName = r'BuyerReceivedRatingsMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerReceivedRatingsMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(BuyerRatingSummary),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerReceivedRatingsMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerReceivedRatingsMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerRatingSummary),
          ) as BuyerRatingSummary;
          result.summary.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerReceivedRatingsMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerReceivedRatingsMetaBuilder();
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


