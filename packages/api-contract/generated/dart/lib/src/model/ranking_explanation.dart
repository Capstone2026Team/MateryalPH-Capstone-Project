//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/ranking_component.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ranking_explanation.g.dart';

/// RankingExplanation
///
/// Properties:
/// * [srs] - Search Relevance Score 0–100
/// * [components]
@BuiltValue()
abstract class RankingExplanation implements Built<RankingExplanation, RankingExplanationBuilder> {
  /// Search Relevance Score 0–100
  @BuiltValueField(wireName: r'srs')
  String get srs;

  @BuiltValueField(wireName: r'components')
  BuiltList<RankingComponent> get components;

  RankingExplanation._();

  factory RankingExplanation([void updates(RankingExplanationBuilder b)]) = _$RankingExplanation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RankingExplanationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RankingExplanation> get serializer => _$RankingExplanationSerializer();
}

class _$RankingExplanationSerializer implements PrimitiveSerializer<RankingExplanation> {
  @override
  final Iterable<Type> types = const [RankingExplanation, _$RankingExplanation];

  @override
  final String wireName = r'RankingExplanation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RankingExplanation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'srs';
    yield serializers.serialize(
      object.srs,
      specifiedType: const FullType(String),
    );
    yield r'components';
    yield serializers.serialize(
      object.components,
      specifiedType: const FullType(BuiltList, [FullType(RankingComponent)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RankingExplanation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RankingExplanationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'srs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.srs = valueDes;
          break;
        case r'components':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RankingComponent)]),
          ) as BuiltList<RankingComponent>;
          result.components.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RankingExplanation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RankingExplanationBuilder();
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


