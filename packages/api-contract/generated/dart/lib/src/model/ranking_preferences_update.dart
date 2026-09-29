//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/ranking_weight_set.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ranking_preferences_update.g.dart';

/// RankingPreferencesUpdate
///
/// Properties:
/// * [weights]
/// * [version]
@BuiltValue()
abstract class RankingPreferencesUpdate implements Built<RankingPreferencesUpdate, RankingPreferencesUpdateBuilder> {
  @BuiltValueField(wireName: r'weights')
  RankingWeightSet get weights;

  @BuiltValueField(wireName: r'version')
  int get version;

  RankingPreferencesUpdate._();

  factory RankingPreferencesUpdate([void updates(RankingPreferencesUpdateBuilder b)]) = _$RankingPreferencesUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RankingPreferencesUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RankingPreferencesUpdate> get serializer => _$RankingPreferencesUpdateSerializer();
}

class _$RankingPreferencesUpdateSerializer implements PrimitiveSerializer<RankingPreferencesUpdate> {
  @override
  final Iterable<Type> types = const [RankingPreferencesUpdate, _$RankingPreferencesUpdate];

  @override
  final String wireName = r'RankingPreferencesUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RankingPreferencesUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weights';
    yield serializers.serialize(
      object.weights,
      specifiedType: const FullType(RankingWeightSet),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RankingPreferencesUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RankingPreferencesUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingWeightSet),
          ) as RankingWeightSet;
          result.weights.replace(valueDes);
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RankingPreferencesUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RankingPreferencesUpdateBuilder();
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


